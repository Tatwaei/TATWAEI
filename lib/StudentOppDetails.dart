import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'user_state.dart';
import 'package:url_launcher/url_launcher.dart';

class OpportunityDetails extends StatefulWidget {
  @override
  _OpportunityPageState createState() => _OpportunityPageState();

  final String oppId;
  OpportunityDetails({required this.oppId});
}

class _OpportunityPageState extends State<OpportunityDetails> {
  late String opportunityId;
  late String collectionName = "";
  late String oppname = '';
  late String oppdesc = '';
  late String gender = '';

  late String startdate = '';
  late String enddate = '';
  late DateTime startDate = DateTime.now();
  late DateTime endDate = DateTime.now();
  late int numberOfDays = 0;
  late int numofseats = 0;
  late int numofhrs = 0;
  late String interest = '';
  late String place = '';
  late String loc = '';

  void initState() {
    super.initState();
    print('OpportunityDetails oppId: ${widget.oppId}');
    opportunityId = widget.oppId;
    fetchData(widget.oppId);
  }

  Future<void> fetchData(String oppId) async {
    try {
      // Assuming oppId is a unique identifier for opportunities
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
        // Handle the case where neither document exists
        // You can show an error message or take appropriate action
        print('Opportunity not found in any collection');
        return;
      }

      // Now you know the collection, you can fetch the specific fields
      DocumentSnapshot<Map<String, dynamic>> opportunityDocument =
          await FirebaseFirestore.instance
              .collection(collectionName)
              .doc(oppId)
              .get();

      // Access specific fields from the opportunityDocument
      setState(() {
        oppname = opportunityDocument['name'];
        oppdesc = opportunityDocument['description'];
        gender = opportunityDocument['gender'];

        // Convert 'startDate' and 'endDate' to DateTime objects
        startDate = (opportunityDocument['startDate'] as Timestamp).toDate();
        endDate = (opportunityDocument['endDate'] as Timestamp).toDate();
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
      // Add more fields as needed
    } catch (e) {
      print('Error fetching data: $e');
      // Handle the error, show an error message or take appropriate action
    }
  }

  Future<bool> checkIfAlreadyRegistered(
      String opportunityId, String studentId) async {
    try {
      // Check if there is a record in the 'seats' collection for the given opportunity and student
      QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
          .instance
          .collection('seat')
          .where('opportunityId', isEqualTo: opportunityId)
          .where('studentId', isEqualTo: studentId)
          .get();

      // If there is at least one document, the student is already registered
      return result.docs.isNotEmpty;
    } catch (e) {
      print('Error checking registration: $e');
      // Handle the error, show an error message, or take appropriate action
      return false; // Assume not registered in case of an error
    }
  }

// Call the function with the oppId you received

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
                                      "عدد المقاعد المتاحة",
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
                                  .isNotEmpty, // Show only if place is not empty
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
                                              // You can replace the print statement with the logic to open the link
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
      floatingActionButton: startDate.isBefore(DateTime.now())
          ? null // Hide the button if startdate is before the current date
          : Padding(
              padding: EdgeInsets.only(
                  bottom: 16.0), // Adjust the bottom padding to move it up
              child: FloatingActionButton(
                onPressed: () {
                  _showDialog();
                },
                child: Text(
                  "للتسجيل",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Color.fromARGB(115, 127, 179, 71),
                elevation: 0,
                hoverColor: Color(0xFF0A2F5A),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  void _showDialog() async {
    String opportunityId = widget.oppId;
    String studentId = Provider.of<UserState>(context, listen: false).userId;

    if (numofseats > 0) {
      // Check if the student has already registered for this opportunity
      bool isAlreadyRegistered =
          await checkIfAlreadyRegistered(opportunityId, studentId);

      if (!isAlreadyRegistered) {
        // Decrement available seats
        numofseats--;

        // Determine the next seatNum based on the current numOfSeats
        int nextSeatNum = numofseats;

        // Update 'numOfSeats' in Firestore
        try {
          await FirebaseFirestore.instance
              .collection(collectionName) // Update with your collection name
              .doc(opportunityId)
              .update({
            'numOfSeats': numofseats,
          });

          // Create a new record in the 'seats' collection
          await FirebaseFirestore.instance.collection('seat').add({
            'opportunityId': opportunityId,
            'studentId': studentId,
            'certificateStatus': false,
            'availability': true,
            'certificate': '', // Empty string at the beginning
            'seatNum': nextSeatNum,
          });

          // Show success dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "تم التسجيل بنجاح ",
                  style: TextStyle(color: Color(0xFF0A2F5A)),
                  textAlign: TextAlign.center,
                ),
                content: IconButton(
                  iconSize: 120,
                  color: Color.fromARGB(115, 127, 179, 71),
                  icon: Icon(Icons.check_circle),
                  onPressed: () {},
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "الغاء",
                      style: TextStyle(color: Color(0xFF0A2F5A), fontSize: 20),
                    ),
                  ),
                ],
              );
            },
          );

          setState(() {});
        } catch (e) {
          print('Error updating numOfSeats: $e');
          // Handle the error, show an error message, or take appropriate action
        }
      } else {
        // Student is already registered for this opportunity, show a message or handle accordingly
        // ...
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "تم التسجيل في الفرصة من قبل",
                style: TextStyle(color: Color(0xFF0A2F5A)),
                textAlign: TextAlign.center,
              ),
              content: IconButton(
                iconSize: 120,
                color: Colors.red,
                icon: Icon(Icons.error),
                onPressed: () {},
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "الغاء",
                    style: TextStyle(color: Color(0xFF0A2F5A), fontSize: 20),
                  ),
                ),
              ],
            );
          },
        );
      }
    } else {
      // No available seats, show a message or handle accordingly
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "لا يوجد مقاعد متاحة",
              style: TextStyle(color: Color(0xFF0A2F5A)),
              textAlign: TextAlign.center,
            ),
            content: IconButton(
              iconSize: 120,
              color: Colors.red,
              icon: Icon(Icons.error_outline_rounded),
              onPressed: () {},
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "الغاء",
                  style: TextStyle(
                    color: Color(0xFF0A2F5A),
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
