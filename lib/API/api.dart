import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:frontend/model/model.dart';

Future<List<Product>> fetchProducts() async {
  final url = 'https://dummyjson.com/products'; // Ensure this is not null
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return (data['products'] as List)
        .map((item) => Product.fromJson(item))
        .toList();
  } else {
    throw Exception('Failed to load products');
  }
}

