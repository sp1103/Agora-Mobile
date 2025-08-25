import 'package:agora_mobile/Database/agora_remote.dart';
import 'package:agora_mobile/Pages/List_Items/legislation_item.dart';
import 'package:agora_mobile/Pages/List_Items/list_item.dart';
import 'package:agora_mobile/Pages/List_Items/politician_item.dart';
import 'package:flutter/material.dart';

class AgoraAppState extends ChangeNotifier{


  //These will be what the pages are based on
  /// Items for the homepage
  var home = <ListItem>[]; 
  /// Items for the legislation page
  var legislation = <LegislationItem>[];
  /// Items for the politician page
  var politician = <PoliticianItem>[]; 
  /// Items for the favorites page optimized for fast lookup
  Set<Object> favorites = {}; 
  /// Items for the favorties page optimized for fast display
  var favoritesList = <ListItem>[]; 

  AgoraAppState() {
    //Load Database stuff here
    getHome();
    getPolician();
    getLegislation();
  }

  /// Gets a list depending on menu setting of trending
  void getHome() async{
    home.addAll(await AgoraRemote.fetchTrendingBills());
    //home.addAll(await AgoraRemote.fetchTrendingPoliticians());
    notifyListeners();
  }

  /// Gets all legislation in databse for startup
  void getLegislation() async {
    legislation = await AgoraRemote.fetchBills();
  }

  /// Gets all politicians in database for startup
  void getPolician() async {
    politician = await AgoraRemote.fetchLegisltors();
  }

  // FAVORITES OPERATIONS ------------------------------------------------------------------------------------------

  /// Adds an item to favorties list if it isn't already or removes item from favorites list otherwise
  void toggleFavorite(ListItem selected) {
    if (favorites.contains(selected)) {
      favorites.remove(selected);
      favoritesList.remove(selected);
      //update local database
    } else {
      favorites.add(selected);
      favoritesList.add(selected);
      //update local database
    }
    notifyListeners();
  }

  /// Returns whether or not a ListItem is in the favorites set
  bool isFavorite(ListItem item) {
    return favorites.contains(item);
  }

  // NAVIGATION ---------------------------------------------------------------------------------------------------

  

}