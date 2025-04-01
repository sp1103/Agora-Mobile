import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LegislationPage extends StatelessWidget {
  const LegislationPage({super.key});

  @override
  Widget build(BuildContext context) {
    var app_state = context.watch<AgoraAppState>();

    return Text("Legislation");

  }

}