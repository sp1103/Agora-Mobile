import 'package:agora_mobile/Database/agora_remote.dart';
import 'package:agora_mobile/Pages/List_Items/legislation_item.dart';
import 'package:agora_mobile/Pages/List_Items/list_item.dart';
import 'package:agora_mobile/Pages/List_Items/politician_item.dart';
import 'package:agora_mobile/Types/politician.dart';
import 'package:agora_mobile/Types/topic.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  /// All topics for legislation
  Set<Topic> topics = {};
  /// As many polticians as possible
  List<Politician> polticianSelecttionList = [];
  /// Items for the favorties page optimized for fast display
  var favoritesList = <ListItem>[]; 
  /// Index of what page in navigation we are on
  int navigationIndex = 2; // Start on home page
  /// The detail page if applicable
  Widget? detailPage;
  /// The login page or the sign up page depending on which is shown
  bool isLogIn = true;
  /// Whether we need to show the sign up process or not
  bool signUpProcess = false;
  /// Whether it is time to move on from topic selection
  bool topicSelectionDone = false;
  /// Onboarding process selected topics
  var selectedTopics = <String>[];
  /// Onboarding process selected politicians 
  var selectedPolticians = <String>[];
  /// User of the app
  User? _user;
  /// Fetch user of the app
  User? get user => _user;

  AgoraAppState() {
    //Setting up Authentication listener
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  ///Initializes the app by loading data from the database
  Future<void> init() async{
    getHome();
    getLegislation();
    getPolitcian();
  }

  Future<void> initSignUpProcess() async {
    getTopics();
    getPolitcianSelection();
  }

  /// Gets a list depending on menu setting of trending
  void getHome() async{
    home.addAll(await AgoraRemote.fetchTrendingBills());
    home.addAll(await AgoraRemote.fetchTrendingPoliticians());
    notifyListeners();
  }

  /// Gets all legislation in databse for startup
  void getLegislation() async {
    legislation = await AgoraRemote.fetchBills();
    notifyListeners();
  }

  /// Gets all politicians in database for startup
  void getPolitcian() async {
    politician = await AgoraRemote.fetchLegisltors();
    notifyListeners();
  }

  void getTopics() async {
    topics = await AgoraRemote.fetchAllTopics();
    notifyListeners();
  }

  void getPolitcianSelection() async {
    polticianSelecttionList = await AgoraRemote.fetchPoliticianSelection();
    notifyListeners();
  }

  // FAVORITES OPERATIONS ------------------------------------------------------------------------------------------

  /// Adds an item to favorties list if it isn't already or removes item from favorites list otherwise
  void toggleFavorite(ListItem selected) {
    if (favorites.contains(selected)) {
      favorites.remove(selected);
      favoritesList.remove(selected);
    } else {
      favorites.add(selected);
      favoritesList.add(selected);
    }
    notifyListeners();
  }

  /// Returns whether or not a ListItem is in the favorites set
  bool isFavorite(ListItem item) {
    return favorites.contains(item);
  }

  // NAVIGATION ---------------------------------------------------------------------------------------------------

  void navigationMenuPressed() {
    //Add stuff that happens when the menu button is pressed
  }

  void changeSignUpProcessPage() {
    topicSelectionDone = true;
    notifyListeners();
  }

  /// When an icon is tapped update which view we are on
  void navigationItemTapped(int index) {
    navigationIndex = index;
    detailPage = null;
    notifyListeners();
  }

  /// Opens the details page of a selected item
  void openDetails(Widget page) {
    detailPage = page;
    notifyListeners();
  }

  /// Closes the details page of an item
  void closeDetails() {
    detailPage = null; 
    notifyListeners();
  }

  void signUpOrLogin() {
    isLogIn = !isLogIn;
    notifyListeners();
  }

  // AUTHENTICATION -----------------------------------------------------------------------------------------------

  /// Creates a new user using email and password
  Future<void> signUp(String email, String password) async {
    try {
      signUpProcess = true;
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await initSignUpProcess();
    }
    on FirebaseAuthException {
      //Deal with error
    }
  }

  /// Signs in a user that is registered with email and password
  Future<void> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    }
    on FirebaseAuthException {
      //Deal with error
    }
  }

  /// Signs out a user
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    }
    on FirebaseAuthException {
      //Deal with error
    }
  }

  /// Clean up variables from signup process since we won't need them again
  void finishSignUpProcess() async {
    signUpProcess = false;
    topicSelectionDone = false;

    topics.clear();
    polticianSelecttionList.clear();

    notifyListeners();

    final token = await _user!.getIdToken();
    print("User ID Token: $token");
    await AgoraRemote.addUser(token: token!, topics: selectedTopics, politicians: selectedPolticians, district: 1, state: "Utah");
  }

}