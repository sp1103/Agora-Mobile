import 'package:agora_mobile/Pages/List_Items/list_item.dart';
import 'package:agora_mobile/Types/politician.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


/// This class implements an abstract ListItem. This one in particular contains a politician type and
/// has the details on how to display a single politician object. (i.e. one row of data)
class PoliticianItem implements ListItem {

  final Politician politician; //The acutual data for the object is contained in a JSON serializable type

  PoliticianItem(this.politician);

  //Builds the little card in the list for a single politician 
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(politician.gov_body_image, height: 24, width: 24.04),
                SizedBox(width: 2),
                Text(
                  politician.leadership,
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(politician.leg_image_path),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        politician.p_name,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                      SizedBox(height: 2),
                      Text(politician.summary, softWrap: true, overflow: TextOverflow.ellipsis, maxLines: 3),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  onPressed: () { appState.toggleFavorite(this); },
                  icon: Icon(appState.isFavorite(this) ? Icons.check_circle : Icons.add_circle, color: Colors.black),
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
    );
  }
}