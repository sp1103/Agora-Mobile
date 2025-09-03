import 'dart:convert';
import 'package:agora_mobile/Pages/List_Items/legislation_item.dart';
import 'package:agora_mobile/Pages/List_Items/politician_item.dart';
import 'package:agora_mobile/Types/legislation.dart';
import 'package:agora_mobile/Types/politician.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

/// Contains functions that perform queries to the database
class AgoraRemote {

  /// Returns a list of politicians from the database
  static Future<List<PoliticianItem>> fetchLegisltors() async {
    const startDate = "1900-01-01";
    var endDate = DateTime.now().toIso8601String().split("T")[0];

    final url = Uri.parse('https://piece-o-pi.com/api/get_legislators?start_date="$startDate"&end_date="$endDate"');

    final response = await http.get(url);

    final List<dynamic> data = jsonDecode(response.body);
    final items = data
      .where((json) => json is Map && json.containsKey("pID"))
      .map((json) {
        final politician = Politician.fromJSON(json);
        return PoliticianItem(politician);
      }).toList();

    return items;
  }

  /// Returns a list of bills from the database
  static Future<List<LegislationItem>> fetchBills() async {
    const startDate = "2023-01-01";
    var endDate = DateTime.now().toIso8601String().split("T")[0];

    final url = Uri.parse('https://piece-o-pi.com/api/get_bills?start_date="$startDate"&end_date="$endDate"');

    final response = await http.get(url);

    final List<dynamic> data = jsonDecode(response.body);
    final items = data
      .where((json) => json is Map && json.containsKey("bill_id"))
      .map((json) {
        final legislation = Legislation.fromJSON(json);
        return LegislationItem(legislation);
      }).toList();

    return items;
  }

  /// Returns a bill with the specified bill id
  static Future<LegislationItem> getBillByID(int id) async {
    final url = Uri.parse('https://piece-o-pi.com/api/get_bills?ga_id="$id"');

    final response = await http.get(url);

    final List<dynamic> data = jsonDecode(response.body);
    final legislation = Legislation.fromJSON(data[0]);

    return LegislationItem(legislation);

  }

  /// Returns a poltician with the specified p_id
  static Future<PoliticianItem> getPoliticianByID(int id) async {
    final url = Uri.parse('https://piece-o-pi.com/api/get_legislators?p_id="$id"');

    final response = await http.get(url);

    final List<dynamic> data = jsonDecode(response.body);
    final politician = Politician.fromJSON(data[0]);

    return PoliticianItem(politician);

  }

  /// Returns a list of trending bills
  static Future<List<LegislationItem>> fetchTrendingBills() async {
    final url = Uri.parse('https://piece-o-pi.com/api/get_trending_legislation');

    final response = await http.get(url);

    final List<dynamic> data = jsonDecode(response.body);
    final items = data
      .where((json) => json is Map && json.containsKey("bill_id"))
      .map((json) {
        final legislation = Legislation.fromJSON(json);
        return LegislationItem(legislation);
      }).toList();

    return items;
  }

  /// Returns a list of trending politicians 
  static Future<List<PoliticianItem>> fetchTrendingPoliticians() async {
    final url = Uri.parse('https://piece-o-pi.com/api/get_trending_politicians');

    final response = await http.get(url);

    final List<dynamic> data = jsonDecode(response.body);
    final items = data
      .where((json) => json is Map && json.containsKey("pID"))
      .map((json) {
        final politician = Politician.fromJSON(json);
        return PoliticianItem(politician);
      }).toList();

    return items;
  }

}