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

    if (appState.user == null) { // If user is not signed in ask them to sign in to use favorites
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              Image.asset('assets/Agora_Logo.png',  width: 100, height: 100),
              SizedBox(height: 16),
              Text(
                "Please Sign In To Follow Polticians And Bills.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {appState.navigationItemTapped(4);}, 
                child: Text("Sign In")
              )
            ],
          ),
        ),
      );
    }

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