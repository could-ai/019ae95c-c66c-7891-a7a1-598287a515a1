class Contact {
  final String? heAmka;
  final String heFirstName;
  final String heLastName;
  final String? hePhone2;
  final bool isDoctor;
  final bool isPatient;
  final String heId;
  final int prescriptionCount;

  Contact({
    this.heAmka,
    required this.heFirstName,
    required this.heLastName,
    this.hePhone2,
    required this.isDoctor,
    required this.isPatient,
    required this.heId,
    required this.prescriptionCount,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      heAmka: json['HEAMKA'],
      heFirstName: json['HEFIRSTNAME'] ?? '',
      heLastName: json['HELASTNAME'] ?? '',
      hePhone2: json['HEPHONE2'],
      isDoctor: json['PCISDOCTOR'] == true || json['PCISDOCTOR'] == 1,
      isPatient: json['PCISPATIENT'] == true || json['PCISPATIENT'] == 1,
      heId: json['HEID'].toString(),
      prescriptionCount: json['prescriptionCount'] ?? 0,
    );
  }
}
