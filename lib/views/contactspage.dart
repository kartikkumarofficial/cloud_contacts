import 'package:cloud_contacts/views/newcontactpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_contacts/views/newcontactpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {

  //method that fetches contacts
  Stream<List<Map<String, dynamic>>> fetchContactsStream() {
    return FirebaseFirestore.instance
        .collection('contacts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'name': data['name'],
            'number': data['number']
          };
        }).toList());
  }

  Future<void> deleteContact(String contactId) async {
    try {
      await FirebaseFirestore.instance.collection('contacts')
          .doc(contactId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contact deleted successfully')));
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete text : $e')));
    }
  }
}


@override
Widget build(BuildContext context) {
  var srcheight = MediaQuery
      .of(context)
      .size
      .height;
  var srcwidth = MediaQuery
      .of(context)
      .size
      .width;
  var srcsize = MediaQuery
      .of(context)
      .size;

  return Scaffold(
    appBar: AppBar(
      title: Text('Cloud Contacts',
        style: GoogleFonts.cookie(
          fontSize: srcwidth * 0.1,
          fontWeight: FontWeight.w400,),
      ),
    ),

    body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: fetchContactsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error} '),);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty{
          return Center(child: 'No contacts found.');
          }else {
          final contacts = snapshot.data!;
          return ListView.builder(
          itemCount: contacts.length,
          itemBuilder:(context, index) {
          final contact = contacts[index];
          return Dismissible(
          key: ,
          )
          },)
          )
          }


          }
    ),
    floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewContactPage(),));
        }),

  );
}}
