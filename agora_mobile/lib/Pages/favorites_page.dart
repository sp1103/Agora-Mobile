import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var app_state = context.watch<AgoraAppState>();

    return Text("Favorites");

  }

}