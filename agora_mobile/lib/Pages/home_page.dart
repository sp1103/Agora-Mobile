import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Creates a home page that contains a mix of trending legislation and polticians
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();
    var home = appState.home;

    return ListView.builder(
      restorationId: "home",
      itemCount: home.length,

      itemBuilder: (context, index) {
        final item = home[index];

        return ListTile(
          title: item.build(context),
        );
      }
    );

  }

}