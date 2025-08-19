import 'dart:convert';
import 'package:agora_mobile/Pages/List_Items/legislation_item.dart';
import 'package:agora_mobile/Pages/List_Items/politician_item.dart';
import 'package:agora_mobile/Types/legislation.dart';
import 'package:agora_mobile/Types/politician.dart';
//import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/io_client.dart';
import 'dart:async';

/// Creates an HTTP client so that self-signed cert is ignored
HttpClient createHttpClient() { //SHOULD NOT BE USED FOR PRODUCTION
  final HttpClient client = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true; // Always accept
  return client;
}

final httpClient = IOClient(createHttpClient());

/// Contains functions that perform queries to the database
class AgoraRemote {

  /// Returns a list of politicians from the database
  static Future<List<PoliticianItem>> fetchLegisltors() async {
    const startDate = "1900-01-01";
    var endDate = DateTime.now().toIso8601String().split("T")[0];

    final url = Uri.parse('https://agoraserver.ddns.net:45288/api/get_legislators?start_date="$startDate"&end_date="$endDate"');

    final response = await httpClient.get(url);

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

    final url = Uri.parse('https://agoraserver.ddns.net:45288/api/get_bills?start_date="$startDate"&end_date="$endDate"');

    final response = await httpClient.get(url);

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
    final url = Uri.parse('https://agoraserver.ddns.net:45288/api/get_trending_legislation');

    final response = await httpClient.get(url);

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
    final url = Uri.parse('https://agoraserver.ddns.net:45288/api/get_trending_politicians');

    final response = await httpClient.get(url);

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