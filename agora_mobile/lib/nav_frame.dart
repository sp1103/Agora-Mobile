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
      FavoritesPage(),
      HomePage(),
      LegislationPage(),
      ProfilePage()
    ];

  @override
  Widget build(BuildContext context) {

    var appState = context.watch<AgoraAppState>();

    return Scaffold(
      appBar: AppBar(
        leading: appState.detailPage == null 
        ? IconButton(onPressed: appState.navigationMenuPressed, icon: Icon(Icons.menu, color: Colors.black)) //If there is no details page show a menu button
        : IconButton(onPressed: appState.closeDetails, icon: Icon(Icons.arrow_back, color: Colors.black)), //If details page show back button
        title: Image.asset('assets/Agora_Logo.png', width: 55, height: 55), //Adds the Agora logo
        
      ),
      body: Center(child: appState.detailPage ?? _widgetOptions.elementAt(appState.navigationIndex)), //Creates the bottom bar with the icons for the pages or the details page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Politicians"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Legislation"),
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