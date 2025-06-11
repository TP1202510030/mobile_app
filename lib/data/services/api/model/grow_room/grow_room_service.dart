import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/domain/models/grow_room/grow_room.dart';

class GrowRoomService {
  final String baseUrl;

  GrowRoomService({required this.baseUrl});

  Future<List<GrowRoom>> getGrowRoomsByCompanyId(int companyId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/v1/grow_rooms?companyId=$companyId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      debugPrint('Fetched grow rooms: $data');
      return data
          .map((room) => GrowRoom.fromJson(room as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load grow rooms for the company');
    }
  }
}
