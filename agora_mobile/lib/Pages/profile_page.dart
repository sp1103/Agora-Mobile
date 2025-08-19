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

    return Text("Profile");

  }

}