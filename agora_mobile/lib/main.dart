import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'nav_frame.dart';

///Starts Agora. Does Nothing else.
void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  runApp(Agora());
}

///Simply creates the nav_frame which will hold the pages
class Agora extends StatelessWidget {
  const Agora({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AgoraAppState(),
      child: MaterialApp(
        title: 'Agora Entry',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: NavFrame()
      ),
    );
  }
}