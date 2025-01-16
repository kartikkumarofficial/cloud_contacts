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
  Stream<List<Map<String,dynamic>>>fetchContactsStream(){
    return FirebaseFirestore.instance
        .collection('contacts')
        .orderBy('timestamp',descending:true)
      .snapshots()
      .map((snapshot)=> snapshot.docs.map((doc){
        final data = doc.data();
        return{
          'id':doc.id,
          'name':data['name'],
          'number':data['number']
        };
    }).toList());
  }



  @override
  Widget build(BuildContext context) {
    var srcheight = MediaQuery.of(context).size.height;
    var srcwidth = MediaQuery.of(context).size.width;
    var srcsize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cloud Contacts',
          style: GoogleFonts.cookie(
        fontSize: srcwidth * 0.1,
        fontWeight: FontWeight.w400,),
      ),
      ),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


          ],

        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewContactPage(),));
          }),

    );
  }
}
