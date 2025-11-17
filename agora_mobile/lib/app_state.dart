import 'package:agora_mobile/Database/agora_remote.dart';
import 'package:agora_mobile/Pages/List_Items/legislation_item.dart';
import 'package:agora_mobile/Pages/List_Items/list_item.dart';
import 'package:agora_mobile/Pages/List_Items/politician_item.dart';
import 'package:agora_mobile/Pages/List_Items/topic_item.dart';
import 'package:agora_mobile/Pages/Search_Pages/search_results.dart';
import 'package:agora_mobile/Types/glossary_entry.dart';
import 'package:agora_mobile/Types/legislation.dart';
import 'package:agora_mobile/Types/politician.dart';
import 'package:agora_mobile/Types/topic.dart';
import 'package:agora_mobile/Types/votes.dart';
import 'package:agora_mobile/Types/chat_message.dart';
import 'package:agora_mobile/error_handler.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:agora_mobile/Database/network_helper.dart';

class AgoraAppState extends ChangeNotifier {
  //These will be what the pages are based on
  /// Items for the homepage
  var home = <ListItem>[];

  /// Items for display from advanced search
  var searchResults = <ListItem>[];

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

  /// Set of the ids that the user is following
  Set<int> userTopicIds = {};

  /// List of all glossary entries for the glossary page
  var glossaryList = <GlossaryEntry>[];

  /// As many polticians as possible
  List<Politician> polticianSelecttionList = [];

  /// Items for the favorties page optimized for fast display
  var favoritesList = <ListItem>[];

  /// Index of what page in navigation we are on
  int navigationIndex = 2; // Start on home page

  /// The detail page if applicable
  List<Widget> detailPage = [];

  /// List of a polticians votes
  List<Vote> votes = [];

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

  /// Whether it is time to move to map step
  bool mapStep = false;

  ///Whether or not legislation is trying to get more data
  bool loadingBills = false;

  ///Whether or not home is trying to get more data
  bool loadingHome = false;

  ///Whether or not politicians is trying to get more data
  bool loadingPoliticians = false;

  /// Onboarding process selected topics
  var selectedTopics = <String>[];

  /// Onboarding process selected politicians
  var selectedPolticians = <String>[];

  /// Onboarding process selected state
  String selectedState = "";

  /// Onboarding process selected district
  String selectedDistrict = "";

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

  /// Temporarily stores password during onboarding
  String? _password;

  /// Temporarily stores email during onboarding
  String? _email;

  /// The controller for the legislation search bar
  TextEditingController legislationSearchController = TextEditingController();

  /// The controller for the poltician search bar
  TextEditingController polticianSearchController = TextEditingController();

  ///The map for the chat history
  Map<int, List<ChatMessage>> _chatHistory = {};

  /// Is chat loading
  bool _chatLoading = false;

  /// Is error with chat
  String? _chatError;

