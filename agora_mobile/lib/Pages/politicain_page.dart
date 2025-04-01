import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PoliticianPage extends StatelessWidget {
  const PoliticianPage({super.key});

  @override
  Widget build(BuildContext context) {
    var app_state = context.watch<AgoraAppState>();

    return Text("Politician");

  }

}