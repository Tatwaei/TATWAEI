import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tatwaei/cEditDelete.dart';
import 'package:tatwaei/homePageCoordinator.dart';
import 'dart:math';

import 'package:url_launcher/url_launcher.dart';

class cDelete extends StatefulWidget {
  @override
  _OpportunityPageState createState() => _OpportunityPageState();

  final String oppId;
  cDelete({required this.oppId});
}

class _OpportunityPageState extends State<cDelete> {
  late String oppname = '';
  late String oppdesc = '';
  late String gender = '';

  late String startdate = '';
  late String enddate = '';
  late int numberOfDays = 0;
  late int numofseats = 0;
  late int numofhrs = 0;
  late String interest = '';
  late String place = '';
  late String loc = '';
  late bool isInternalOpportunity = true;

  void initState() {
    super.initState();
    print('OpportunityDetails oppId: ${widget.oppId}');
    fetchData(widget.oppId);
  }

  Future<void> fetchData(String oppId) async {
    try {
      String collectionName;

      
      DocumentSnapshot<Map<String, dynamic>> oppDocumentInternal =
          await FirebaseFirestore.instance
              .collection('internalOpportunity')
              .doc(oppId)
              .get();

      DocumentSnapshot<Map<String, dynamic>> oppDocumentExternal =
          await FirebaseFirestore.instance
              .collection('externalOpportunity')
              .doc(oppId)
              .get();

      if (oppDocumentInternal.exists) {
        // The opportunity belongs to internalOpportunity collection
        collectionName = 'internalOpportunity';
      } else if (oppDocumentExternal.exists) {
        // The opportunity belongs to externalOpportunity collection
        collectionName = 'externalOpportunity';
      } else {
       
        print('Opportunity not found in any collection');
        return;
      }
      isInternalOpportunity = collectionName == 'internalOpportunity';

    
      DocumentSnapshot<Map<String, dynamic>> opportunityDocument =
          await FirebaseFirestore.instance
              .collection(collectionName)
              .doc(oppId)
              .get();

    
      setState(() {
        oppname = opportunityDocument['name'];
        oppdesc = opportunityDocument['description'];
        gender = opportunityDocument['gender'];

        // Convert 'startDate' and 'endDate' to DateTime objects
        DateTime startDate =
            (opportunityDocument['startDate'] as Timestamp).toDate();
        DateTime endDate =
            (opportunityDocument['endDate'] as Timestamp).toDate();
        // Format 'startDate' and 'endDate' to display only the date
        startdate =
            "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
        enddate =
            "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";

        Duration duration = endDate.difference(startDate);
        numberOfDays = duration.inDays;

        numofseats = opportunityDocument['numOfSeats'];
        numofhrs = opportunityDocument['numOfHours'];
        interest = opportunityDocument['interest'];

        if (collectionName == 'externalOpportunity') {
          place = opportunityDocument['opportunityProvider'];
          loc = opportunityDocument['location'];
        } else {
          place = "داخل الدرسة";
          loc = "";
        }
      });
      ;
     
    } catch (e) {
      print('Error fetching data: $e');
     
    }
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
                    "تفاصيل الفرص",
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
              Container(
                height: 600,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFece793),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(115, 127, 179, 71),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            '$oppname',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5), //
                      child: Container(
                        height: 520,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFece793),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 5, left: 5, top: 3),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'تفاصيل الفرصة التطوعية',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 127, 179, 71),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5, left: 5, bottom: 5, top: 1),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '$oppdesc',
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 5, left: 5, top: 3),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '$enddate  -  $startdate',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 127, 179, 71),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5, left: 5, bottom: 5, top: 1),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "يوم",
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                    Text(
                                      " $numberOfDays",
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 5, left: 5, top: 3),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "عدد المقاعد",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 127, 179, 71),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5, left: 5, bottom: 5, top: 1),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "مقعد",
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                    Text(
                                      " $numofseats",
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 5, left: 5, top: 3),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "المجال التطوعي",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 127, 179, 71),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5, left: 5, bottom: 5, top: 1),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "$interest",
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 5, left: 5, top: 3),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "الجنس",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 127, 179, 71),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5, left: 5, bottom: 5, top: 1),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "$gender",
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 5, left: 5, top: 3),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "عدد الساعات المكتسبة",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 127, 179, 71),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5, left: 5, bottom: 5, top: 1),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "$numofhrs",
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 5, left: 5, top: 3),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "مكان التطوع",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 127, 179, 71),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5, left: 5, bottom: 5, top: 1),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "$place",
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: loc
                                  .isNotEmpty, 
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 5, left: 5, top: 3),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "الموقع",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 127, 179, 71),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 5, left: 5, bottom: 5, top: 1),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              launch(loc);
                                              print('Opening link: $loc');
                                             
                                            },
                                            child: Text(
                                              "$loc",
                                              style: TextStyle(
                                                color: Color(0xFF0A2F5A),
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              softWrap: true,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
  padding: const EdgeInsets.only(bottom: 40.0),
  child: Container(
    width: MediaQuery.of(context).size.width - 30,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjusted spacing
      children: [
        FloatingActionButton(
          onPressed: () {
            
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "تم إلغاء الحذف بنجاح",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF0A2F5A),
                    ),
                  ),
                );
              },
            );
          },
          child: Text(
            "إلغاء",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(115, 127, 179, 71),
          elevation: 0,
        ),
        FloatingActionButton(
          onPressed: () {
          
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "تم الحذف بنجاح",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF0A2F5A),
                    ),
                  ),
                );
              },
            );
            
            Future.delayed(Duration(seconds: 5), () {
              deleteOpportunityFromDatabase(widget.oppId);
            });
          },
          child: Text(
            "حذف",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(115, 127, 179, 71),
          elevation: 0,
        ),
      ],
    ),
  ),
),
floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

  
    );
  }

  // Function  delete 
  void deleteOpportunityFromDatabase(String oppId) async {
    try {
      String collectionName;

      
      DocumentSnapshot<Map<String, dynamic>> oppDocumentInternal =
          await FirebaseFirestore.instance
            .collection('internalOpportunity')
              .doc(oppId)
              .get();

      DocumentSnapshot<Map<String, dynamic>> oppDocumentExternal =
          await FirebaseFirestore.instance
              .collection('externalOpportunity')
              .doc(oppId)
              .get();

      if (oppDocumentInternal.exists) {
       
        collectionName = 'internalOpportunity';
      } else if (oppDocumentExternal.exists) {
      
        collectionName = 'externalOpportunity';
      } else {
        
        print('Opportunity not found in any collection');
        return;
      }

      // Delete opportunity from database
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(oppId)
          .delete();

      print('internal Opportunity deleted successfully');
    } catch (e) {
      print('Error deleting opportunity: $e');
     
    }
  }
}
