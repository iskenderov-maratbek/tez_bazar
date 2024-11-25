import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductService extends ChangeNotifier {
  Future<void> login() async {
    print('START REQUEST TO LOGIN');
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.103:3000/echo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    } catch (e) {
      print('Error: $e');
    }
  }
}
