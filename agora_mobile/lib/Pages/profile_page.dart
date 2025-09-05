import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Creates a page that allows a user to sign in and access their profile
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var appState = context.watch<AgoraAppState>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: Column(
          children: [
            Center(
              child: Row(
                children: [
                  Image.asset('assets/Agora_Logo.png', width: 100, height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}