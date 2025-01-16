import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactDetailsPage extends StatefulWidget {
  final String contactId;
  final String initialName;
  final String initialNumber;

  const ContactDetailsPage({
    required this.contactId,
    required this.initialName,
    required this.initialNumber,
    Key? key,
  }) : super(key: key);

  @override
  _ContactDetailsPageState createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _numberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _numberController = TextEditingController(text: widget.initialNumber);
  }

  Future<void> updateContact() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('contacts')
            .doc(widget.contactId)
            .update({
          'name': _nameController.text,
          'number': _numberController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contact updated successfully')),
        );

        // Go back to the previous screen
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update contact: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _numberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: updateContact,
                  child: Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
