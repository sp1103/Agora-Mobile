import 'package:agora_mobile/Database/agora_remote.dart';
import 'package:agora_mobile/Pages/List_Items/legislation_item.dart';
import 'package:agora_mobile/Pages/List_Items/list_item.dart';
import 'package:agora_mobile/Pages/List_Items/politician_item.dart';
import 'package:agora_mobile/Types/glossary_entry.dart';
import 'package:agora_mobile/Types/legislation.dart';
import 'package:agora_mobile/Types/politician.dart';
import 'package:agora_mobile/Types/topic.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/services.dart';

class AgoraAppState extends ChangeNotifier {
  //These will be what the pages are based on
  /// Items for the homepage
  var home = <ListItem>[];

  /// Items for the legislation page
  var legislation = <LegislationItem>[];

  /// Items displayed by the legislation page
  var itemsToDisplayLegislation = <LegislationItem>[];

  /// Items for the politician page
  var politician = <PoliticianItem>[];

  /// Items displayed by the politician page
  var itemsToDisplayPolitician = <PoliticianItem>[];

  /// Items for the favorites page optimized for fast lookup
  Set<Object> favorites = {};

  /// All topics for legislation
  Set<Topic> topics = {};

  /// List of all glossary entries for the glossary page
  var glossaryList = <GlossaryEntry>[];

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

  /// If the app bar of the nav frame should be displayed
  bool hideAppBar = false;

  /// If the bottom bar of the nav frame should be displayed 
  bool hideBottomBar = false;

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

  /// The filter being used for searching politicians
  String politcianFilter = "Name";

  /// The filter being used for searching legislation
  String legislationFilter = "Title";

  /// The list of politicians being searched
  List<PoliticianItem> searchedPoliticians = [];

  /// The list of legislation being searched
  List<LegislationItem> searchedLegislation = [];

  /// The controller for the legislation search bar
  TextEditingController legislationSearchController = TextEditingController();

  /// The controller for the poltician search bar
  TextEditingController polticianSearchController = TextEditingController();

