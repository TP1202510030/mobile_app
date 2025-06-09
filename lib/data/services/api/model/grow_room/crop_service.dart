import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/domain/models/grow_room/crop.dart';

class CropService {
  final String baseUrl;

  CropService({required this.baseUrl});

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
}
