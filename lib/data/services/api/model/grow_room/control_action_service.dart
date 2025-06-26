import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/domain/models/grow_room/control_action.dart';

class ControlActionService {
  final String baseUrl;

  ControlActionService({required this.baseUrl});

  Future<List<ControlAction>> getControlActionsByPhaseId(
      int cropPhaseId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/api/v1/control_actions?cropPhaseId=$cropPhaseId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      debugPrint('Fetched control actions for phase $cropPhaseId: $data');
      return data
          .map((action) =>
              ControlAction.fromJson(action as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 204) {
      return [];
    } else {
      throw Exception('Failed to load control actions for the phase');
    }
  }

  Future<List<ControlAction>> getControlActionsForCurrentPhaseByCropId(
      int cropId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/v1/control_actions/$cropId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      debugPrint('Fetched control actions for crop $cropId: $data');
      return data
          .map((action) =>
              ControlAction.fromJson(action as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 204) {
      return [];
    } else {
      throw Exception('Failed to load control actions for the crop');
    }
  }
}
