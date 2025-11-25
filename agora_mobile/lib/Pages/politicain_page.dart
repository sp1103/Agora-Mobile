import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PoliticianPage extends StatefulWidget {
  const PoliticianPage({super.key});

  @override
  State<PoliticianPage> createState() => _PoliticianPageState();
}

class _PoliticianPageState extends State<PoliticianPage> {
  final _scrollController = ScrollController();
  bool _showRefresh = false;

  void startTimer() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) setState(() => _showRefresh = true);
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final appState = context.read<AgoraAppState>();
        appState.loadMorePoliticians();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshPolitician() async {
    var appState = context.read<AgoraAppState>();
    _showRefresh = false;
    startTimer();
    await appState.getPolitcian();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();
    var politician = appState.itemsToDisplayPolitician;

    if (politician.isEmpty) {
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
                  onPressed: _refreshPolitician,
                ),
              ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshPolitician,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: politician.length + 1,
        itemBuilder: (context, index) {
          if (index == politician.length) {
            return appState.loadingPoliticians
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }

          final item = politician[index];
          return ListTile(title: item.build(context));
        },
      ),
    );
  }
}
