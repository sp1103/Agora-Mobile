import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Creates a page that contains polticians 
class PoliticianPage extends StatelessWidget {
  const PoliticianPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();
    var politician = appState.politician;

    return ListView.builder(
      restorationId: "politician",
      itemCount: politician.length,

      itemBuilder: (context, index) {
        final item = politician[index];

        return ListTile(
          title: item.build(context),
        );
      }
    );

  }

}