  AgoraAppState() {
    //Setting up Authentication listener
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      if (_user != null) {
        getFavorites();
        getHomeUser();
      }
      notifyListeners();
    });
  }

  ///Initializes the app by loading data from the database
  Future<void> init() async {
    getHome();
    getLegislation();
    getPolitcian();
    getGlossary();
  }

  /// Intializes resources needed for sign up process
  Future<void> initSignUpProcess() async {
    getTopics();
    getPolitcianSelection();
  }

  /// Gets a list of trending polticians and legislation
  void getHome() async {
    final rawBills = AgoraRemote.fetchTrendingBills();
    final rawPolticians = AgoraRemote.fetchTrendingPoliticians();

    final res = await Future.wait([
      compute(_decodeBillsFiltered, await rawBills),
      compute(_decodePolticians, await rawPolticians)
    ]);

    final trendingBills = res[0];
    final trendingPolticians = res[1];

    interleaveRandomly([trendingBills, trendingPolticians]);

    notifyListeners();
  }

  /// Gets a list of trending polticians and legislation for a specific user
  void getHomeUser() async {
    final token = await _user!.getIdToken();
    final rawBills = AgoraRemote.fetchTrendingBillsUser(token: token!);
    final rawPolticians = AgoraRemote.fetchTrendingPoliticiansUser(token: token);

    final res = await Future.wait([
      compute(_decodeBillsFiltered, await rawBills),
      compute(_decodePolticians, await rawPolticians)
    ]);

    final trendingBills = res[0];
    final trendingPolticians = res[1];

    interleaveRandomly([trendingBills, trendingPolticians]);

    notifyListeners();
  }

  /// Gets all legislation in databse for startup
  void getLegislation() async {
    final rawBills = await AgoraRemote.fetchBills();
    legislation = await compute(_decodeBills, rawBills);
    itemsToDisplayLegislation = legislation;
    notifyListeners();
  }

  /// Loads and sorts the glossary from the json in assets folder
  void getGlossary() async {
    final raw = await rootBundle.loadString("assets/senate_glossary.json");
    final List<dynamic> data = jsonDecode(raw);
    glossaryList = data.map((e) => GlossaryEntry.fromJson(e)).toList();

    SuspensionUtil.sortListBySuspensionTag(glossaryList);
    SuspensionUtil.setShowSuspensionStatus(glossaryList);

    notifyListeners();
  }

  /// Gets all politicians in database for startup
  void getPolitcian() async {
    final rawMembers = await AgoraRemote.fetchLegisltors();
    politician = await compute(_decodePolticians, rawMembers);
    itemsToDisplayPolitician = politician;
    notifyListeners();
  }

  /// Gets all the bill topics
  void getTopics() async {
    topics = await AgoraRemote.fetchAllTopics();
    notifyListeners();
  }

  /// Gets all polticians
  void getPolitcianSelection() async {
    polticianSelecttionList = await AgoraRemote.fetchPoliticianSelection();
    notifyListeners();
  }

  /// Gets the favorites for a signed in user
  void getFavorites() async {
    final token = await _user!.getIdToken();
    final List<PoliticianItem> favoritePolticians = await AgoraRemote.fetchFollowingPoliticians(token: token!);
    final List<LegislationItem> favoriteLegislations = await AgoraRemote.fetchFollowingBills(token: token);
    favorites.addAll(favoritePolticians);
    favoritesList.addAll(favoritePolticians);
    favorites.addAll(favoriteLegislations);
    favoritesList.addAll(favoriteLegislations);
    notifyListeners();
  }

  /// Removes a favorite from the database
  void removeFavoriteFromDatabase(ListItem selected) async {
    final token = await _user!.getIdToken();

    if (selected is LegislationItem) {
      await AgoraRemote.unfollowBill(token: token!, billId: selected.legislation.bill_id);
    } else if (selected is PoliticianItem) {
      await AgoraRemote.unfollowPolitician(token: token!, bioId: selected.politician.bio_id);
    }
  }

  /// Adds a favorite from the database
  void addFavoriteFromDatabase(ListItem selected) async {
    final token = await _user!.getIdToken();

    if (selected is LegislationItem) {
      await AgoraRemote.followBill(token: token!, billId: selected.legislation.bill_id);
    } else if (selected is PoliticianItem) {
      await AgoraRemote.followPolitician(token: token!, bioId: selected.politician.bio_id);
    }
  }

  // FAVORITES OPERATIONS ------------------------------------------------------------------------------------------

  /// Adds an item to favorties list if it isn't already or removes item from favorites list otherwise
  void toggleFavorite(ListItem selected) {
    if (favorites.contains(selected)) {
      favorites.remove(selected);
      favoritesList.remove(selected);
      removeFavoriteFromDatabase(selected);
    } else {
      favorites.add(selected);
      favoritesList.add(selected);
      addFavoriteFromDatabase(selected);
    }
    notifyListeners();
  }

  /// Returns whether or not a ListItem is in the favorites set
  bool isFavorite(ListItem item) {
    return favorites.contains(item);
  }

  // NAVIGATION ---------------------------------------------------------------------------------------------------

  /// Movee from topic selection to poltician selection
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
  void openDetails(Widget page, bool hideTop, bool hideBottom) {
    hideBottomBar = hideBottom;
    hideAppBar = hideTop;
    detailPage = page;
    notifyListeners();
  }

  /// Closes the details page of an item
  void closeDetails() {
    hideBottomBar = false;
    hideAppBar = false;
    detailPage = null;
    notifyListeners();
  }

  /// Should the sign up or log in page be displayed
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
    } on FirebaseAuthException {
      //Deal with error
    }
  }

  /// Signs in a user that is registered with email and password
  Future<void> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      //Deal with error
    }
  }

  /// Signs out a user
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      _user = null;
      favorites.clear();
      favoritesList.clear();
      home.clear();

      getHome();

    } on FirebaseAuthException {
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
    await AgoraRemote.addUser(
        token: token!,
        topics: selectedTopics,
        politicians: selectedPolticians,
        district: 1,
        state: "Utah");
    clearSignUpSelection();
    getFavorites();
  }

  /// Clean up the signup selection info
  void clearSignUpSelection() {
    selectedTopics.clear();
    selectedPolticians.clear();
  }

  // SEARCHING ----------------------------------------------------------------------------------------------------

  /// Queries Databse and searches poltician by name
  Future<void> searchPoliticians(String query) async {
    searchedPoliticians = await AgoraRemote.queryPoliticians(query: 'name_search="$query"');
    itemsToDisplayPolitician = searchedPoliticians;
    notifyListeners();
  }

  /// Queries Databse and searches legislation by title
  Future<void> searchLegislation(String query) async {
    searchedLegislation = await AgoraRemote.queryLegislation(query: 'title="$query"');
    itemsToDisplayLegislation = searchedLegislation;
    notifyListeners();
  }

  /// Clears the legislation search bar and resets view
  void clearSearchLegislation() {
    itemsToDisplayLegislation = legislation;
    legislationSearchController.clear();
    searchedLegislation.clear();
    notifyListeners();
  }

  /// Clears the poltician search bar and resets view
  void clearSearchPolitician() {
    itemsToDisplayPolitician = politician;
    polticianSearchController.clear();
    searchedPoliticians.clear();
    notifyListeners();
  }

  // TOOLS --------------------------------------------------------------------------------------------------------

  /// Turn name from "Last, First M."" to "First M. Last"
  String formatPolticianName(String name) {
    final parts = name.split(",");

    final last = parts[0].trim();
    final firstAndMiddle = parts[1].trim();

    return "$firstAndMiddle $last";
  }

  /// Gets the color for the border of the image in the poltician details page
  Color getBorderColor(String party) {
    switch (party.toLowerCase()) {
      case 'republican':
        return Colors.red;
      case 'democratic':
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  //AI GENERATED CODE START
  /// Returns a properly formatted bill prefix based on the raw code.
  ///
  /// Example:
  /// - "hr" -> "H.R."
  /// - "hjres" -> "H.J.Res."
  /// - "s" -> "S."
  /// - "sjres" -> "S.J.Res."
  /// - "hconres" -> "H.Con.Res."
  /// - "sconres" -> "S.Con.Res."
  /// - "hres" -> "H.Res."
  /// - "sres" -> "S.Res."
  String formatBillPrefix(String raw) {
    final normalized = raw.toLowerCase().trim();

    const mappings = {
      'hr': 'H.R.',
      'hjres': 'H.J.Res.',
      'hconres': 'H.Con.Res.',
      'hres': 'H.Res.',
      's': 'S.',
      'sjres': 'S.J.Res.',
      'sconres': 'S.Con.Res.',
      'sres': 'S.Res.',
    };

    // Return mapped value or just capitalize the raw string as fallback
    return mappings[normalized] ?? raw.toUpperCase();
  }
  //AI GENERATED CODE END

  /// Returns false if it is a senate or true if it is house
  bool houseOrSenate(String type) {
    return type == "hr" || type == "hrjres" ||  type == "hconres" ||  type == "hres"; 
  }

  //AI GENERATED CODE START
  ///Capitilizes the first letter of each word in a string
  String titleCasePreservePunctuation(String text) {
    return text.split(RegExp(r'\s+')).map((word) {
      if (word.isEmpty) return word;
      if (word.toUpperCase() == word) return word;

      // Leading non-alnum (quotes, parentheses, punctuation)
      final leadingMatch = RegExp(r'^[^A-Za-z0-9]+').firstMatch(word);
      final leading = leadingMatch?.group(0) ?? '';

      // Trailing non-alnum
      final trailingMatch = RegExp(r'[^A-Za-z0-9]+$').firstMatch(word);
      final trailing = trailingMatch?.group(0) ?? '';

      final start = leading.length;
      final end = word.length - trailing.length;
      if (start >= end) return leading + trailing; // nothing to capitalize

      final core = word.substring(start, end);
      final capitalized =
          '${core[0].toUpperCase()}${core.length > 1 ? core.substring(1).toLowerCase() : ''}';

      return '$leading$capitalized$trailing';
    }).join(' ');
  }
  //AI GENERATED CODE END

  //AI GENERATED CODE START
  /// Interleaves multiple lists while preserving the relative order of items in each list.
  /// The resulting list is somewhat randomized between the lists.
  void interleaveRandomly(List<List<ListItem>> lists) {
    final random = Random();

    // Make a copy of each list so we can safely remove items
    final buffers = lists.map((l) => List<ListItem>.from(l)).toList();
    int added = 0;

    while (buffers.any((b) => b.isNotEmpty)) {
      // Pick a non-empty buffer at random
      final nonEmptyBuffers = buffers.where((b) => b.isNotEmpty).toList();
      final chosenBuffer =
          nonEmptyBuffers[random.nextInt(nonEmptyBuffers.length)];

      // Take the first item to preserve order, remove it from its buffer
      home.add(chosenBuffer.removeAt(0));

      if (added % 25 == 0) {
        notifyListeners(); //Nice speed imporvment
      }
    }
  }
  //AI GENERATED CODE END
}

// JSON DECODE ----------------------------------------------------------------------------------------------------

///Decodes the json response for bills for the home page
List<LegislationItem> _decodeBillsFiltered(String response) {
  final Map<String, dynamic> json = jsonDecode(response);
  final List<dynamic> data = json["bills"] ?? [];
  final items = data
      .where((json) => json is Map && json.containsKey("bill_id"))
      .map((json) {
    final legislation = Legislation.fromJson(json);
    return LegislationItem(legislation);
  }).toList();

  return items;
}

///Decodes the json response for bills
List<LegislationItem> _decodeBills(String response) {
  final List<dynamic> data = jsonDecode(response);
  final items = data
      .where((json) => json is Map && json.containsKey("bill_id"))
      .map((json) {
    final legislation = Legislation.fromJson(json);
    return LegislationItem(legislation);
  }).toList();

  return items;
}

///Decodes the json response for polticians
List<PoliticianItem> _decodePolticians(String response) {
  final Map<String, dynamic> json = jsonDecode(response);
  final List<dynamic> data = json["members"] ?? [];
  final items = data
      .where((json) => json is Map && json.containsKey("bio_id"))
      .map((json) {
    final politician = Politician.fromJson(json);
    return PoliticianItem(politician);
  }).toList();

  return items;
}
