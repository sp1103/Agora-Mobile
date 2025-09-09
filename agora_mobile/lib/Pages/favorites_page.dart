import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Creates the favorites page where items that had favorite toggled on will appear
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();

}

class _FavoritesPageState extends State<FavoritesPage> { 

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();
    var favorites = appState.favoritesList;

    return ListView.builder(
      controller: _scrollController,
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