import 'dart:async';

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
  bool _timedOut = false;
  Timer? _timer;

  @override void initState() { 
    super.initState(); 
    // Fetch votes only once 
    final appState = context.read<AgoraAppState>(); 
    appState.getVotes(widget.poltician.bio_id); 

    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _timedOut = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();
    var votes = appState.votes;

    if (votes.isEmpty) {
      if (_timedOut) {
        return const Center(
          child: Text(
            "No Voting History Available.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return const Center( child: CircularProgressIndicator());
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: votes.length,

      itemBuilder: (context, index) {
        final vote = votes[index];

        return ListTile(
          title: VoteItem(vote).build(context),
        );
      }
    );
  }
}