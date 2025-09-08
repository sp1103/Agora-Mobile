import 'package:agora_mobile/Types/legislation.dart';
//import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

class DynamicLegislation extends StatelessWidget{

  final Legislation legislation;

  const DynamicLegislation({super.key, required this.legislation});
  
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<AgoraAppState>();

    return Text(legislation.title);
  }

}