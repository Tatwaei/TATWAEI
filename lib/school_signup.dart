// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tatwaei/login.dart';

class SchoolSignUpPage extends StatefulWidget {
  const SchoolSignUpPage({Key? key}) : super(key: key);

  @override
  _SchoolSignUpPageState createState() => _SchoolSignUpPageState();
}

class _SchoolSignUpPageState extends State<SchoolSignUpPage> {
  String? selectedSchool;
  List<String> schools = [];

  final CollectionReference schoolCollection =
      FirebaseFirestore.instance.collection('schoolWithNoAccount');

  void initState() {
    super.initState();
    fetchSchools();
  }

  void fetchSchools() async {
    final QuerySnapshot snapshot = await schoolCollection.get();
    final List<String> fetchedSchools =
        snapshot.docs.map((doc) => doc['name'].toString()).toList();
    setState(() {
      schools = fetchedSchools;
    });
  }

  // Controllers for the TextFormFields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  Future<void> signUp() async {
    try {
      // Step 1: Create a new school document in 'school' collection
      final schoolId = await createSchoolDocument();

      // Step 2: Create a new schoolCoordinator document
      await createCoordinatorDocument(schoolId);

      // Step 3: Sign up the user using FirebaseAuth
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Step 4: Navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error signing up: $e');
    }
  }

  Future<String> createSchoolDocument() async {
    try {
      print(_phoneController.text.trim());
      print(_addressController.text.trim());
      // Create a new document in 'school' collection
      final DocumentReference schoolDocRef =
          await FirebaseFirestore.instance.collection('school').add({
        'address': _addressController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'schoolName': selectedSchool,
      });

      // Get the selected schoolWithNoAccount document reference
      final QuerySnapshot selectedSchoolSnapshot = await FirebaseFirestore
          .instance
          .collection('schoolWithNoAccount')
          .where('name', isEqualTo: selectedSchool)
          .get();

      // Delete the selected school document from 'schoolWithNoAccount' collection
      if (selectedSchoolSnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('schoolWithNoAccount')
            .doc(selectedSchoolSnapshot.docs.first.id)
            .delete();
      }

      return schoolDocRef.id;
    } catch (e) {
      print('Error creating school document: $e');
      return '';
    }
  }

  Future<void> createCoordinatorDocument(String schoolId) async {
    try {
      // Create a new document in 'schoolCoordinator' collection
      await FirebaseFirestore.instance
          .collection('schoolCoordinator')
          .doc(_emailController.text.trim().toLowerCase())
          .set({
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'schoolId': schoolId,
      });
    } catch (e) {
      print('Error creating coordinator document: $e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void showSchoolInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              'لم تجد مدرستك؟',
              style: TextStyle(
                color: Color(0xFF0A2F5A),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'نرجوا التواصل معنا على ContactTatwaei@gmail.com',
              style: TextStyle(
                color: Color(0xFF0A2F5A),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'الغاء',
                  style: TextStyle(
                    color: Color(0xFF0A2F5A),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
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
              Image.asset(
                'images/Subject.png',
                height: 200,
              ),
              Text(
                'انشاء حساب مدرسة',
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
              GestureDetector(
                onTap: () {
                  showSchoolInfoDialog(context);
                },
                child: Text(
                  'لم أجد مدرستي؟',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF0A2F5A),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Email TextFormField
              TextFormField(
                controller: _emailController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'البريد الالكتروني',
                  prefixIcon: Icon(Icons.email, color: Color(0xFF7EB347)),
                  filled: true,
                  fillColor: Color.fromARGB(24, 127, 179, 71),
                  border: _inputBorder(),
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              // Password TextFormField
              TextFormField(
                controller: _passwordController,
                textAlign: TextAlign.right,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'كلمة المرور',
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF7EB347)),
                  filled: true,
                  fillColor: Color.fromARGB(24, 127, 179, 71),
                  border: _inputBorder(),
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Phone TextFormField
              TextFormField(
                controller: _phoneController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'رقم الهاتف',
                  prefixIcon: Icon(Icons.phone, color: Color(0xFF7EB347)),
                  filled: true,
                  fillColor: Color.fromARGB(24, 127, 179, 71),
                  border: _inputBorder(),
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              // Address TextFormField
              TextFormField(
                controller: _addressController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'عنوان المدرسة',
                  prefixIcon: Icon(Icons.location_on, color: Color(0xFF7EB347)),
                  filled: true,
                  fillColor: Color.fromARGB(24, 127, 179, 71),
                  border: _inputBorder(),
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  signUp();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF0A2F5A),
                  onPrimary: Colors.white,
                ),
                child: Text(
                  'تسجيل',
                  style: TextStyle(fontSize: 18),
                ),
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


//old code, refactored  buildTextField method into TextFormField
/*
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
                'انشاء حساب مدرسة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0A2F5A),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Dropdown for selecting schools name
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
              //text can be clicked and show a popup
              GestureDetector(
                onTap: () {
                  showSchoolInfoDialog(context);
                },
                child: Text(
                  'لم أجد مدرستي؟',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF0A2F5A),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 16),
              buildTextField(
                controller: _emailController,
                hintText: 'البريد الالكتروني',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              buildTextField(
                controller: _passwordController,
                hintText: 'كلمة المرور',
                icon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(height: 16),
              buildTextField(
                controller: _phoneController,
                hintText: 'رقم الهاتف',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              buildTextField(
                controller: _addressController,
                hintText: 'عنوان المدرسة',
                icon: Icons.location_on,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  //school sign-up logic
                  signUp();
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
    required TextEditingController controller,
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
