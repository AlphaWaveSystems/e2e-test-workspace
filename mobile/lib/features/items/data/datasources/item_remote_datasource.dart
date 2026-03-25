import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/item_model.dart';

class ItemRemoteDatasource {
  final http.Client client;

  ItemRemoteDatasource({http.Client? client})
      : client = client ?? http.Client();

  Future<List<ItemModel>> fetchItems() async {
    final response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=10'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ItemModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch items: ${response.statusCode}');
    }
  }
}
