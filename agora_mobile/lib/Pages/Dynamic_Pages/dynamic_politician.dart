import 'package:agora_mobile/Types/politician.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DynamicPolitician extends StatelessWidget{

  final Politician politician;

  const DynamicPolitician({super.key, required this.politician});
  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Center(child: Text(appState.formatPolticianName(politician.name)))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Leadership: ${politician.current_title} "),
            Text("Chamber: ${politician.chamber}"),
            Text("Party: ${politician.party}"),
            Text("Start Date: ${politician.start_date.split("00:00:00").first.trim()}"),
            Text("State: ${politician.state}"),
            Text("District: ${politician.district}"),
          ],
        ),
      ),
    );
  }
}