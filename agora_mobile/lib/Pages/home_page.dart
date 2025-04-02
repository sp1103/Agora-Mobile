//import 'package:agora_mobile/Pages/List_Items/legislation_item.dart';
//import 'package:agora_mobile/Types/legislation.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var app_state = context.watch<AgoraAppState>();

    return Text("Home");

  }

}