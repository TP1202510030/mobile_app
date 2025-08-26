import 'package:mobile_app/domain/entities/crop/crop_phase.dart';
import 'package:mobile_app/utils/date_parser.dart';

class Crop {
  final int id;
  final DateTime startDate;
  final DateTime? endDate;
  final double? totalProduction;
  final String sensorActivationFrequency;
  final int growRoomId;
  final List<CropPhase> phases;
  final CropPhase? currentPhase;

  Crop({
    required this.id,
    required this.startDate,
    this.endDate,
    this.totalProduction,
    required this.sensorActivationFrequency,
    required this.growRoomId,
    required this.phases,
    this.currentPhase,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    final phasesList = json['phases'] as List<dynamic>? ?? [];

    return Crop(
      id: json['id'],
      startDate: parseCustomDate(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? parseCustomDate(json['endDate'] as String)
          : null,
      totalProduction: (json['totalProduction'] as num?)?.toDouble(),
      sensorActivationFrequency: json['sensorActivationFrequency'] as String,
      growRoomId: json['growRoomId'] as int,
      currentPhase: json['currentPhase'] != null
          ? CropPhase.fromJson(json['currentPhase'] as Map<String, dynamic>)
          : null,
      phases: phasesList
          .where((p) => p != null)
          .map((p) => CropPhase.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}
