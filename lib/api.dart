import 'dart:convert';
import 'package:http/http.dart' as http;
import 'item.dart';

class Api {
  static const String baseUrl = "http://lostfoundapp1.atwebpages.com/api";
  static Future<List<LostFoundItem>> getItems() async {
    final url = Uri.parse("$baseUrl/get_items.php");
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception("Failed to load items (${res.statusCode})");
    }
    final List data = jsonDecode(res.body);
    return data.map((e) => LostFoundItem.fromJson(e)).toList();
  }

  static Future<void> addItem({
    required String type,
    required String title,
    required String description,
    required String location,
    required String contact,
  }) async {
    final url = Uri.parse("$baseUrl/add_item.php");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "type": type,
        "title": title,
        "description": description,
        "location": location,
        "contact": contact,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to add item (${res.statusCode}): ${res.body}");
    }
  }
}
