// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'school_signup.dart';
import 'student_signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homePageStudent.dart';
import 'homePageCoordinator.dart';
import 'homePageAdmin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || !email.contains('@') || !email.contains('.com')) {
      // Display a SnackBar for invalid email
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email address.')),
      );
      return; // Stop the sign-in process
    }

    if (password.isEmpty || password.length < 6) {
      // Display a SnackBar for invalid password
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password must be at least 6 characters.')),
      );
      return; // Stop the sign-in process
    }

    // Proceed with Firebase sign-in if inputs are valid
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // after doingthe sign up part, use .then AuthorizeAccess(context)
      await AuthorizeAccess(context);
      /*Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );*/
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  Future<void> AuthorizeAccess(BuildContext context) async {
    // Query the 'student' collection for a document with a matching email
    var querySnapshot = await FirebaseFirestore.instance
        .collection('student')
        .where('email', isEqualTo: _emailController.text.trim())
        .get();

    // Check if any documents were found
    if (querySnapshot.docs.isNotEmpty) {
      String collectionId = querySnapshot.docs.first.reference.id;
      Provider.of<UserState>(context, listen: false).setUserId(collectionId);
      var userDoc = querySnapshot.docs.first;
      bool accountStatus = userDoc['accountStatus'] ?? false;
      if (accountStatus) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePageStudent()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("لم يتم توثيق حساب، نرجوا الإنتظار")));
      }
      return;
    }

    // Attempt to find the user in the 'schoolCoordinator' collection
    var userDoc = await FirebaseFirestore.instance
        .collection('schoolCoordinator')
        .doc(_emailController.text.trim())
        .get();

    if (userDoc.exists) {
      var collectionId = userDoc.id;
      Provider.of<UserState>(context, listen: false).setUserId(collectionId);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => homePageCoordinator()));
      return;
    }

    // Attempt to find the user in the 'admin' collection
    userDoc = await FirebaseFirestore.instance
        .collection('admin')
        .doc(_emailController.text.trim())
        .get();

    if (userDoc.exists) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => homePageAdmin()));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not found or not authorized.")));
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFCEC),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Text(
                'مرحبا بك في ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0A2F5A),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'تطوعي',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0A2F5A),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset(
                'images/Subject.png',
                height: 200,
              ),
              Text(
                'سجل دخولك',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0A2F5A),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              // Email TextField
              TextFormField(
                //autovalidateMode: AutovalidateMode.onUserInteraction,
                //validator: validationUser,
                controller: _emailController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'البريد الإلكتروني',
                  prefixIcon: Icon(Icons.email,
                      color: Color(0xFF7EB347)), // Icon color is set here
                  filled: true, //fill the background color
                  fillColor: Color.fromARGB(
                      24, 127, 179, 71), // Background color is set here
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Color.fromARGB(40, 127, 179, 71), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color(0xFF7EB347), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color(0xFF7EB347), width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Password TextField
              TextFormField(
                controller: _passwordController,
                textAlign: TextAlign.right,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'كلمة المرور',

                  prefixIcon: Icon(Icons.lock,
                      color: Color(0xFF7EB347)), // Sets the icon color
                  filled: true, // Enables background color filling
                  fillColor: Color.fromARGB(24, 127, 179,
                      71), // Sets the background color of the TextFormField
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color(0xFF7EB347), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color(0xFF7EB347), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color(0xFF7EB347), width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Login Button
              ElevatedButton(
                onPressed: () {
                  signIn();
                },
                style: ElevatedButton.styleFrom(
                  primary:
                      Color(0xFF0A2F5A), // Replace with the actual button color
                ),
                child: Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Division with "أو"
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      color: Color(0xFFD3CA25),
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'أو',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFD3CA25),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color(0xFFD3CA25),
                      thickness: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Student Sign Up Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudentSignUpPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary:
                      Color(0xFF0A2F5A), // Replace with the actual button color
                ),
                child: Text(
                  'انشاء حساب طالب',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              // School Coordinator Sign Up Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SchoolSignUpPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary:
                      Color(0xFF0A2F5A), // Replace with the actual button color
                ),
                child: Text(
                  'انشاء حساب مدرسة',
                  style: TextStyle(
                    color: Colors.white,
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
}
