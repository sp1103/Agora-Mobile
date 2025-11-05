import 'package:agora_mobile/Pages/List_Items/list_item.dart';
import 'package:agora_mobile/Types/topic.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopicItem implements ListItem{
  final Topic topic;

  const TopicItem(this.topic);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                topic.topic_name,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo),
              ),
            ),
            Spacer(flex: 1),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  appState.toggleTopics(this);
                },
                icon: Icon(
                    appState.isFollowingTopic(this)
                        ? Icons.check_circle
                        : Icons.add_circle,
                    color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
