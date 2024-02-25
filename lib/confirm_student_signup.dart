import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmStudentPage extends StatefulWidget {
  @override
  _ConfirmStudentPage createState() => _ConfirmStudentPage();
}

class _ConfirmStudentPage extends State<ConfirmStudentPage> {
  String schoolId = '';
  /*List<Map<String, dynamic>> items = [
    {'title': 'اسم الطالب الاول', 'subtitle': 'الصف الدرسي', 'id': 1},
    {'title': 'اسم الطالب الثاني', 'subtitle': 'الصف الدرسي', 'id': 1},
  ];*/
  List<Map<String, dynamic>> items = [];

  void _deleteItem(String id) {
    setState(() {
      items.removeWhere((item) => item['id'] == id);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSchoolId();
  }

  Future<void> fetchSchoolId() async {
    try {
      String userId = Provider.of<UserState>(context, listen: false).userId;
      var docSnapshot = await FirebaseFirestore.instance
          .collection('schoolCoordinator')
          .doc(userId)
          .get();
      if (docSnapshot.exists) {
        setState(() {
          schoolId = docSnapshot.data()?['schoolId'] ?? '';
          fetchStudents();
        });
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Error fetching document: $e");
    }
  }

  Future<void> fetchStudents() async {
    //retrieve students with the same schoolId as the coordinator and accountStatus is false
    var querySnapshot = await FirebaseFirestore.instance
        .collection('student')
        .where('schoolId', isEqualTo: schoolId)
        .where('accountStatus', isEqualTo: false)
        .get();

    // Transform the query results into the format used by the UI
    var fetchedItems = querySnapshot.docs
        .map((doc) => {
              'title': doc['name'],
              'subtitle': determineSubtitle(doc),
              'id': doc.id,
            })
        .toList();

    setState(() {
      items = fetchedItems;
    });
  }

  String determineSubtitle(doc) {
    if (doc['grade'] == 10) {
      return "الصف الأول";
    } else if (doc['grade'] == 11) {
      return "الصف الثاني";
    } else if (doc['grade'] == 12) {
      return "الصف الثالث";
    } else {
      return "Other Grade"; // Default case or further handling
    }
  }

  Future<void> acceptStudent(String studentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('student')
          .doc(studentId)
          .update({
        'accountStatus': true,
      });
    } catch (e) {
      print("Error updating document: $e");
    }
  }

  Future<void> denyStudent(String studentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('student')
          .doc(studentId)
          .delete();
    } catch (e) {
      print("Error deleting document: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFFece793),
          iconTheme: const IconThemeData(color: Color(0xFFD3CA25), size: 45.0),
          title: Stack(
            alignment: Alignment.centerRight,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(0),
                    height: 58,
                    width: 60,
                  ),
                ],
              ),
              const Positioned(
                right: 70,
                top: 20,
                child: Text(
                  " توثيق الطلاب  ",
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
              padding: const EdgeInsets.only(bottom: 6, left: 300),
              color: const Color.fromARGB(115, 127, 179, 71),
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.group_rounded))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                color: const Color(0xFFD3CA25),
                icon: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: const Icon(Icons.arrow_back),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                String itemId = items[index]['id'];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F6D4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color(0xFFc7dda0),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  items[index]['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0A2F5A),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await denyStudent(itemId);
                                      _deleteItem(itemId);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 13),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFA90505),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Text(
                                        'رفض',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () async {
                                      await acceptStudent(itemId);
                                      _deleteItem(itemId);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 13),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF7EB347),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Text(
                                        'قبول',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 119),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFc7dda0),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      items[index]['subtitle'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0A2F5A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
