import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LegislationPage extends StatefulWidget {
  const LegislationPage({super.key});

  @override
  State<LegislationPage> createState() => _LegislationPageState();
}

class _LegislationPageState extends State<LegislationPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final appState = context.read<AgoraAppState>();
        appState.loadMoreBills();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshLegislation() async {
    var appState = context.read<AgoraAppState>();
    await appState.getLegislation();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();
    var legislation = appState.itemsToDisplayLegislation;

    if (legislation.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _refreshLegislation,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: legislation.length + 1,
        itemBuilder: (context, index) {
          if (index == legislation.length) {
            return appState.loadingBills
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }

          final item = legislation[index];
          return ListTile(title: item.build(context));
        },
      ),
    );
  }
}
