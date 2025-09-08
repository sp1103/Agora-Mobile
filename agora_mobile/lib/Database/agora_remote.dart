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
    var year = DateTime.now().year.toString();
    final url = Uri.parse('https://piece-o-pi.com/agora_api/get_us_members?start_year="$year"');

    final response = await http.get(url);

    final List<dynamic> data = jsonDecode(response.body);
    final items = data
      .where((json) => json is Map && json.containsKey("bio_id"))
      .map((json) {
        final politician = Politician.fromJSON(json);
        return PoliticianItem(politician);
      }).toList();

    return items;
  }

  /// Returns a list of bills from the database
  static Future<List<LegislationItem>> fetchBills() async {
    const startDate = "2000-01-01";
    var endDate = DateTime.now().toIso8601String().split("T")[0];

    final url = Uri.parse('https://piece-o-pi.com/agora_api/get_bills?intro_date=["$startDate","$endDate"]');

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

  /// Returns a list of trending bills
  static Future<List<LegislationItem>> fetchTrendingBills() async {
    final url = Uri.parse('https://piece-o-pi.com/agora_api/get_trending_bills');

    final response = await http.get(url);

    final Map<String, dynamic> json = jsonDecode(response.body);
    final List<dynamic> data = json["bills"] ?? [];
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
    final url = Uri.parse('https://piece-o-pi.com/agora_api/get_trending_politicians');

    final response = await http.get(url);

    final Map<String, dynamic> json = jsonDecode(response.body);
    final List<dynamic> data = json["members"] ?? [];
    final items = data
      .where((json) => json is Map && json.containsKey("bio_id"))
      .map((json) {
        final politician = Politician.fromJSON(json);
        return PoliticianItem(politician);
      }).toList();

    return items;
  }

}