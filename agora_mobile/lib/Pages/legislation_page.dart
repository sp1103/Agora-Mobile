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
  bool _showRefresh = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) setState(() => _showRefresh = true);
    });

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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_showRefresh)
              const CircularProgressIndicator(),
            if (_showRefresh)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: IconButton(
                  icon: const Icon(Icons.refresh, size: 50),
                  onPressed: _refreshLegislation,
                ),
              ),
          ],
        ),
      );
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
