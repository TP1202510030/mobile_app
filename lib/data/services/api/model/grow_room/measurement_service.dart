import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/domain/models/grow_room/measurement.dart';

class MeasurementService {
  final String baseUrl;

  MeasurementService({required this.baseUrl});

  Future<List<Measurement>> getMeasurementsForCurrentPhaseByCropId(
      int cropId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/v1/measurements/$cropId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;

      return data
          .map((measurement) =>
              Measurement.fromJson(measurement as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load measurements');
    }
  }

  Future<List<Measurement>> getMeasurementsByPhaseId(int cropPhaseId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/api/v1/measurements?cropPhaseId=$cropPhaseId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      return data
          .map((m) => Measurement.fromJson(m as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 204) {
      return [];
    } else {
      throw Exception('Failed to load measurements for phase $cropPhaseId');
    }
  }
}
