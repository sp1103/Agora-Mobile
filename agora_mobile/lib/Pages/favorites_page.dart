import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();
    var favorites = appState.favoritesList;

    return ListView.builder(
      restorationId: "favorites",
      itemCount: favorites.length,

      itemBuilder: (context, index) {
        final item = favorites[index];

        return ListTile(
          title: item.build(context),
        );
      }
    );
  }
}