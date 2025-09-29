import 'package:agora_mobile/AgoraWidgets/search_app_bar.dart';
import 'package:agora_mobile/Pages/favorites_page.dart';
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
        ? IconButton(onPressed: appState.navigationMenuPressed, icon: Image.asset('assets/Agora_Logo.png', width: 55, height: 55)) //If there is no details page show a menu button
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