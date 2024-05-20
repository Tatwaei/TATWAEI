import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'StudentOppDetails.dart';

class coordinatorOneStudent extends StatefulWidget {
  @override
  _coordinatorOneStudent createState() => _coordinatorOneStudent();

  final String studentId;
  coordinatorOneStudent({required this.studentId});
}

class Opportunity1 {
  final String name;
  final String interest;
  final String source;
  final String opportunityId;

  Opportunity1(this.name, this.interest, this.source, this.opportunityId);
}

class Opportunity2 {
  final String name;
  final String opportunityId;

  Opportunity2(this.name, this.opportunityId);
}

class _coordinatorOneStudent extends State<coordinatorOneStudent> {
  String initialName = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserData();
      getCurrentOpp();
      getCompOpp();
    });
  }

  Future<void> getUserData() async {
    DocumentSnapshot<Map<String, dynamic>> userDocument =
        await FirebaseFirestore.instance
            .collection('student')
            .doc(widget.studentId)
            .get();
    if (userDocument.exists) {
      setState(() {
        // Update your state with the retrieved data
        initialName = userDocument.get('name');
      });
    }
  }

  bool showList1 = false;
  bool showList2 = false;

  List<Opportunity1> currentList = [];
  List<Opportunity2> compList = [];

  Future<void> getCurrentOpp() async {
    QuerySnapshot<Map<String, dynamic>> seatSnapshot = await FirebaseFirestore
        .instance
        .collection('seat')
        .where('studentId', isEqualTo: widget.studentId)
        .get();

    if (seatSnapshot.docs.isNotEmpty) {
      DateTime todayDate = DateTime.now();

      for (var seatDoc in seatSnapshot.docs) {
        String opportunityId = seatDoc.data()['opportunityId'];

        // Retrieve internal opportunity
        DocumentSnapshot<Map<String, dynamic>> internalOpportunitySnapshot =
            await FirebaseFirestore.instance
                .collection('internalOpportunity')
                .doc(opportunityId)
                .get();

        if (internalOpportunitySnapshot.exists) {
          DateTime endDate =
              internalOpportunitySnapshot.get('endDate').toDate();

          if (endDate.isAfter(todayDate)) {
            String name = internalOpportunitySnapshot.get('name');
            String interest = internalOpportunitySnapshot.get('interest');
            Opportunity1 opportunity = Opportunity1(name, interest, 'داخلية',
                opportunityId); // Set source as internal
            currentList.add(opportunity);
          }
        }

        // Retrieve external opportunity
        DocumentSnapshot<Map<String, dynamic>> externalOpportunitySnapshot =
            await FirebaseFirestore.instance
                .collection('externalOpportunity')
                .doc(opportunityId)
                .get();

        if (externalOpportunitySnapshot.exists) {
          DateTime endDate =
              externalOpportunitySnapshot.get('endDate').toDate();

          if (endDate.isAfter(todayDate)) {
            String name = externalOpportunitySnapshot.get('name');
            String interest = externalOpportunitySnapshot.get('interest');
            Opportunity1 opportunity =
                Opportunity1(name, interest, 'خارجية', opportunityId);
            currentList.add(opportunity);
          }
        }
      }
    }
  }

  Future<void> getCompOpp() async {
    QuerySnapshot<Map<String, dynamic>> seatSnapshot = await FirebaseFirestore
        .instance
        .collection('seat')
        .where('studentId', isEqualTo: widget.studentId)
        .get();

    if (seatSnapshot.docs.isNotEmpty) {
      DateTime todayDate = DateTime.now();

      for (var seatDoc in seatSnapshot.docs) {
        String opportunityId = seatDoc.data()['opportunityId'];

        // Retrieve internal opportunity
        DocumentSnapshot<Map<String, dynamic>> internalOpportunitySnapshot =
            await FirebaseFirestore.instance
                .collection('internalOpportunity')
                .doc(opportunityId)
                .get();

        if (internalOpportunitySnapshot.exists) {
          DateTime endDate =
              internalOpportunitySnapshot.get('endDate').toDate();

          if (endDate.isBefore(todayDate)) {
            String name = internalOpportunitySnapshot.get('name');
            Opportunity2 opp =
                Opportunity2(name, opportunityId); // Set source as internal
            compList.add(opp);
          }
        }

        // Retrieve external opportunity
        DocumentSnapshot<Map<String, dynamic>> externalOpportunitySnapshot =
            await FirebaseFirestore.instance
                .collection('externalOpportunity')
                .doc(opportunityId)
                .get();

        if (externalOpportunitySnapshot.exists) {
          DateTime endDate =
              externalOpportunitySnapshot.get('endDate').toDate();

          if (endDate.isBefore(todayDate)) {
            String name = externalOpportunitySnapshot.get('name');
            Opportunity2 opp =
                Opportunity2(name, opportunityId); // Set source as internal
            compList.add(opp);
          }
        }
      }
    }
  }

  void myAlert(BuildContext context, String opportunityId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('seat')
              .where('studentId', isEqualTo: widget.studentId)
              .where('opportunityId', isEqualTo: opportunityId)
              .get(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the data to load, you can show a loading indicator
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              // If there's an error, you can show an error message
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              // If the document doesn't exist or there's no data, you can show a message
              return Text('No Data Found');
            }

            // Assuming there's only one document matching the query
            DocumentSnapshot<Map<String, dynamic>> document =
                snapshot.data!.docs[0];

            // Access the image URL from the document snapshot
            String imageUrl = document.get('certificate');
            String documentId = document.id;
            print('Document Snapshot: $documentId');

            print('Image URL: $imageUrl');

            return AlertDialog(
              backgroundColor: Color(0xFFf4f1be),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              content: Container(
                height: MediaQuery.of(context).size.width * 0.8,
                width: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  children: [
                    if (imageUrl != null && imageUrl.isNotEmpty)
                      Container(
                        width: 200,
                        height: 200,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (imageUrl == null || imageUrl.isEmpty)
                      Text(
                        'No Image Uploaded',
                        style: TextStyle(fontSize: 20),
                      ),
                  ],
                ),
              ),
              actions: [
                ButtonBar(
                  buttonPadding: EdgeInsets.only(right: 50),
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Update the certificateStatus to true
                        FirebaseFirestore.instance
                            .collection('seat')
                            .doc(documentId)
                            .update({'certificateStatus': false,'certificate': ''}).then((_) {
                          // Show a success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم رفض الشهادة'),
                            ),
                          );

                          // Close the dialog
                          Navigator.pop(context);
                        }).catchError((error) {
                          // Show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('حدث خطأالرجاء المحاولة مرة أخرى'),
                            ),
                          );
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFFb4d392)),
                      ),
                      child: Text(
                        'رفض',
                        style: TextStyle(color: Color(0xFF0A2F5A)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Update the certificateStatus to true
                        FirebaseFirestore.instance
                            .collection('seat')
                            .doc(documentId)
                            .update({'certificateStatus': true}).then(
                                (_) async {
                          // Show a success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم التوثيق بنجاح'),
                            ),
                          );

                          // Get the numOfHours value from the opportunity document
                          DocumentSnapshot<Map<String, dynamic>>
                              opportunitySnapshot = await FirebaseFirestore
                                  .instance
                                  .collection('internalOpportunity')
                                  .doc(opportunityId)
                                  .get();
                          if (!opportunitySnapshot.exists) {
                            opportunitySnapshot = await FirebaseFirestore
                                .instance
                                .collection('externalOpportunity')
                                .doc(opportunityId)
                                .get();
                          }

                          if (opportunitySnapshot.exists) {
                            int numOfHours =
                                opportunitySnapshot.get('numOfHours');

                            // Get the current value of verifiedHours from the student document
                            DocumentSnapshot<Map<String, dynamic>>
                                studentSnapshot = await FirebaseFirestore
                                    .instance
                                    .collection('student')
                                    .doc(widget.studentId)
                                    .get();

                            int currentVerifiedHours =
                                studentSnapshot.get('verifiedHours') ?? 0;

                            // Calculate the new value of verifiedHours
                            int updatedVerifiedHours =
                                currentVerifiedHours + numOfHours;

                            // Update verifiedHours in the student document
                            FirebaseFirestore.instance
                                .collection('student')
                                .doc(widget.studentId)
                                .update(
                                    {'verifiedHours': updatedVerifiedHours});
                          }
                          // Close the dialog
                          Navigator.pop(context);
                        }).catchError((error) {
                          // Show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('حدث خطأ أثناء التوثيق'),
                            ),
                          );
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFFb4d392)),
                      ),
                      child: Text(
                        'توثيق',
                        style: TextStyle(color: Color(0xFF0A2F5A)),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
            backgroundColor: Color.fromRGBO(236, 231, 147, 1),
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
                    'طلابي',
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
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  color: Color(0xFFD3CA25),
                  padding: EdgeInsets.only(bottom: 10, left: 310),
                  icon: Transform(
                    alignment: Alignment.topRight,
                    transform: Matrix4.rotationY(pi),
                    child: Icon(Icons.arrow_back),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFFb4d392)),
                child: Text(
                  initialName,
                  style: TextStyle(fontSize: 18, color: Color(0xFF0A2F5A)),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showList2 = !showList2;
                        });
                      },
                      child: Text(
                        "المكتملة",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFF0A2F5A)),
                      ),
                      style: ButtonStyle(
                         backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Color(0xFFb4d392); // Color when pressed
                            }
                            return showList2
                                ? Color.fromARGB(255, 230, 248, 211)
                                : Color(
                                    0xFFb4d392); // Default color and color when not pressed
                          },
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                              color: Color(0xFFb4d392),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showList1 = !showList1;
                        });
                      },
                      child: Text(
                        "الحالية",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFF0A2F5A)),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Color(0xFFb4d392); // Color when pressed
                            }
                            return showList1
                                ? Color.fromARGB(255, 230, 248, 211)
                                : Color(
                                    0xFFb4d392); // Default color and color when not pressed
                          },
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                              color: Color(0xFFb4d392),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              if (showList1) ...[
                Expanded(
                  child: ListView.builder(
                    itemCount: currentList.length,
                    itemBuilder: (context, index) {
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
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color.fromARGB(115, 127, 179, 71),
                                  ),
                                  child: Text(
                                    currentList[index].name,
                                    style: TextStyle(
                                      color: Color(0xFF0A2F5A),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 50,
                                left: 120,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color.fromARGB(115, 127, 179, 71),
                                  ),
                                  child: Text(
                                    currentList[index].source == 'داخلية'
                                        ? 'داخلية'
                                        : 'خارجية',
                                    style: TextStyle(
                                      color: Color(0xFF0A2F5A),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 50,
                                left: 20,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color.fromARGB(115, 127, 179, 71),
                                  ),
                                  child: Text(
                                    currentList[index].interest,
                                    style: TextStyle(
                                      color: Color(0xFF0A2F5A),
                                      fontSize: 12,
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
                            String oppId = currentList[index].opportunityId;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => OpportunityDetails(
                                  oppId: oppId,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
              if (showList2) ...[
                Expanded(
                  child: ListView.builder(
                    itemCount: compList.length,
                    itemBuilder: (context, index) {
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
                                top: 16,
                                right: 80,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color.fromARGB(115, 127, 179, 71),
                                  ),
                                  child: Text(
                                    compList[index].name,
                                    style: TextStyle(
                                      color: Color(0xFF0A2F5A),
                                    ),
                                  ),
                                ),
                              ),
                              Stack(
                                children: [
                                  Positioned(
                                    top: 55,
                                    right: 180,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              myAlert(
                                                  context,
                                                  compList[index]
                                                      .opportunityId);
                                            },
                                            icon: IconTheme(
                                              data: IconThemeData(
                                                  size: 10,
                                                  color: Color(
                                                      0xFF0A2F5A)), // Set your desired icon size
                                              child: Icon(
                                                  Icons.remove_red_eye_rounded),
                                            ),
                                            label: Text(
                                              'عرض الشهادة',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFF0A2F5A)),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 187, 213, 159),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2, vertical: 2),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          "No Image",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                            String oppId = compList[index].opportunityId;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => OpportunityDetails(
                                  oppId: oppId,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
