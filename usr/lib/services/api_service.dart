import 'dart:convert';
import '../models/inventory_item.dart';
import '../models/consumption_item.dart';
import '../models/contact.dart';
import '../models/prescription.dart';

class ApiService {
  // Replace with your actual backend URL (e.g., http://10.0.2.2:5000 for Android emulator)
  static const String baseUrl = 'http://localhost:5000';

  // Mock data for demonstration since we can't connect to localhost backend directly in this environment
  Future<List<InventoryItem>> getInventory({int page = 1, String search = ''}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock response
    return List.generate(20, (index) => InventoryItem(
      heName: 'Item $index $search',
      heCode: 'CODE$index',
      heRetailPrice: 10.0 + index,
      barcode: '123456789$index',
    ));
  }

  Future<List<ConsumptionItem>> getConsumption() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(10, (index) => ConsumptionItem(
      heName: 'Consumed Item $index',
      heCode: 'C$index',
      heQty: (index + 1) * 2.0,
      heUpdDate: DateTime.now().subtract(Duration(days: index)),
    ));
  }

  Future<List<Contact>> getContacts({String search = ''}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(15, (index) => Contact(
      heAmka: 'AMKA$index',
      heFirstName: 'Name $index',
      heLastName: 'Surname $index',
      hePhone2: '69000000$index',
      isDoctor: index % 5 == 0,
      isPatient: true,
      heId: 'ID$index',
      prescriptionCount: index * 2,
    ));
  }

  Future<List<Prescription>> getPrescriptions(String contactId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(3, (index) => Prescription(
      prescriptionCode: 'PRESC$index',
      heIssueDate: DateTime.now().subtract(Duration(days: index * 10)),
      heValidFrom: DateTime.now().subtract(Duration(days: index * 10)),
      heValidTo: DateTime.now().add(Duration(days: 30 - (index * 10))),
    ));
  }
}
