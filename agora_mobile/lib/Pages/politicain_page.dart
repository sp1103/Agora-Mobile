import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Creates a page that contains polticians 
class PoliticianPage extends StatefulWidget {
  const PoliticianPage({super.key});

  @override
  State<PoliticianPage> createState() => _PoliticianPageState();

}

class _PoliticianPageState extends State<PoliticianPage> { 

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();
    var politician = appState.itemsToDisplayPolitician;

    return ListView.builder(
      controller: _scrollController,
      itemCount: politician.length,

      itemBuilder: (context, index) {
        final item = politician[index];

        return ListTile(
          title: item.build(context),
        );
      }
    );
  }

}