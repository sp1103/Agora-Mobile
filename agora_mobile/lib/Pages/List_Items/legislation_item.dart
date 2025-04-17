import 'package:agora_mobile/Pages/List_Items/list_item.dart';
import 'package:agora_mobile/Types/legislation.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LegislationItem implements ListItem {

  final Legislation legislation;

  LegislationItem(this.legislation);

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
                Image.network(legislation.body_image, height: 24, width: 24.04),
                Spacer(),
                Text(
                  legislation.body,
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                Spacer(flex: 20),
                Text(
                  legislation.last_action_date,
                  style: TextStyle(color:Colors.black)
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              legislation.bill_name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            SizedBox(height: 8),
            Text(legislation.summary),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: legislation.interests_arr
                .map((issueCategory) => Chip(
                  label: Text(issueCategory),
                  backgroundColor: Colors.grey.shade300,
                ))
              .toList()
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
                Spacer(flex: 20),
                Text(
                  legislation.bill_num.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}