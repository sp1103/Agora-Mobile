import 'package:agora_mobile/Pages/Tab_Views/favorites_list_tab.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:agora_mobile/Pages/List_Items/list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();
    var favorites = appState.favoritesList;

    if (appState.user == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              Image.asset('assets/Agora_Logo.png', width: 100, height: 100),
              SizedBox(height: 16),
              Text(
                "Please Sign In To Follow Politicians And Bills.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  appState.navigationItemTapped(4);
                },
                child: Text("Sign In"),
              ),
            ],
          ),
        ),
      );
    }

    // Filter favorites by type
    List<ListItem> politicians = favorites.where((item) => item.runtimeType.toString() == 'PoliticianItem').toList();
    List<ListItem> legislation = favorites.where((item) => item.runtimeType.toString() == 'LegislationItem').toList();
    List<ListItem> topics = favorites.where((item) => item.runtimeType.toString() == 'TopicItem').toList();

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Politicians'),
            Tab(text: 'Legislation'),
            Tab(text: 'Topics'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              FavoritesListTab(favorites: politicians),
              FavoritesListTab(favorites: legislation),
              FavoritesListTab(favorites: topics, isTopic: true, allTopics: appState.topics.toList()),
            ],
          ),
        ),
      ],
    );
  }
}
