import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'user_state.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'dart:io';

class StudentMyhours extends StatefulWidget {
  @override
  _StudentMyhours createState() => _StudentMyhours();
}

class Opportunity {
  final String name;
  final String opportunityId;
  Opportunity(this.name, this.opportunityId);
}

int hours = 0;
String castedhours = '';

class _StudentMyhours extends State<StudentMyhours> {
  List<String> items = List<String>.generate(2, (index) => 'Item $index');
  List<String> filteredItems = [];
  //List<Student> StudentList = [];
  @override
  void initState() {
    super.initState();
    filteredItems = items;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getVerifiedOpp();
      getVerifiedhours();
    });

    // _loadProfileData();
  }

  List<Opportunity> verifiedOpp = [];
  List<Opportunity> verifiedOpp2 = [];

  Future<void> getVerifiedOpp() async {
    String studentId = Provider.of<UserState>(context, listen: false).userId;
    QuerySnapshot<Map<String, dynamic>> seatSnapshot = await FirebaseFirestore
        .instance
        .collection('seat')
        .where('studentId', isEqualTo: studentId)
        .where('certificateStatus', isEqualTo: true)
        .get();
    if (seatSnapshot.docs.isNotEmpty) {
      for (var seatDoc in seatSnapshot.docs) {
        String opportunityId = seatDoc.data()['opportunityId'];

        DocumentSnapshot<Map<String, dynamic>> internalOpportunitySnapshot =
            await FirebaseFirestore.instance
                .collection('internalOpportunity')
                .doc(opportunityId)
                .get();

        if (internalOpportunitySnapshot.exists) {
          String name = internalOpportunitySnapshot.get('name');
          Opportunity opportunity = Opportunity(name, opportunityId);
          verifiedOpp.add(opportunity);
        }

        DocumentSnapshot<Map<String, dynamic>> externalOpportunitySnapshot =
            await FirebaseFirestore.instance
                .collection('externalOpportunity')
                .doc(opportunityId)
                .get();

        if (externalOpportunitySnapshot.exists) {
          String name = externalOpportunitySnapshot.get('name');
          Opportunity opportunity = Opportunity(name, opportunityId);
          verifiedOpp.add(opportunity);
        }
      }
      setState(() {
        verifiedOpp2 = verifiedOpp; // Update the studentList
      });
    }
  }

  Future<void> getVerifiedhours() async {
    String studentId = Provider.of<UserState>(context, listen: false).userId;
    DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
        await FirebaseFirestore.instance
            .collection('student')
            .doc(studentId)
            .get();
    hours = studentSnapshot.get('verifiedHours');
    castedhours = ' ${hours.toString()} ';
  }

  void _showCertificatePopup(BuildContext context, String opportunityId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String studentId =
            Provider.of<UserState>(context, listen: false).userId;

        return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('seat')
              .where('studentId', isEqualTo: studentId)
              .where('opportunityId', isEqualTo: opportunityId)
              .get(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('No Data Found');
            }

            // Assuming there's only one document matching the query
            DocumentSnapshot<Map<String, dynamic>> document =
                snapshot.data!.docs[0];

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
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 187, 213, 159),
                        ),
                        child: Text(
                          'اغلاق',
                          style: TextStyle(
                            color: Color(0xFF0A2F5A),
                          ),
                        )),
                  ],
                ),
              ),
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
                  right: 70,
                  top: 20,
                  child: Text(
                    " ساعاتي  ",
                    style: TextStyle(
                      color: Color(0xFF0A2F5A),
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
            leading: IconButton(
                iconSize: 60,
                padding: EdgeInsets.only(bottom: 6, left: 300),
                color: Color.fromARGB(115, 127, 179, 71),
                onPressed: () {},
                icon: Icon(Icons.access_time))),
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
                  padding: EdgeInsets.only(bottom: 20, left: 310),
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
              // SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.only(left: 5, bottom: 5, top: 1, right: 5),
                child: Container(
                  width: 160,
                  margin: EdgeInsets.fromLTRB(140, 1, 1, 1),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(115, 127, 179, 71),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.rtl,
                    "الساعات التي تم اكمالها",
                    style: TextStyle(color: Color(0xFF0A2F5A), fontSize: 16),
                  ),
                ),
              ),

              SizedBox(height: 5.0),
              Padding(
                padding: EdgeInsets.only(left: 5, bottom: 5, top: 1),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFFf7f6d4),
                  ),
                  height: 280,
                  width: 400,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromARGB(115, 127, 179, 71),
                          ),
                          child: Text(
                            '$castedhours ساعه',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF0A2F5A)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 35),
                        color: Color(0xFFf7f6d4),
                        height: 200,
                        width: 400,
                        child: PieChart(
                          PieChartData(
                            startDegreeOffset: -90,
                            centerSpaceRadius: 50,
                            centerSpaceColor: Color(0xFFf7f6d4),
                            sections: [
                              PieChartSectionData(
                                color: Color.fromARGB(115, 127, 179, 71),
                                value: (hours >= 40) ? 100 : (hours / 40 * 100),
                                title:
                                    '${(hours >= 40) ? 100 : (hours / 40 * 100).toStringAsFixed(2)}%',
                                radius: 70,
                                titleStyle: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              PieChartSectionData(
                                color: Colors.white,
                                value: (hours >= 40)
                                    ? 0
                                    : (100 - (hours / 40 * 100)),
                                title: 'المتبقي',
                                radius: 70,
                              ),
                            ],
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: EdgeInsets.only(left: 5, bottom: 5, top: 1),
                child: Container(
                  width: 200,
                  margin: EdgeInsets.fromLTRB(130, 1, 1, 1),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(115, 127, 179, 71),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.rtl,
                    "فرص تطوع تم التحقق منها",
                    style: TextStyle(color: Color(0xFF0A2F5A), fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 5.0),
              Expanded(
                child: ListView.builder(
                  itemCount: verifiedOpp.length,
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
                            Positioned(
                                top: 10,
                                //left: 40,
                                right: 73,
                                child: Container(
                                  //padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color.fromARGB(115, 127, 179, 71),
                                  ),
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    verifiedOpp[index].name,
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xFF0A2F5A)),
                                  ),
                                )),
                            Positioned(
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 35,
                                    left: 0,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        _showCertificatePopup(context,
                                            verifiedOpp[index].opportunityId);
                                      },
                                      icon: IconTheme(
                                        data: IconThemeData(
                                            size: 10, color: Color(0xFF0A2F5A)),
                                        child:
                                            Icon(Icons.remove_red_eye_rounded),
                                      ),
                                      label: Text(
                                        'عرض الشهاده',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0A2F5A),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 187, 213, 159),
                                        fixedSize: Size(140, 1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
