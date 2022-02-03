import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HttpRequest {
  //static const String _address = "10.0.2.2"; // Emulator
  static const String _address = "10.0.2.2"; // Web
  static const int _port = 5000;

  static Future<dynamic> getRequest(
      {Map<String, dynamic>? parameters, required String endpoint}) async {
    Uri httpRequest = Uri(
      scheme: "http",
      path: endpoint,
      port: _port,
      host: _address,
      queryParameters: parameters,
    );
    try {
      final response = await http.get(
        httpRequest,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      );
      print(httpRequest.toString());
      if (response.statusCode == 200) {
        return (json.decode(response.body.toString()));
      } else {
        throw Exception('Failed');
      }
    } catch (_) {
      print(_.toString());
    }
  }

  static Future<dynamic> postRequest(String endpoint, String jsonBody) async {
    Uri httpRequest =
        Uri(scheme: "http", path: endpoint, port: _port, host: _address);
    final response = await http.post(
      httpRequest,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonBody,
    );
    print(httpRequest.toString());
    print(response.statusCode);
    if (response.statusCode != 201 && response.statusCode != 200) {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed');
    } else {
      return json.decode(response.body.toString());
    }
  }

  static Future<dynamic> deleteRequest(String endpoint, String jsonBody) async {
    Uri httpRequest =
        Uri(scheme: "http", path: endpoint, port: _port, host: _address);
    final response = await http.delete(
      httpRequest,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );
    print(httpRequest.toString());

    if (response.statusCode != 201 && response.statusCode != 200) {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed');
    } else {
      return json.decode(response.body.toString());
    }
  }

  /* static Future<dynamic> postFile(
      String endpoint, PlatformFile file, String path) async {
    Uri httpRequest =
        Uri(scheme: "http", path: endpoint, port: _port, host: _address);
    print(httpRequest);
    var request = http.MultipartRequest('POST', httpRequest)
      ..fields['path'] = path;
    request.files.add(
        http.MultipartFile.fromBytes('file', file.bytes!, filename: file.name));
    var response = await request.send();
    if (response.statusCode == 200) {
      return "Upload";
    } else {
      throw Exception('Failed');
    }
  }*/

  static Future<dynamic> putRequest(String endpoint, String jsonBody) async {
    Uri httpRequest =
        Uri(scheme: "http", path: endpoint, port: _port, host: _address);
    final response = await http.put(
      httpRequest,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed');
    } else {
      return json.decode(response.body.toString());
    }
  }
}
