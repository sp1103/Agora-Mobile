import 'package:agora_mobile/Pages/List_Items/vote_item.dart';
import 'package:agora_mobile/Types/politician.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Creates a page that contains polticians votes
class PoliticianVoteTab extends StatefulWidget {
  final Politician poltician;

  const PoliticianVoteTab({super.key, required this.poltician});

  @override
  State<PoliticianVoteTab> createState() => _PoliticianVoteTabState();

}

class _PoliticianVoteTabState extends State<PoliticianVoteTab> { 

  final _scrollController = ScrollController();

  @override void initState() { 
    super.initState(); 
    // Fetch votes only once 
    final appState = context.read<AgoraAppState>(); 
    appState.getVotes(widget.poltician.bio_id); 
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();

    return ListView.builder(
      controller: _scrollController,
      itemCount: appState.votes.length,

      itemBuilder: (context, index) {
        final vote = appState.votes[index];

        return ListTile(
          title: VoteItem(vote).build(context),
        );
      }
    );
  }
}