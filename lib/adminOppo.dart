import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
/*CollectionReference internalOpportunity =
    FirebaseFirestore.instance.collection('internalOpportunity');*/
CollectionReference externalOpportunity =
    FirebaseFirestore.instance.collection('externalOpportunity');


void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFfbfae9)),
      home: adminOppo(),
    );
  }
}

class adminOppo extends StatefulWidget {
  @override
 _OpportunityPageState createState() => _OpportunityPageState();
  
}


class _OpportunityPageState extends State<adminOppo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
            backgroundColor: Color(0xFFece793),
            iconTheme: IconThemeData(color: Color(0xFFD3CA25), size: 45.0),
            title: Stack(
              alignment: Alignment.centerRight,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(0),
                      height: 58,
                      width: 60,
                    ),
                  ],
                ),
                Positioned(
                  right: 80,
                  top: 20,
                  child: Text(
                    "فرص التطوع",
             
                    style: TextStyle(
                      color: Color(0xFF0A2F5A),
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
            leading: IconButton(
                iconSize: 70,
                padding: EdgeInsets.only(bottom: 6, left: 300),
                color: Color.fromARGB(115, 127, 179, 71),
                onPressed: () {},
                icon: Icon(Icons.handshake_rounded))),
      ),
      
     body: SingleChildScrollView(
  child: Container(
    padding: EdgeInsets.all(5),
    margin: EdgeInsets.only(right: 5, left: 5),
    child: Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), // Adjust the border radius as needed
                  border: Border.all(
                    color:  Color(0xFFD3CA25), // Adjust the border color as needed
                    width: 1, // Adjust the border width as needed
                  ),
                ),
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.add,
                  color: Color(0xFFD3CA25), // Adjust the icon color as needed
                ),
              ),
              IconButton(
                color: Color(0xFFD3CA25),
                icon: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: Icon(Icons.arrow_back_rounded),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),


    

 
    );
  }}
