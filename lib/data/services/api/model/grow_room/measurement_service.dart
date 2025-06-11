import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/domain/models/grow_room/measurement.dart';

class MeasurementService {
  final String baseUrl;

  MeasurementService({required this.baseUrl});

  Future<List<Measurement>> fetchMeasurementsForCurrentPhaseByGrowRoomId(
      int growRoomId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/v1/measurements/$growRoomId'));

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
}
