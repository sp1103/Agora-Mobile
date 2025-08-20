import 'package:agora_mobile/Database/agora_remote.dart';
import 'package:agora_mobile/Pages/List_Items/legislation_item.dart';
import 'package:agora_mobile/Pages/List_Items/list_item.dart';
import 'package:agora_mobile/Pages/List_Items/politician_item.dart';
import 'package:flutter/material.dart';
//For testing 
//import 'dart:developer';
import 'package:agora_mobile/Types/legislation.dart';
import 'package:agora_mobile/Types/politician.dart';

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
    // getHome();
    // getPolician();
    // getLegislation();

    //Testing
    _loadDummyData();
  }

  /// Gets a list depending on menu setting of trending
  void getHome() async{
    home = await AgoraRemote.fetchTrendingBills();
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



// TESTING -----------------------------------------------------------------------------------------------------

  void _loadDummyData() {

    for (int i = 0; i < 20; i++) {

      Legislation legislationDummy = Legislation(bill_id: i, bill_num: 8281, bill_name: "SAVE Act", summary: "This bill requires individuals to provide documentary proof of U.S. citizenship in order to register to vote in federal elections.", last_action_date: "7-10-24", fullContent: "h", bill_origin: "US Congress", govLink: "h", state: "Federal");
      Politician politicianDummy = Politician(pID: i, p_name: "Derek Brown", leadership: "Attorney General of Utah", leg_image_path: "https://s3.amazonaws.com/ballotpedia-api4/files/thumbs/200/300/Derek_Brown.jpg");
      home.add(LegislationItem(legislationDummy));
      home.add(PoliticianItem(politicianDummy));

      legislation.add(LegislationItem(legislationDummy));

      politician.add(PoliticianItem(politicianDummy));
    }
    notifyListeners();
  }

}