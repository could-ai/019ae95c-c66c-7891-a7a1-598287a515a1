class Prescription {
  final String prescriptionCode;
  final DateTime heIssueDate;
  final DateTime heValidFrom;
  final DateTime heValidTo;

  Prescription({
    required this.prescriptionCode,
    required this.heIssueDate,
    required this.heValidFrom,
    required this.heValidTo,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      prescriptionCode: json['prescriptionCode'] ?? '',
      heIssueDate: DateTime.parse(json['HEISSUEDATE'] ?? DateTime.now().toIso8601String()),
      heValidFrom: DateTime.parse(json['HEVALIDFROM'] ?? DateTime.now().toIso8601String()),
      heValidTo: DateTime.parse(json['HEVALIDTO'] ?? DateTime.now().toIso8601String()),
    );
  }
}
