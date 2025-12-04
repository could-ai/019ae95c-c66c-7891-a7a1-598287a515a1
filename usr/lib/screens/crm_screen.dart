import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../models/prescription.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class CrmScreen extends StatefulWidget {
  const CrmScreen({super.key});

  @override
  State<CrmScreen> createState() => _CrmScreenState();
}

class _CrmScreenState extends State<CrmScreen> {
  final ApiService _apiService = ApiService();
  List<Contact> _contacts = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final contacts = await _apiService.getContacts(search: _searchQuery);
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showPrescriptions(Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactDetailsScreen(contact: contact),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRM / Contacts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Name, AMKA, Phone',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                    _loadData();
                  },
                ),
              ),
              onSubmitted: (value) {
                setState(() => _searchQuery = value);
                _loadData();
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _contacts.length,
                    itemBuilder: (context, index) {
                      final contact = _contacts[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: contact.isDoctor ? Colors.blue.shade100 : Colors.green.shade100,
                          child: Icon(
                            contact.isDoctor ? Icons.medical_services : Icons.person,
                            color: contact.isDoctor ? Colors.blue : Colors.green,
                          ),
                        ),
                        title: Text('${contact.heLastName} ${contact.heFirstName}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (contact.heAmka != null) Text('AMKA: ${contact.heAmka}'),
                            if (contact.hePhone2 != null) Text('Phone: ${contact.hePhone2}'),
                          ],
                        ),
                        trailing: Chip(
                          label: Text('${contact.prescriptionCount} Prescr.'),
                          backgroundColor: Colors.orange.shade100,
                        ),
                        onTap: () => _showPrescriptions(contact),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ContactDetailsScreen extends StatefulWidget {
  final Contact contact;

  const ContactDetailsScreen({super.key, required this.contact});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  final ApiService _apiService = ApiService();
  List<Prescription> _prescriptions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrescriptions();
  }

  Future<void> _loadPrescriptions() async {
    try {
      final prescriptions = await _apiService.getPrescriptions(widget.contact.heId);
      setState(() {
        _prescriptions = prescriptions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.contact.heLastName} ${widget.contact.heFirstName}'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AMKA: ${widget.contact.heAmka ?? "-"}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Text('Phone: ${widget.contact.hePhone2 ?? "-"}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (widget.contact.isDoctor)
                      const Chip(label: Text('Doctor'), backgroundColor: Colors.blueAccent),
                    if (widget.contact.isPatient)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Chip(label: Text('Patient'), backgroundColor: Colors.greenAccent),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Prescriptions History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _prescriptions.isEmpty
                    ? const Center(child: Text('No prescriptions found.'))
                    : ListView.builder(
                        itemCount: _prescriptions.length,
                        itemBuilder: (context, index) {
                          final p = _prescriptions[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: ListTile(
                              leading: const Icon(Icons.receipt_long, color: Colors.teal),
                              title: Text('Code: ${p.prescriptionCode}'),
                              subtitle: Text(
                                'Issued: ${DateFormat('dd/MM/yyyy').format(p.heIssueDate)}\n'
                                'Valid: ${DateFormat('dd/MM/yyyy').format(p.heValidFrom)} - ${DateFormat('dd/MM/yyyy').format(p.heValidTo)}',
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
