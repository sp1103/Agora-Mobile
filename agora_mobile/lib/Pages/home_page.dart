import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        if (appState.user != null) {
          appState.loadMoreUserHome();
        } else {
          appState.loadMoreHome();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshHome() async {
    var appState = context.read<AgoraAppState>();
    await appState.refreshHome();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();
    var home = appState.home;

    if (home.isEmpty) {
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
                  onPressed: _refreshHome,
                ),
              ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshHome,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: home.length + 1,
        itemBuilder: (context, index) {
          if (index == home.length) {
            return appState.loadingHome
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }

          final item = home[index];
          return ListTile(
            title: item.build(context),
          );
        },
      ),
    );
  }
}
