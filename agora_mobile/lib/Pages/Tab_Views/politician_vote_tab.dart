import 'package:agora_mobile/Pages/List_Items/vote_item.dart';
import 'package:agora_mobile/Types/votes.dart';
import 'package:flutter/material.dart';

/// Creates a page that contains polticians votes
class PoliticianVoteTab extends StatefulWidget {
  final List<Vote> votes;

  const PoliticianVoteTab({super.key, required this.votes});

  @override
  State<PoliticianVoteTab> createState() => _PoliticianVoteTabState();

}

class _PoliticianVoteTabState extends State<PoliticianVoteTab> { 

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.votes.length,

      itemBuilder: (context, index) {
        final vote = widget.votes[index];

        return ListTile(
          title: VoteItem(vote).build(context),
        );
      }
    );
  }
}