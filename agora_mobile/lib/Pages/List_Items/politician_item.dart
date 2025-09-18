import 'package:agora_mobile/Pages/Dynamic_Pages/dynamic_politician.dart';
import 'package:agora_mobile/Pages/List_Items/list_item.dart';
import 'package:agora_mobile/Types/politician.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// This class implements an abstract ListItem. This one in particular contains a politician type and
/// has the details on how to display a single politician object. (i.e. one row of data)
class PoliticianItem implements ListItem {
  
  final Politician politician; //The acutual data for the object is contained in a JSON serializable type

  PoliticianItem(this.politician);

  @override
  bool operator ==(Object other) {
    return other is PoliticianItem && politician == other.politician;
  }

  @override
  int get hashCode => politician.hashCode;

  //Builds the little card in the list for a single politician
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {appState.openDetails(DynamicPolitician(politician: politician));},
        splashColor: Colors.blue.withAlpha(30),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset('assets/US_Seal.png', width: 24.04, height: 24),
                  SizedBox(width: 2),
                  Text(politician.current_title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: 
                    Uri.parse(politician.image_url ?? '').isAbsolute
                    ? CachedNetworkImageProvider(politician.image_url!)
                    : const AssetImage('assets/No_Photo.png'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appState.formatPolticianName(politician.name),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo),
                        ),
                        SizedBox(height: 2),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      appState.toggleFavorite(this);
                    },
                    icon: Icon(
                        appState.isFavorite(this)
                            ? Icons.check_circle
                            : Icons.add_circle,
                        color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_upward, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_downward, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
