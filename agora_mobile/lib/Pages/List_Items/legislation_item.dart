import 'package:agora_mobile/Pages/Dynamic_Pages/dynamic_legislation.dart';
import 'package:agora_mobile/Pages/List_Items/list_item.dart';
import 'package:agora_mobile/Types/legislation.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

/// This class implements an abstract ListItem. This one in particular contains a legislation type and
/// has the details on how to display a single legislation object. (i.e. one row of data)
class LegislationItem implements ListItem {
  
  final Legislation legislation; //The acutual data for the object is contained in a JSON serializable type

  LegislationItem(this.legislation);

  @override
  bool operator ==(Object other) {
    return other is LegislationItem && legislation == other.legislation;
  }

  @override
  int get hashCode => legislation.hashCode;

  //Builds the little card in the list for a single legislation
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {appState.openDetails(DynamicLegislation(legislation: legislation));},
        splashColor: Colors.blue.withAlpha(30),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset('assets/US_Seal.png', width: 24.04, height: 24),
                  Spacer(),
                  Text(
                    legislation.type == "s"
                    ? "Senate"
                    : "House of Repersentatives",
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  Spacer(flex: 2),
                  // Text(
                  //   legislation.last_action_date,
                  //   style: TextStyle(color:Colors.black)
                  // ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                legislation.title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo),
              ),
              SizedBox(height: 8),
              SizedBox(height: 100, child: Html(data: legislation.summary)),
              SizedBox(height: 8),
              // Wrap(
              //     spacing: 8,
              //     children: legislation.interests_arr
              //         .map((issueCategory) => Chip(
              //               label: Text(issueCategory),
              //               backgroundColor: Colors.grey.shade300,
              //             ))
              //         .toList()),
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
                  Spacer(flex: 20),
                  Text(
                    legislation.number.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
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
