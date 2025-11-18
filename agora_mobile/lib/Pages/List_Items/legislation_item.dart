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
        onTap: () {appState.openDetails(DynamicLegislation(legislation: legislation), true, false);},
        splashColor: Colors.blue.withAlpha(30),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  appState.houseOrSenate(legislation.type)
                  ? (legislation.type == "HB"
                    ? Image.asset('assets/u-h.png', width: 24.04, height: 24)
                    : Image.asset('assets/us-h.png', width: 24.04, height: 24))
                  : (legislation.type == "SB"
                    ? Image.asset('assets/u-s.png', width: 24.04, height: 24)
                    : Image.asset('assets/us-s.png', width: 24.04, height: 24)),
                  SizedBox(width: 10),
                  Text(
                    appState.houseOrSenate(legislation.type)
                    ? (legislation.type == "HB"
                      ? "Utah House of Reps"
                      : "House of Repersentatives")
                    : (legislation.type == "SB"
                      ? "Utah Senate"
                      : "Senate"),
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  Spacer(flex: 2),
                  Text(
                    legislation.intro_date.split("00:00:00").first.trim(),
                    style: TextStyle(color:Colors.black)
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                legislation.title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo),
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              SizedBox(height: 100, child: Html(data: legislation.summary)),
              SizedBox(height: 8),
              Wrap(
                  spacing: 8,
                  children: legislation.topics
                      .take(3)
                      .map((topic) => Chip(
                            label: Text(topic.topic_name),
                            backgroundColor: Colors.grey.shade300,
                          ))
                      .toList()),
              SizedBox(height: 10),
              Row(
                children: [
                  if (appState.user != null) ...[
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
                  ],
                  Spacer(flex: 20),
                  Text(
                    "${appState.formatBillPrefix(legislation.type)}${legislation.number.toString()}",
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
