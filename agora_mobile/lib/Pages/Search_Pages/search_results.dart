import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Creates a home page that contains a mix of trending legislation and polticians
class SearchResults extends StatefulWidget {
  final String query;

  const SearchResults({super.key, required this.query});

  @override
  State<SearchResults> createState() => _SearchResultsState();

}

class _SearchResultsState extends State<SearchResults> { 

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();
    var results = appState.searchResults;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: appState.closeDetails, icon: Icon(Icons.arrow_back, color: Colors.black)),
        title: Text(widget.query),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: results.length,

        itemBuilder: (context, index) {
          final item = results[index];

          return ListTile(
            title: item.build(context),
          );
        }
      ),
    );
  }

}