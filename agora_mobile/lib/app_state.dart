import 'package:agora_mobile/Database/agora_remote.dart';
import 'package:agora_mobile/Pages/List_Items/legislation_item.dart';
import 'package:agora_mobile/Pages/List_Items/list_item.dart';
import 'package:agora_mobile/Pages/List_Items/politician_item.dart';
//import 'package:agora_mobile/Types/legislation.dart';
//import 'package:agora_mobile/Types/politician.dart';
import 'package:flutter/material.dart';
//import 'dart:developer'; //For testing 

class AgoraAppState extends ChangeNotifier{


  //These will be what the pages are based on
  var home = <ListItem>[]; //Items for the homepage
  var legislation = <LegislationItem>[]; //Items for the legislation page
  var politician = <PoliticianItem>[]; //Items for the politician page
  Set<ListItem> favorites = {}; //Items for the favorites page optimized for fast lookup
  var favoritesList = <ListItem>[]; //Items for the favorties page optimized for fast display

  AgoraAppState() {
    //Load Database stuff here
    getHome();
    getPolician();
    getLegislation();

    //Testing
    //_loadDummyData();
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

  // void _loadDummyData() {

  //   for (int i = 0; i < 20; i++) {

  //     //Legislation legislationDummy = Legislation(legislationID: i, billNumber: "H. R. 8281", name: "SAVE Act", shortDescription: "This bill requires individuals to provide documentary proof of U.S. citizenship in order to register to vote in federal elections.", date: DateTime(2024, 7, 10), fullContent: "h", govLevel: "US Congress", govLink: "h", state: "Federal", image: "https://tse1.mm.bing.net/th/id/OIP.DdPweGtpNTo-i9AmSE4lzwAAAA?rs=1&pid=ImgDetMain", issueCategories: ["Citizenship", "Voting"]);
  //     //Politician politicianDummy = Politician(politicianID: i, name: "Derek Brown", role: "Attorney General of Utah", imageLink: "https://s3.amazonaws.com/ballotpedia-api4/files/thumbs/200/300/Derek_Brown.jpg", sealLink: "https://ballotpedia.s3.amazonaws.com/images/thumb/1/1f/UT_Atty_Gen_logo.JPG/225px-UT_Atty_Gen_logo.JPG", shortBio: "Derek Brown (Republican Party) is the Attorney General of Utah. He assumed office on January 7, 2025. His current term ends on January 1, 2029.", state: "Utah");

  //     //home.add(LegislationItem(legislationDummy));
  //     //home.add(PoliticianItem(politicianDummy));

  //     //legislation.add(LegislationItem(legislationDummy));

  //     //politician.add(PoliticianItem(politicianDummy));
  //   }
  //   notifyListeners();
  // }

}