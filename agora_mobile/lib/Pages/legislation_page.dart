import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Creates a page that contains legislation
class LegislationPage extends StatefulWidget {
  const LegislationPage({super.key});

  @override
  State<LegislationPage> createState() => _LegislationPageState();

}

class _LegislationPageState extends State<LegislationPage> { 

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();
    var legislation = appState.itemsToDisplayLegislation;

    return ListView.builder(
      controller: _scrollController,
      itemCount: legislation.length,

      itemBuilder: (context, index) {
        final item = legislation[index];

        return ListTile(
          title: item.build(context),
        );
      }
    );
  }

}