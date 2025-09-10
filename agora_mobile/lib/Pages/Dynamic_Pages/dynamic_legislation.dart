import 'package:agora_mobile/Types/legislation.dart';
//import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
//import 'package:provider/provider.dart';

class DynamicLegislation extends StatelessWidget{

  final Legislation legislation;

  const DynamicLegislation({super.key, required this.legislation});
  
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<AgoraAppState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(legislation.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Introduction Date: ${legislation.intro_date.split("00:00:00").first.trim()}"),
            Text("Bill Number: ${legislation.number}"),
            Text("Status: ${legislation.status}"),
            Text("Date Of Most Recent Action: ${legislation.status_update_date.split("00:00:00").first.trim()}"),
            Html(data: legislation.summary),
          ],
        ),
      ),
    );
  }

}