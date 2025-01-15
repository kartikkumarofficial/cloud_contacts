import 'package:cloud_contacts/views/newcontactpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
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
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewContactPage(),));
          }),

    );
  }
}
