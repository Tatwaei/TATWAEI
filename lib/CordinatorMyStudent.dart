import 'package:flutter/material.dart';
import 'dart:math';
import 'coordinatorOneStudent.dart';
import 'package:provider/provider.dart';
import 'user_state.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'dart:io';

class CordinatorMyStudent extends StatefulWidget {
  @override
  _CordinatorMyStudent createState() => _CordinatorMyStudent();
}

class Student {
  final String name;
  final String castedid;
  final String castedhours;
  final String documentId;
  Student(this.name, this.castedid, this.castedhours, this.documentId);
}

class _CordinatorMyStudent extends State<CordinatorMyStudent> {
  //List<String> items = List<String>.generate(100, (index) => 'Item $index');
  //List<String> filteredItems = [];
  List<Student> studentList = [];
  List<Student> fetchedStudentList = [];

  @override
  void initState() {
    super.initState();
    //filteredItems = items;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStudentList();
    });

    // _loadProfileData();
  }

  String documentId = '';

  Future<void> getStudentList() async {
    String studentId = Provider.of<UserState>(context, listen: false).userId;
    DocumentSnapshot<Map<String, dynamic>> coordSnapshot =
        await FirebaseFirestore.instance
            .collection('schoolCoordinator')
            .doc(studentId)
            .get();

    String schoolId = coordSnapshot.get('schoolId');
    //String schhol = studentId.get('schoolId');
    QuerySnapshot<Map<String, dynamic>> studentSnapshot =
        await FirebaseFirestore.instance
            .collection('student')
            .where('schoolId', isEqualTo: schoolId)
            .get();

    if (studentSnapshot.size > 0) {
      // List<Student> studentList = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in studentSnapshot.docs) {
        documentId = documentSnapshot.id;

        String name = documentSnapshot.get('name');
        int studentId = documentSnapshot.get('StudentId');
        String castedid = studentId.toString();
        int hours = documentSnapshot.get('verifiedHours');
        String castedhours = hours.toString();

        Student student = Student(name, castedid, castedhours, documentId);
        fetchedStudentList.add(student);
      }
      setState(() {
        studentList = fetchedStudentList; // Update the studentList
      });
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
                  right: 70,
                  top: 20,
                  child: Text(
                    " طلابي  ",
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
                icon: Icon(Icons.group_rounded))),
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
                SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                    itemCount: studentList.length,
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
                                  left: 120,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color.fromARGB(115, 127, 179, 71),
                                    ),
                                    child: Text(
                                      studentList[index].name,
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                      ),
                                    ),
                                  )),
                              Positioned(
                                  top: 50,
                                  left: 180,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color.fromARGB(115, 127, 179, 71),
                                    ),
                                    child: Text(
                                      studentList[index].castedid,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0A2F5A),
                                      ),
                                    ),
                                  )),
                              Positioned(
                                  top: 12,
                                  left: 20,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color.fromARGB(115, 127, 179, 71),
                                    ),
                                    child: Text(
                                      studentList[index].castedhours,
                                      //studentList[index].verihours,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0A2F5A),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => coordinatorOneStudent(
                                    studentId: studentList[index].documentId)));
                          }, //going to the student info page
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
