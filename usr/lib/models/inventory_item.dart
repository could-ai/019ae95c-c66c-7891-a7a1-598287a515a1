class InventoryItem {
  final String heName;
  final String heCode;
  final double heRetailPrice;
  final String? barcode;

  InventoryItem({
    required this.heName,
    required this.heCode,
    required this.heRetailPrice,
    this.barcode,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      heName: json['HENAME'] ?? '',
      heCode: json['HECODE'] ?? '',
      heRetailPrice: (json['HERETAILPRICE'] ?? 0).toDouble(),
      barcode: json['BARCODE'],
    );
  }
}
