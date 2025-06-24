import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/domain/models/grow_room/crop.dart';

class CropService {
  final String baseUrl;

  CropService({required this.baseUrl});

  Future<Crop> createCrop(int growRoomId, Map<String, dynamic> cropData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/crops?growRoomId=$growRoomId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(cropData),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return Crop.fromJson(data as Map<String, dynamic>);
    } else {
      debugPrint('Failed to create crop. Status: ${response.statusCode}');
      debugPrint('Response: ${response.body}');
      throw Exception('Failed to create crop');
    }
  }

  Future<List<Crop>> fetchCropsByGrowRoomId(int growRoomId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/crops?growRoomId=$growRoomId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((crop) => Crop.fromJson(crop as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load crops');
    }
  }

  Future<List<Crop>> getCropsByGrowRoomId(int growRoomId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/v1/crops?growRoomId=$growRoomId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((crop) => Crop.fromJson(crop as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load crops');
    }
  }
}
