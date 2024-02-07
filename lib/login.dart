// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'school_signup.dart';
import 'student_signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'homePageStudent.dart';
//import 'homePageCoordinator.dart';
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
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // after doingthe sign up part, use .then AuthorizeAccess(context)
      //await AuthorizeAccess(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  /*AuthorizeAccess(BuildContext context) async {

    //if user is student
    FirebaseFirestore.instance
        .collection('student')
        .where('email', isEqualTo: _emailController.text.trim().toLowerCase())
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    }).catchError((error) {
      print('Error checking user existence: $error');
    });

    // if user is coordinator
    FirebaseFirestore.instance
        .collection('schoolCoordinator')
        .where('email', isEqualTo: _emailController.text.trim().toLowerCase())
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    }).catchError((error) {
      print('Error checking user existence: $error');
    });

    //if user is administrator
    FirebaseFirestore.instance
        .collection('adminitractor')
        .where('email', isEqualTo: _emailController.text.trim().toLowerCase())
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    }).catchError((error) {
      print('Error checking user existence: $error');
    });
  }*/

  Future<void> AuthorizeAccess(BuildContext context) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('student')
          .doc(_emailController.text.trim().toLowerCase())
          .get();

      if (userDoc.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return;
      }
      /*whith status validation
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('student')
          .where('email', isEqualTo: _emailController.text.trim().toLowerCase())
          .get();
          

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot userDoc = querySnapshot.docs.first;
        final accountStatus = userDoc['accountStatus'] as bool? ?? false;
        if (accountStatus) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('لم يتم توثيق حساب، نرجوا الإنتظار')));
          return;
        }
      }
*/
      // Check for coordinator
      final coordinatorDoc = await FirebaseFirestore.instance
          .collection('schoolCoordinator')
          .doc(_emailController.text.trim().toLowerCase())
          .get();

      if (coordinatorDoc.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return;
      }

      // Check for administrator
      final adminDoc = await FirebaseFirestore.instance
          .collection('adminitractor')
          .doc(_emailController.text.trim().toLowerCase())
          .get();

      if (adminDoc.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return;
      }
    } catch (error) {
      print('Error checking user existence: $error');
    }
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
