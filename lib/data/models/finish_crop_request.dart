class FinishCropRequest {
  final double totalProduction;

  FinishCropRequest({required this.totalProduction});

  Map<String, dynamic> toJson() => {'totalProduction': totalProduction};
}
