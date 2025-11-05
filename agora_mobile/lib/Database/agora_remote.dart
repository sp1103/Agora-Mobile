import 'dart:convert';
import 'package:agora_mobile/Pages/List_Items/legislation_item.dart';
import 'package:agora_mobile/Pages/List_Items/politician_item.dart';
import 'package:agora_mobile/Pages/List_Items/topic_item.dart';
import 'package:agora_mobile/Types/legislation.dart';
import 'package:agora_mobile/Types/politician.dart';
import 'package:agora_mobile/Types/topic.dart';
import 'package:agora_mobile/Types/votes.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

/// Contains functions that perform queries to the database
class AgoraRemote {

  // GET METHOODS --------------------------------------------------------------------------------------------------------------

  /// Returns a list of politicians from the database
  static Future<String> fetchLegisltors() async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/get_trending_politicians?num_to_return=100');

    final response = await http.get(url);

    return response.body;
  }

  /// Returns a list of most politicians from the database
  static Future<List<Politician>> fetchPoliticianSelection() async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/get_trending_politicians?num_to_return=5000');

    final response = await http.get(url);

    final Map<String, dynamic> json = jsonDecode(response.body);
    final List<dynamic> data = json["members"] ?? [];
    final items = data
      .where((json) => json is Map && json.containsKey("bio_id"))
      .map((json) {
        final politician = Politician.fromJson(json);
        return politician;
      }).toList();

    return items;
  }

  /// Returns a list of most politician's votes
  static Future<List<Vote>> fetchVotes(String bioId) async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/get_member_most_recent_votes?bio_id="$bioId"&num_to_return=100');

    final response = await http.get(url);

    final Map<String, dynamic> json = jsonDecode(response.body);
    final List<dynamic> data = json["votes"] ?? [];
    final items = data
      .where((json) => json is Map && json.containsKey("vote_id"))
      .map((json) {
        final vote = Vote.fromJson(json);
        return vote;
      }).toList();

    return items;
  }

  /// Returns a list of bills from the database
  static Future<String> fetchBills() async {
    const startDate = "2000-01-01";
    var endDate = DateTime.now().toIso8601String().split("T")[0];

    final url = Uri.parse('https://piece-o-pi.com/agora_api/get_bills?intro_date=["$startDate","$endDate"]&num_to_return=100');

    final response = await http.get(url);

    return response.body;
  }

  /// Returns a list of trending bills
  static Future<String> fetchTrendingBills() async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/get_trending_bills?num_to_return=50');

    final response = await http.get(url);

    return response.body;
  }

  /// Returns a list of trending bills for a specific user
  static Future<String> fetchTrendingBillsUser({required String token}) async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/get_trending_bills?token="$token"&num_to_return=50');

    final response = await http.get(url);

    return response.body;
  }

  /// Returns a list of trending politicians 
  static Future<String> fetchTrendingPoliticians() async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/get_trending_politicians?num_to_return=50');

    final response = await http.get(url);

    return response.body;
  }

  /// Returns a list of trending politicians for specific user
  static Future<String> fetchTrendingPoliticiansUser({required String token}) async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/get_trending_politicians?token="$token"&num_to_return=50');

    final response = await http.get(url);

    return response.body;
  }

  /// Returns a list of followed politicians 
  static Future<List<PoliticianItem>> fetchFollowingPoliticians({required String token}) async {
    final url = Uri.parse('http://piece-o-pi.com/agora_api/get_user_info?token="$token"&us_members_followed=""');

    final response = await http.get(url);

    final Map<String, dynamic> json = jsonDecode(response.body);
    final List<dynamic> data = json["bio_ids"] ?? [];
    final items = data
      .where((json) => json is Map && json.containsKey("bio_id"))
      .map((json) {
        final politician = Politician.fromJson(json);
        return PoliticianItem(politician);
      }).toList();

    return items;
  }

  /// Returns a list of followed bills
  static Future<List<LegislationItem>> fetchFollowingBills({required String token}) async {
    final url = Uri.parse('http://piece-o-pi.com/agora_api/get_user_info?token="$token"&us_bills_followed=""');

    final response = await http.get(url);

    final Map<String, dynamic> json = jsonDecode(response.body);
    final List<dynamic> data = json["bill_ids"] ?? [];
    final items = data
      .where((json) => json is Map && json.containsKey("bill_id"))
      .map((json) {
        final legislation = Legislation.fromJson(json);
        return LegislationItem(legislation);
      }).toList();

    return items;
  }

  /// Returns set of all bill topics
  static Future<Set<Topic>> fetchAllTopics() async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/get_all_bill_topics');

    final response = await http.get(url);

    final List<dynamic> data = jsonDecode(response.body);
    final items = data
      .where((json) => json is Map && json.containsKey("topic_id"))
      .map((json) {
        final topic = Topic.fromJson(json);
        return topic;
      }).toSet();

    return items;
  }

  /// Fetch all the topics that a user is currently following
  static Future<Map<int, TopicItem>> fetchFollowingTopics({required String token}) async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/get_user_info?token="$token"&topics_following=""');

    final response = await http.get(url);

    final Map<String, dynamic> json = jsonDecode(response.body);
    final List<dynamic> data = json["topic_ids"] ?? [];
    final Map<int, TopicItem> topicMap = {};
    for (final item in data) {
    if (item is Map && item.containsKey("topic_id")) {
      final topic = Topic.fromJson(Map<String, dynamic>.from(item));
      topicMap[topic.topic_id] = TopicItem(topic);
    }
  }

    return topicMap;
  }

  // SEARCH METHOODS ------------------------------------------------------------------------------------------------------------

  /// Query the database for politicians using various search options
  static Future<List<PoliticianItem>> queryPoliticians({required String query}) async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/get_us_members?$query&num_to_return=100');

    final response = await http.get(url);

    final Map<String, dynamic> json = jsonDecode(response.body);
    final List<dynamic> data = json["members"] ?? [];
    final items = data
      .where((json) => json is Map && json.containsKey("bio_id"))
      .map((json) {
        final politician = Politician.fromJson(json);
        return PoliticianItem(politician);
      }).toList();

    return items;
  }

  /// Query the database for legislation using various search options
  static Future<List<LegislationItem>> queryLegislation({required String query}) async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/get_bills?$query&num_to_return=100');

    final response = await http.get(url);

    final List<dynamic> data = jsonDecode(response.body);
    final items = data
      .where((json) => json is Map && json.containsKey("bill_id"))
      .map((json) {
        final legislation = Legislation.fromJson(json);
        return LegislationItem(legislation);
      }).toList();

    return items;
  }

  // POST METHOODS -------------------------------------------------------------------------------------------------------------

  /// Post request that unfollows a bill based on user
  static Future<void> unfollowBill({required String token, required int billId}) async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/add_user_interactions');

    final payload = 
    [
      {
        "token": token,
        "type": "unfollow_us_bill",
        "bill_id": billId, 
        "bio_id": null,
        "district": null,
        "state": null,
        "current_topics": []
      }
    ];

    await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(payload));
  }

  // Post request that follows a bill based on user
  static Future<void> followBill({required String token, required int billId}) async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/add_user_interactions');

    final payload = 
    [
      {
        "token": token,
        "type": "follow_us_bill",
        "bill_id": billId, 
        "bio_id": null,
        "district": null,
        "state": null,
        "current_topics": []
      }
    ];

    await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(payload));
  }

  /// Post request that unfollows a politcian based on user
  static Future<void> unfollowPolitician({required String token, required String bioId}) async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/add_user_interactions');

    final payload = 
    [
      {
        "token": token,
        "type": "unfollow_us_member",
        "bill_id": null, 
        "bio_id": bioId,
        "district": null,
        "state": null,
        "current_topics": []
      }
    ];

    await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(payload));
  }

  /// Post request that unfollows a politcian based on user
  static Future<void> followPolitician({required String token, required String bioId}) async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/add_user_interactions');

    final payload = 
    [
      {
        "token": token,
        "type": "follow_us_member",
        "bill_id": null, 
        "bio_id": bioId,
        "district": null,
        "state": null,
        "current_topics": []
      }
    ];

    await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(payload));
  }

  /// POST request that updates a users topic list
  static Future<void> updateTopics({required String token, required List<int> topics}) async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/add_user_interactions');

    final payload = 
    [
      {
        "token": token,
        "type": "update_topics",
        "bill_id": null,
        "bio_id": null,
        "district": null,
        "state": null,
        "current_topics": topics,
      }
    ];

    await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(payload));
  }

  /// POST request to databse that adds a user
  static Future<void> addUser({required String token, required List<String> topics, required List<String> politicians, required int district, required String state}) async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/add_users');

    final payload = 
    [
      {
        "token": token,
        "topics": topics,
        "us_members": politicians,
        "district": district,
        "state": state
      }
    ];

    await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(payload));
  }

}