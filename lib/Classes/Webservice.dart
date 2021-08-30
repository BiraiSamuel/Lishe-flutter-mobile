import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Resource<T> {
  final String url;
  T Function(Response response) parse;

  Resource({required this.url,required this.parse});
}

class Webservice {
  // Create storage
  final storage = new FlutterSecureStorage();

  Future<T> load<T>(Resource<T> resource) async {
    // Read value
    String? token = await storage.read(key: 'jwt');

    if(token != null) {
      final response = await http.get(Uri.parse(resource.url),headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        return resource.parse(response);
      } else {
        throw Exception('Failed to load data!');
      }
    }else{
      throw Exception('Failed to load data!');
    }
  }

}