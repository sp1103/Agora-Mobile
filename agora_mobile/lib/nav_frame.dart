import 'package:agora_mobile/AgoraWidgets/search_app_bar.dart';
import 'package:agora_mobile/Pages/favorites_page.dart';
import 'package:agora_mobile/Pages/glossary_page.dart';
import 'package:agora_mobile/Pages/home_page.dart';
import 'package:agora_mobile/Pages/legislation_page.dart';
import 'package:agora_mobile/Pages/politicain_page.dart';
import 'package:agora_mobile/Pages/profile_page.dart';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Creates the Nav frame and connects it to a state so that where the user is will remain constant
class NavFrame extends StatelessWidget {
  const NavFrame({super.key});

  /// All the pages for the bottom nav bar
  static const List<Widget> _widgetOptions = 
    <Widget>[
      PoliticianPage(),
      LegislationPage(),
      HomePage(),
      FavoritesPage(),
      ProfilePage()
    ];

  @override
  Widget build(BuildContext context) {

    var appState = context.watch<AgoraAppState>();

    PreferredSizeWidget? buildAppBar() {
      switch (appState.navigationIndex) {
        case 0: 
          return SearchAppBar(
            controller: appState.polticianSearchController,
            onQueryChanged: (query) {appState.searchPoliticians(query);}, 
            onClear: appState.clearSearchPolitician,
          ); 
        case 1: 
          return SearchAppBar(
            controller: appState.legislationSearchController,
            onQueryChanged: (query) {appState.searchLegislation(query);}, 
            onClear: appState.clearSearchLegislation,
          );
        default: 
          return null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: appState.detailPage == null 
        ? PopupMenuButton<String>( //If there is no details page show a menu button
          icon: Image.asset('assets/Agora_Logo.png', width: 55, height: 55),
          offset: Offset(0, 56),
          onSelected: (value) {
            switch (value) {
              case 'home':
                appState.navigationItemTapped(2);
                break;
              case 'glossary':
                appState.openDetails(GlossaryPage()); 
                break;
              case 'map':
                break;
            }
          }, 
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'home',
              child: Row(children: [Icon(Icons.home), SizedBox(width: 5), Text("Home", style: TextStyle(fontSize: 15))]),
            ),
            const PopupMenuItem(
              value: 'glossary',
              child: Row(children: [Icon(Icons.book), SizedBox(width: 5), Text("Glossary", style: TextStyle(fontSize: 15))]),
            ),
            const PopupMenuItem(
              value: 'map',
              child: Row(children: [Icon(Icons.map), SizedBox(width: 5), Text("Map", style: TextStyle(fontSize: 15))]),
            ),
          ],
        )   
        : IconButton(onPressed: appState.closeDetails, icon: Icon(Icons.arrow_back, color: Colors.black)), //If details page show back button
        title: buildAppBar() != null ? buildAppBar()! : const SizedBox.shrink(),
      ),
      // AI GENERATED CODE
      body: Stack(
        children: [
          IndexedStack(index: appState.navigationIndex, children: _widgetOptions),
          if (appState.detailPage != null)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: appState.detailPage!,
              ),
            ),
        ]
      ),
      // END AI GENERATED CODE 
      bottomNavigationBar: BottomNavigationBar( //Creates the bottom bar with the icons for the pages or the details page
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Politicians"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Legislation"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile"),
        ],
        currentIndex: appState.navigationIndex,
        showUnselectedLabels: false,
        selectedItemColor: const Color.fromARGB(255, 0, 60, 163),
        unselectedItemColor: Colors.black,
        onTap: appState.navigationItemTapped,
      ),
    );
  }  
}