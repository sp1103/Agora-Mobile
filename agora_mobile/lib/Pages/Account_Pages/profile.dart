import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This is the actual user profile page
class UserProfile extends StatelessWidget {
  const UserProfile({super.key});
  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();

    return Scaffold(
      body: Column(
        children: [
          Text("Hello ${appState.user?.email ?? '?'}"),
          Padding(
                padding: const EdgeInsets.all(28.0),
                child: ElevatedButton(
                  onPressed: () {
                    appState.signOut();
                  }, 
                  child: Text("Sign Out"))
              ),
        ],
      ),
    );
  }
}