import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewContactPage extends StatefulWidget {
  @override
  _NewContactPageState createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  void saveContact() {
    if (formKey.currentState!.validate()) {
      String name = nameController.text;
      String phone = numberController.text;

      // Perform save action (e.g., save to database or show success message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact saved: $name, $phone')),
      );

      // Clear fields after saving
      nameController.clear();
      numberController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Contact',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: nameController,
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
                controller: numberController,
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
                  onPressed: () async{
                    try{
                      CollectionReference collref = FirebaseFirestore.instance.collection('contacts');
                      await collref.add({
                        'name': nameController.text,
                        'number':numberController.text});

                      ScaffoldMessenger.of(context).showSnackBar
                        (SnackBar(content: Text('Contact Saved Successfully')));
                    }
                    catch(e){
                      ScaffoldMessenger.of(context).showSnackBar
                        (SnackBar(content: Text('Failed to store text: $e')));
                    }
                  },
                  child: Text('Save Contact'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
