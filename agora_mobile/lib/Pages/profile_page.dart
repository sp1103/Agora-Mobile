import 'package:agora_mobile/Pages/Account_Pages/log_in.dart';
import 'package:agora_mobile/Pages/Account_Pages/profile.dart';
import 'package:agora_mobile/Pages/Account_Pages/sign_up.dart';
import 'package:agora_mobile/Pages/Sign_Up_Process_Pages/politician_selection_page.dart';
import 'package:agora_mobile/Pages/Sign_Up_Process_Pages/topic_selection_page.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Creates a page that allows a user to sign in and access their profile
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();

    if (appState.user == null && appState.isLogIn && !appState.signUpProcess) {
      return LogIn();
    }
    else if (appState.user == null && !appState.isLogIn && !appState.signUpProcess) {
      return SignUp();
    }
    else if (appState.signUpProcess && appState.topicSelectionDone) {
      return PoliticianSelectionPage();
    }
    else if (appState.signUpProcess) {
      return TopicSelectionPage();
    }
    return UserProfile();
  }
}