// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentSignUpPage extends StatefulWidget {
  const StudentSignUpPage({Key? key}) : super(key: key);

  @override
  _StudentSignUpPageState createState() => _StudentSignUpPageState();
}

class _StudentSignUpPageState extends State<StudentSignUpPage> {
  String? selectedSchool;
  List<String> schools = [];

  final CollectionReference schoolCollection =
      FirebaseFirestore.instance.collection('school');

  void initState() {
    super.initState();
    fetchSchools();
  }

  void fetchSchools() async {
    final QuerySnapshot snapshot = await schoolCollection.get();
    final List<String> fetchedSchools =
        snapshot.docs.map((doc) => doc['schoolName'].toString()).toList();
    setState(() {
      schools = fetchedSchools;
    });
  }

  int? selectedGrade;
  List<int> grades = [10, 11, 12];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFCEC),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Image.asset(
                'images/Subject.png',
                height: 200,
              ),
              Text(
                'انشاء حساب طالب',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0A2F5A),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Dropdown for selecting schools
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color(0xFF7EB347), width: 2.0),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(24, 127, 179, 71),
                ),
                icon: Icon(Icons.arrow_drop_down, color: Color(0xFF7EB347)),
                value: selectedSchool,
                items: schools.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, textAlign: TextAlign.right),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSchool = newValue;
                  });
                },
                hint: Text('المدرسة', textAlign: TextAlign.right),
              ),
              SizedBox(height: 16),

              buildTextField(
                hintText: 'الاسم',
                icon: FontAwesomeIcons.user,
              ),
              SizedBox(height: 16),
              buildTextField(
                hintText: 'البريد الالكتروني',
                icon: FontAwesomeIcons.envelope,
              ),
              SizedBox(height: 16),
              buildTextField(
                hintText: 'كلمة المرور',
                icon: FontAwesomeIcons.lock,
                obscureText: true,
              ),
              SizedBox(height: 16),
              buildTextField(
                hintText: 'رقم الهاتف',
                icon: FontAwesomeIcons.phone,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              // Dropdown for selecting a grade
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color(0xFF7EB347), width: 2.0),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(24, 127, 179, 71),
                ),
                icon: Icon(Icons.arrow_drop_down, color: Color(0xFF7EB347)),
                value: selectedGrade,
                items: grades.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString(), textAlign: TextAlign.right),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedGrade = newValue;
                  });
                },
                hint: Text('الصف الدراسي', textAlign: TextAlign.right),
              ),
              SizedBox(height: 16),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Handle sign-up logic
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF0A2F5A),
                  onPrimary: Colors.white,
                ),
                child: Text(
                  'تسجيل',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon,
            color: Color(
                0xFF7EB347)), // Use the same icon color as in the login page
        filled: true,
        fillColor: Color.fromARGB(
            24, 127, 179, 71), // Use the same fill color as in the login page
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color.fromARGB(40, 127, 179, 71),
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xFF7EB347),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xFF7EB347),
            width: 2.0,
          ),
        ),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }
}
