import 'package:agora_mobile/Pages/Dynamic_Pages/dynamic_legislation.dart';
import 'package:agora_mobile/Pages/List_Items/list_item.dart';
import 'package:agora_mobile/Types/votes.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This class implements an abstract ListItem. This one in particular contains a vote type and
/// has the details on how to display a single vote object. (i.e. one row of data)
class VoteItem implements ListItem {
  
  final Vote vote; //The acutual data for the object is contained in a JSON serializable type

  VoteItem(this.vote);

  //Builds the little card in the list for a single vote
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {appState.openDetails(DynamicLegislation(legislation: vote.bill), true, false);},
        splashColor: Colors.blue.withAlpha(30),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vote.bill.title,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo),
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                          "${appState.formatBillPrefix(vote.bill.type)}${vote.bill.number.toString()}",
                          style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Spacer(flex: 1),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: appState.voteColor(vote.vote_cast),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    appState.titleCasePreservePunctuation(vote.vote_cast),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