  AgoraAppState() {
    //Setting up Authentication listener
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      if (_user != null) {
        getFavorites();
        getHomeUser();
        getUserTopics();
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
    getTopics();
  }

  /// Intializes resources needed for sign up process
  Future<void> initSignUpProcess() async {
    getPolitcianSelection();
  }

  /// Gets a list of trending polticians and legislation
  Future<void> getHome() async {
    try {
      final rawBills = AgoraRemote.fetchTrendingBills(numToReturn: 50);
      final rawPolticians =
          AgoraRemote.fetchTrendingPoliticians(numToReturn: 50);

      final res = await Future.wait([
        compute(_decodeBillsFiltered, await rawBills),
        compute(_decodePolticians, await rawPolticians)
      ]);

      final trendingBills = res[0];
      final trendingPolticians = res[1];

      interleaveRandomly([trendingBills, trendingPolticians]);
    } on NetworkException catch (e) {
      ErrorHandler.showError(e.message, level: ErrorLevel.warning);
    } finally {
      notifyListeners();
    }
  }

  ///Get polticians votes
  void getVotes(String bioId) async {
    try {
      votes.clear();
      votes = await AgoraRemote.fetchVotes(bioId, 100);
    } on NetworkException catch (e) {
      ErrorHandler.showError(e.message, level: ErrorLevel.warning);
    } finally {
      notifyListeners();
    }
  }

  /// Gets a list of trending polticians and legislation for a specific user
  Future<void> getHomeUser() async {
    try {
      final token = await _user!.getIdToken();
      final rawBills =
          AgoraRemote.fetchTrendingBillsUser(token: token!, numToReturn: 50);
      final rawPolticians = AgoraRemote.fetchTrendingPoliticiansUser(
          token: token, numToReturn: 50);

      final res = await Future.wait([
        compute(_decodeBillsFiltered, await rawBills),
        compute(_decodePolticians, await rawPolticians)
      ]);

      final trendingBills = res[0];
      final trendingPolticians = res[1];

      interleaveRandomly([trendingBills, trendingPolticians]);
    } on NetworkException catch (e) {
      ErrorHandler.showError(e.message, level: ErrorLevel.warning);
    } finally {
      notifyListeners();
    }
  }

  /// Gets all legislation in databse for startup
  Future<void> getLegislation() async {
    try {
      final rawBills = await AgoraRemote.fetchBills(numToReturn: 100);
      legislation = await compute(_decodeBills, rawBills);
      itemsToDisplayLegislation = legislation;
    } on NetworkException catch (e) {
      ErrorHandler.showError(e.message, level: ErrorLevel.warning);
    } finally {
      notifyListeners();
    }
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
  Future<void> getPolitcian() async {
    try {
      final rawMembers = await AgoraRemote.fetchLegisltors(numToReturn: 100);
      politician = await compute(_decodePolticians, rawMembers);
      itemsToDisplayPolitician = politician;
    } on NetworkException catch (e) {
      ErrorHandler.showError(e.message, level: ErrorLevel.warning);
    } finally {
      notifyListeners();
    }
  }

  /// Gets all the bill topics
  void getTopics() async {
    try {
      topics = await AgoraRemote.fetchAllTopics();
    } on NetworkException catch (e) {
      ErrorHandler.showError(e.message, level: ErrorLevel.warning);
    } finally {
      notifyListeners();
    }
  }

  Future<Politician?> queryPoliticianByBioId(String bioId) async {
    try {
      // Query your database/API to get full politician data
      final politician = await AgoraRemote.queryBioId(bioId: bioId);
      return politician;
    } on NetworkException catch (e) {
      ErrorHandler.showError(e.message, level: ErrorLevel.warning);
      return null;
    } catch (e) {
      ErrorHandler.showError("No Politician Page Available", level: ErrorLevel.info);
      return null;
    }
  }

  /// Gets the list of topics user is following
  void getUserTopics() async {
    try {
      final token = await _user!.getIdToken();

      Map<int, TopicItem> topicMap =
          await AgoraRemote.fetchFollowingTopics(token: token!);
      favoritesList.addAll(topicMap.values);
      userTopicIds.addAll(topicMap.keys);
    } on NetworkException catch (e) {
      ErrorHandler.showError(e.message, level: ErrorLevel.warning);
    } finally {
      notifyListeners();
    }
  }

  /// Gets all polticians
  void getPolitcianSelection() async {
    try {
      polticianSelecttionList = await AgoraRemote.fetchPoliticianSelection();
    } on NetworkException catch (e) {
      ErrorHandler.showError(e.message, level: ErrorLevel.warning);
    } finally {
      notifyListeners();
    }
  }

  /// Gets the favorites for a signed in user
  void getFavorites() async {
    try {
      final token = await _user!.getIdToken();
      final List<PoliticianItem> favoritePolticians =
          await AgoraRemote.fetchFollowingPoliticians(token: token!);
      final List<LegislationItem> favoriteLegislations =
          await AgoraRemote.fetchFollowingBills(token: token);
      favorites.addAll(favoritePolticians);
      favoritesList.addAll(favoritePolticians);
      favorites.addAll(favoriteLegislations);
      favoritesList.addAll(favoriteLegislations);
    } on NetworkException catch (e) {
      ErrorHandler.showError(e.message, level: ErrorLevel.warning);
    } finally {
      notifyListeners();
    }
  }

  /// Updates to topics in the database
  void updateTopicsInDatabase() async {
    try {
      final token = await _user!.getIdToken();

      await AgoraRemote.updateTopics(
          token: token!, topics: userTopicIds.toList());
    } on NetworkException catch (e) {
      ErrorHandler.showError(e.message, level: ErrorLevel.warning);
    }
  }

  /// Removes a favorite from the database
  void removeFavoriteFromDatabase(ListItem selected) async {
    try {
      final token = await _user!.getIdToken();

      if (selected is LegislationItem) {
        await AgoraRemote.unfollowBill(
            token: token!, billId: selected.legislation.bill_id);
      } else if (selected is PoliticianItem) {
        await AgoraRemote.unfollowPolitician(
            token: token!, bioId: selected.politician.bio_id);
      }
    } on NetworkException catch (e) {
      ErrorHandler.showError(e.message, level: ErrorLevel.warning);
    }
  }

  /// Adds a favorite from the database
  void addFavoriteFromDatabase(ListItem selected) async {
    try {
      final token = await _user!.getIdToken();

      if (selected is LegislationItem) {
        await AgoraRemote.followBill(
            token: token!, billId: selected.legislation.bill_id);
      } else if (selected is PoliticianItem) {
        await AgoraRemote.followPolitician(
            token: token!, bioId: selected.politician.bio_id);
      }
    } on NetworkException catch (e) {
      ErrorHandler.showError(e.message, level: ErrorLevel.warning);
    }
  }

  // REFRESH AND PAGANATION OPERATIONS -----------------------------------------------------------------------------

  /// Clears home list and then refreshes home
  Future<void> refreshHome() async {
    home.clear();
    if (user != null) {
      await getHomeUser();
    } else {
      await getHome();
    }
  }

  /// Loads more bills from the database
  Future<void> loadMoreBills() async {
    if (loadingBills) return;

    loadingBills = true;

    try {
      int ntr = legislation.length + 100;

      final rawBills = await AgoraRemote.fetchBills(numToReturn: ntr);
      var decodedBills = await compute(_decodeBills, rawBills);
      legislation.addAll(decodedBills.skip(legislation.length));
      notifyListeners();
    } finally {
      loadingBills = false;
    }
  }

  /// Loads more politicians from the database
  Future<void> loadMorePoliticians() async {
    if (loadingPoliticians) return;

    loadingPoliticians = true;

    try {
      int ntr = politician.length + 100;

      final rawMembers = await AgoraRemote.fetchLegisltors(numToReturn: ntr);
      var decodedMembers = await compute(_decodePolticians, rawMembers);
      politician.addAll(decodedMembers.skip(politician.length));
      notifyListeners();
    } finally {
      loadingPoliticians = false;
    }
  }

  /// Loads more home data from the database
  Future<void> loadMoreUserHome() async {
    if (loadingHome) return;

    loadingHome = true;

    try {
      int ntr = (home.length ~/ 2) + 50;

      final token = await _user!.getIdToken();
      final rawBills =
          AgoraRemote.fetchTrendingBillsUser(token: token!, numToReturn: ntr);
      final rawPolticians = AgoraRemote.fetchTrendingPoliticiansUser(
          token: token, numToReturn: ntr);

      final res = await Future.wait([
        compute(_decodeBillsFiltered, await rawBills),
        compute(_decodePolticians, await rawPolticians)
      ]);

      final trendingBills = res[0].skip(ntr - 50).toList();
      final trendingPolticians = res[1].skip(ntr - 50).toList();

      interleaveRandomly([trendingBills, trendingPolticians]);
      notifyListeners();
    } finally {
      loadingHome = false;
    }
  }

  /// Loads more home data from the database
  Future<void> loadMoreHome() async {
    if (loadingHome) return;

    loadingHome = true;

    try {
      int ntr = (home.length ~/ 2) + 50;

      final rawBills = AgoraRemote.fetchTrendingBills(numToReturn: ntr);
      final rawPolticians =
          AgoraRemote.fetchTrendingPoliticians(numToReturn: ntr);

      final res = await Future.wait([
        compute(_decodeBillsFiltered, await rawBills),
        compute(_decodePolticians, await rawPolticians)
      ]);

      final trendingBills = res[0].skip(ntr - 50).toList();
      final trendingPolticians = res[1].skip(ntr - 50).toList();

      interleaveRandomly([trendingBills, trendingPolticians]);
      notifyListeners();
    } finally {
      loadingHome = false;
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

  //TOPIC OPERATIONS ----------------------------------------------------------------------------------------------

  /// Adds an item to topic list if it isn't already or removes item from topic list otherwise
  void toggleTopics(TopicItem selected) {
    if (userTopicIds.contains(selected.topic.topic_id)) {
      userTopicIds.remove(selected.topic.topic_id);
      favoritesList.remove(selected);
      updateTopicsInDatabase();
    } else {
      userTopicIds.add(selected.topic.topic_id);
      favoritesList.add(selected);
      updateTopicsInDatabase();
    }
    notifyListeners();
  }

  /// Returns whether or not a TopicItem is in the topics set
  bool isFollowingTopic(TopicItem item) {
    return userTopicIds.contains(item.topic.topic_id);
  }

  // NAVIGATION ---------------------------------------------------------------------------------------------------

  /// Movee from topic selection to poltician selection
  void changeSignUpProcessPage() {
    topicSelectionDone = true;
    notifyListeners();
  }

  /// Move from poltician selection to map step
  void changeSignUpProcessMap() {
    mapStep = true;
    notifyListeners();
  }

  /// When an icon is tapped update which view we are on
  void navigationItemTapped(int index) {
    navigationIndex = index;
    hideBottomBar = false;
    hideAppBar = false;
    detailPage.clear();
    notifyListeners();
  }

  /// Opens the details page of a selected item
  void openDetails(Widget page, bool hideTop, bool hideBottom) {
    hideBottomBar = hideBottom;
    hideAppBar = hideTop;
    detailPage.add(page);
    notifyListeners();
  }

  /// Closes the details page of an item
  void closeDetails() {
    if (detailPage.length == 1) {
      hideBottomBar = false;
      hideAppBar = false;
    }
    if (votes.isNotEmpty) votes.clear();
    detailPage.removeLast();
    notifyListeners();
  }

  /// Should the sign up or log in page be displayed
  void signUpOrLogin() {
    isLogIn = !isLogIn;
    notifyListeners();
  }

  // AUTHENTICATION -----------------------------------------------------------------------------------------------

  /// Begins the sign up process
  void beginSignUpProcess(String email, String password) {
    signUpProcess = true;
    _password = password;
    _email = email;
    initSignUpProcess();
    notifyListeners();
  }

  /// Creates a new user using email and password
  Future<void> _signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email!, password: _password!);
    } on FirebaseAuthException catch (e) {
      ErrorHandler.showError(_friendlyFirebaseError(e));
    }
  }

  /// Signs in a user that is registered with email and password
  Future<void> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      ErrorHandler.showError(_friendlyFirebaseError(e));
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
    } on FirebaseAuthException catch (e) {
      ErrorHandler.showError(_friendlyFirebaseError(e));
    }
  }

  /// Clean up variables from signup process since we won't need them again
  void finishSignUpProcess() async {
    signUpProcess = false;
    topicSelectionDone = false;

    await _signUp();
    _password = null;
    _email = null;

    topics.clear();
    polticianSelecttionList.clear();

    notifyListeners();

    final token = await _user!.getIdToken();
    await AgoraRemote.addUser(
        token: token!,
        topics: selectedTopics,
        politicians: selectedPolticians,
        district: int.parse(selectedDistrict),
        state: selectedState);
    clearSignUpSelection();
    getFavorites();
    getUserTopics();
  }

  /// Clean up the signup selection info
  void clearSignUpSelection() {
    selectedTopics.clear();
    selectedPolticians.clear();
    selectedState = "";
    selectedDistrict = "";
  }

  // SEARCHING ----------------------------------------------------------------------------------------------------

  /// Performs and advanced search for a poltician or legislation
  Future<void> advancedSearch(
      String searchMode,
      String name,
      Topic? topic,
      String? status,
      String? billType,
      String? congressSessionLegislation,
      DateTime? dateIntroduced,
      DateTime? lastUpdateDate,
      String? chamber,
      String? state,
      DateTime? startYear,
      String? congressSessionPolitician) async {
    String query = "";
    if (searchMode == 'Politicians') {
      query += 'name_search="$name"';
      if (chamber != null && chamber.isNotEmpty) {
        query += '&chamber_name="$chamber"';
      }
      if (state != null && state.isNotEmpty) {
        query += '&state="$state"';
      }
      if (startYear != null) {
        query += '&start_year=${startYear.year}';
      }
      if (congressSessionPolitician != null &&
          congressSessionPolitician.isNotEmpty) {
        query += '&congress=$congressSessionPolitician';
      }

      searchResults = await AgoraRemote.queryPoliticians(query: query);
      openDetails(SearchResults(query: "Search Polticians"), true, false);
    }

    if (searchMode == 'Legislation') {
      query += 'title="$name"';
      if (topic != null) {
        query += '&topic_id=${topic.topic_id}';
      }
      if (status != null && status.isNotEmpty) {
        query += '&status="$status"';
      }
      if (billType != null && billType.isNotEmpty) {
        query += '&type="$billType"';
      }
      if (congressSessionLegislation != null &&
          congressSessionLegislation.isNotEmpty) {
        query += '&congress=$congressSessionLegislation';
      }
      if (dateIntroduced != null) {
        query +=
            '&intro_date=["${dateIntroduced.toIso8601String().split("T")[0]}", "${DateTime.now().toIso8601String().split("T")[0]}"]';
      }
      if (lastUpdateDate != null) {
        query +=
            '&status_update_date=["${lastUpdateDate.toIso8601String().split("T")[0]}", "${DateTime.now().toIso8601String().split("T")[0]}"]';
      }

      searchResults = await AgoraRemote.queryLegislation(query: query);
      openDetails(SearchResults(query: "Search Legislation"), true, false);
    }
    notifyListeners();
  }

  Future<void> searchByDistrict(String state, String district, bool moreThanOne,
      bool isFed, bool localSenate, bool localHouse) async {
    searchResults.clear();

    final reps = AgoraRemote.queryPoliticians(
      query: 'state="$state"&district=$district&congress=119',
    );

    List<PoliticianItem> results = [];

    if (moreThanOne) {
      final sen = AgoraRemote.queryPoliticians(
        query: 'state="$state"&district=0&congress=119',
      );
      final res = await Future.wait([reps, sen]);
      results.addAll(res[0]);
      results.addAll(res[1]);
    } else {
      results.addAll(await reps);
    }

    if (isFed) {
      results.removeWhere((p) =>
          p.politician.chamber.toLowerCase().contains(state.toLowerCase()));
    }

    if (localSenate) {
      results = results
          .where((p) =>
              p.politician.chamber.toLowerCase().contains('senate') &&
              p.politician.chamber.toLowerCase().contains(state.toLowerCase()))
          .toList();
    }

    if (localHouse) {
      results = results
          .where((p) =>
              p.politician.chamber.toLowerCase().contains('house') &&
              p.politician.chamber.toLowerCase().contains(state.toLowerCase()))
          .toList();
    }

    searchResults.addAll(results);

    openDetails(
        SearchResults(query: "$state, District $district"), true, false);
  }

  /// Queries Databse and searches poltician by name
  Future<void> searchPoliticians(String query) async {
    searchedPoliticians =
        await AgoraRemote.queryPoliticians(query: 'name_search="$query"&');
    itemsToDisplayPolitician = searchedPoliticians;
    notifyListeners();
  }

  /// Queries Databse and searches legislation by title
  Future<void> searchLegislation(String query) async {
    searchedLegislation =
        await AgoraRemote.queryLegislation(query: 'title="$query"');
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

  ///Makes firebase errors actually readable
  String _friendlyFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return "The email address is not valid.";
      case 'user-disabled':
        return "This user account has been disabled.";
      case 'user-not-found':
        return "No user found for that email.";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
      case 'email-already-in-use':
        return "This email is already registered. Try logging in instead.";
      case 'operation-not-allowed':
        return "This operation is not allowed. Please contact support.";
      case 'weak-password':
        return "Your password is too weak. Try at least 6 characters with letters and numbers.";
      default:
        return e.message ?? "An unknown error occurred. Please try again.";
    }
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

  /// Gets the color for the vote
  Color voteColor(String party) {
    switch (party.toLowerCase()) {
      case 'yea':
        return Colors.green;
      case 'nay':
        return Colors.red;
      default:
        return Colors.blueGrey;
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
    return type == "hr" ||
        type == "hrjres" ||
        type == "hconres" ||
        type == "hres";
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
      added++;

      if (added % 25 == 0) {
        notifyListeners(); //Nice speed imporvment
      }
    }
  }
  //AI GENERATED CODE END

  // CHAT RELATED METHODS ----------------------------------------------------------------------------------------------------
  List<ChatMessage> getChatHistory(int billId) {
    return _chatHistory[billId] ?? [];
  }

  bool get isChatLoading => _chatLoading;

  String? get chatError => _chatError;

  Future<void> sendChatMessage(String uid, int billId, String userMessage,
      {String? systemPrompt}) async {
    _chatLoading = true;
    _chatError = null;

    ChatMessage userChatMessage =
        ChatMessage(role: 'user', content: userMessage);

    _chatHistory[billId] = (_chatHistory[billId] ?? [])..add(userChatMessage);
    notifyListeners();

    try {
      List<ChatMessage> messagesToSend = _chatHistory[billId]!;
      if (systemPrompt != null) {
        messagesToSend = [
          ChatMessage(role: 'system', content: systemPrompt),
          ...messagesToSend,
        ];
      }

      String response =
          await AgoraRemote.sendChatMessage(uid: uid, messages: messagesToSend);

      ChatMessage chatM = ChatMessage(role: 'assistant', content: response);

      _chatHistory[billId] = (_chatHistory[billId] ?? [])..add(chatM);
    } catch (e) {
      _chatError = e.toString();
    }
    _chatLoading = false;
    notifyListeners();
  }
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
