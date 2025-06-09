import 'package:mobile_app/domain/models/grow_room/measurement.dart';

class GrowRoom {
  final int id;
  final String name;
  final String imageUrl;
  final List<Measurement> latestMeasurements;
  final bool hasActiveCrop;

  GrowRoom({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.latestMeasurements,
    required this.hasActiveCrop,
  });

  factory GrowRoom.fromJson(Map<String, dynamic> json) {
    return GrowRoom(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      latestMeasurements: (json['latestMeasurements'] as List)
          .map((e) => Measurement.fromJson(e))
          .toList(),
      hasActiveCrop: json['hasActiveCrop'],
    );
  }
}
