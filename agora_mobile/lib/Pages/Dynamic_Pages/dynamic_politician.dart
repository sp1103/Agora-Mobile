import 'package:agora_mobile/Types/politician.dart';
//import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

class DynamicPolitician extends StatelessWidget{

  final Politician politician;

  const DynamicPolitician({super.key, required this.politician});
  
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<AgoraAppState>();

    return Text(politician.p_name);
  }
}