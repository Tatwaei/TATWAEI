// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tatwaei/login.dart';
import 'package:flutter/material.dart';
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

  // Controllers for the TextFormFields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    if (selectedSchool == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select your school.')),
      );
      return;
    }
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your name.')),
      );
      return;
    }

    if (_emailController.text.trim().isEmpty ||
        !_emailController.text.trim().contains('@') ||
        !_emailController.text.trim().contains('.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }
    if (_passwordController.text.isEmpty ||
        _passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password must be at least 6 characters long.')),
      );
      return;
    }
    if (_phoneController.text.trim().isEmpty ||
        _phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number.')),
      );
      return;
    }
    if (selectedGrade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select your grade.')),
      );
      return;
    }
    try {
      // Create user with FirebaseAuth
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Fetch school ID based on selected school name
      String schoolId = await fetchSchoolId(selectedSchool!);

      // Create student document in Firestore
      await FirebaseFirestore.instance.collection('student').add({
        'name': _nameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'accountStatus': false,
        'grade': selectedGrade,
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'schoolId': schoolId,
        'verifiedHours': 0,
      });

      // Navigate to HomePage if successful (ONLY FOR TESTING, SHOULD NAVIGATE TO LOG IN!)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle errors, e.g., email already in use, weak password
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    }
  }

  Future<String> fetchSchoolId(String schoolName) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('school')
        .where('schoolName', isEqualTo: schoolName)
        .limit(1)
        .get();
    if (result.docs.isNotEmpty) {
      print(result.docs.first.id);
      return result.docs.first.id; // Assuming schoolName is unique
    } else {
      throw Exception('School not found');
    }
  }

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
              Image.asset('images/Subject.png', height: 200),
              Text('انشاء حساب طالب',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF0A2F5A),
                      fontSize: 32,
                      fontWeight: FontWeight.bold)),
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
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
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
              TextFormField(
                controller: _nameController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'الاسم',
                  prefixIcon: Icon(Icons.person, color: Color(0xFF7EB347)),
                  filled: true,
                  fillColor: Color.fromARGB(24, 127, 179, 71),
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'البريد الالكتروني',
                  prefixIcon: Icon(Icons.email, color: Color(0xFF7EB347)),
                  filled: true,
                  fillColor: Color.fromARGB(24, 127, 179, 71),
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                textAlign: TextAlign.right,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'كلمة المرور',
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF7EB347)),
                  filled: true,
                  fillColor: Color.fromARGB(24, 127, 179, 71),
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'رقم الهاتف',
                  prefixIcon: Icon(Icons.phone, color: Color(0xFF7EB347)),
                  filled: true,
                  fillColor: Color.fromARGB(24, 127, 179, 71),
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
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
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
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
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  signUp();
                },
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFF0A2F5A), onPrimary: Colors.white),
                child: Text('تسجيل', style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  InputBorder _inputBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFF7EB347), width: 2.0),
      );
}
  /*old code
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
*/

