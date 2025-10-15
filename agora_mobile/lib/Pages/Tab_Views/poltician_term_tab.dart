import 'package:agora_mobile/Pages/List_Items/term_item.dart';
import 'package:agora_mobile/Types/term.dart';
import 'package:flutter/material.dart';

/// Creates a page that contains polticians terms
class PoliticianTermTab extends StatefulWidget {
  final List<Term> terms;

  const PoliticianTermTab({super.key, required this.terms});

  @override
  State<PoliticianTermTab> createState() => _PoliticianTermTabState();

}

class _PoliticianTermTabState extends State<PoliticianTermTab> { 

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.terms.length,

      itemBuilder: (context, index) {
        final term = widget.terms[index];

        return ListTile(
          title: TermItem(term).build(context),
        );
      }
    );
  }
}