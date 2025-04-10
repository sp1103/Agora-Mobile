import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LegislationPage extends StatelessWidget {
  const LegislationPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();
    var legislation = appState.legislation;

    return ListView.builder(
      restorationId: "legislation",
      itemCount: legislation.length,

      itemBuilder: (context, index) {
        final item = legislation[index];

        return ListTile(
          title: item.build(context),
        );
      }
    );

  }

}