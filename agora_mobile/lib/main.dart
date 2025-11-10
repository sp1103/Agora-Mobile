import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'nav_frame.dart';
import 'error_handler.dart'; 

/// Starts Agora. Does Nothing else.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final appState = AgoraAppState();
  appState.init();

  runApp(Agora(appState: appState));
}

/// Simply creates the nav_frame which will hold the pages
class Agora extends StatelessWidget {
  final AgoraAppState appState;
  const Agora({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Agora Entry',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: ErrorHandler.attachToApp(NavFrame()),
      ),
    );
  }
}