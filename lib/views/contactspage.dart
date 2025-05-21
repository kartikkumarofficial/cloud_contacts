import 'package:cloud_contacts/views/contactdetailspage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_contacts/views/newcontactpage.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Stream<List<Map<String, dynamic>>> fetchContactsStream() {
    return FirebaseFirestore.instance
        .collection('contacts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'] ?? 'Unknown',
        'number': data['number'] ?? 'No number',
      };
    }).toList());
  }

  Future<void> deleteContact(String contactId) async {
    try {
      await FirebaseFirestore.instance.collection('contacts').doc(contactId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Contact deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete contact: $e')));
    }
  }
  @override
  Widget build(BuildContext context) {
    var srcwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cloud Contacts',
          style: GoogleFonts.cookie(
            fontSize: srcwidth * 0.1,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: fetchContactsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No contacts found.'));
          } else {
            final contacts = snapshot.data!;
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return Dismissible(
                  key: Key(contact['id']),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {

                    deleteContact(contact['id']);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          ContactDetailsPage(
                              contactId: contact['id'],
                              initialName: contact['name'],
                              initialNumber: contact['number']),));
                    },
                    leading: CircleAvatar(
                      child: Text(contact['name'][0].toUpperCase()),
                    ),
                    title: Text(contact['name']),
                    subtitle: Text(contact['number']),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewContactPage(),
            ),
          );
        },
      ),
    );
  }
}

