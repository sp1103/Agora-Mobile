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

  @override
  void initState() {
    super.initState();

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
      return const Center(child: CircularProgressIndicator());
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
