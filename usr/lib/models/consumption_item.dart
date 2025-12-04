class ConsumptionItem {
  final String heName;
  final String heCode;
  final double heQty;
  final DateTime heUpdDate;

  ConsumptionItem({
    required this.heName,
    required this.heCode,
    required this.heQty,
    required this.heUpdDate,
  });

  factory ConsumptionItem.fromJson(Map<String, dynamic> json) {
    return ConsumptionItem(
      heName: json['HENAME'] ?? '',
      heCode: json['HECODE'] ?? '',
      heQty: (json['HEAQTY'] ?? 0).toDouble(),
      heUpdDate: DateTime.parse(json['HEUPDDATE'] ?? DateTime.now().toIso8601String()),
    );
  }
}
