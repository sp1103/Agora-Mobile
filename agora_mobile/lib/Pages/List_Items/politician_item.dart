import 'package:agora_mobile/Pages/List_Items/list_item.dart';
import 'package:agora_mobile/Types/politician.dart';
import 'package:flutter/material.dart';

class PoliticianItem implements ListItem {

  final Politician politician;

  PoliticianItem(this.politician);

  @override
  Widget build(BuildContext context) {
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
                Image.network(politician.sealLink, height: 24, width: 24.04),
                SizedBox(width: 2),
                Text(
                  politician.role,
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(politician.imageLink),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        politician.name,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                      SizedBox(height: 2),
                      Text(politician.shortBio, softWrap: true, overflow: TextOverflow.ellipsis, maxLines: 3),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add_circle, color: Colors.black),
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