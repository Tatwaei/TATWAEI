
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adminAdd.dart';
import 'AdminOppDetails.dart'; 

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
  late List<DocumentSnapshot> externalOpportunities = [];

  @override
  void initState() {
    super.initState();
    fetchExternalOpportunities();
  }

  Future<void> fetchExternalOpportunities() async {
    QuerySnapshot snapshot = await externalOpportunity.get();
    setState(() {
      externalOpportunities = snapshot.docs;
    });
  }

  Future<String> getSource(DocumentSnapshot opportunity) async {
    return 'خارجية';
  }

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
            icon: Icon(Icons.handshake_rounded),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 8, bottom: 8.0, left: 30, right: 30),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to adminAdd.dart
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => adminAdd()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Color(0xFFD3CA25),
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.add,
                      color: Color(0xFFD3CA25),
                    ),
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
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: externalOpportunities.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot opportunity = externalOpportunities[index];
                  return FutureBuilder<String>(
                    future: getSource(opportunity),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error loading source');
                      } else {
                        String source = snapshot.data!;
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFFf7f6d4),
                          ),
                          width: 70.0,
                          height: 90.0,
                          margin: EdgeInsets.only(bottom: 20),
                          child: ListTile(
                            title: Stack(
                              children: [
                                Positioned(
                                  top: 12,
                                  right: 80,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color.fromARGB(115, 127, 179, 71),
                                    ),
                                    child: Text(
                                      opportunity['name'],
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF0A2F5A),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 50,
                                  left: 130,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color.fromARGB(115, 127, 179, 71),
                                    ),
                                    child: Text(
                                      source,
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 50,
                                  left: 20,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color.fromARGB(115, 127, 179, 71),
                                    ),
                                    child: Text(
                                      opportunity['interest'],
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white,
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage('images/logo1.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              String oppId = opportunity.id;
                              print('Clicked oppId: $oppId');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      OpportunityDetails(oppId: oppId)));
                            },
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


