// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SchoolSignUpPage extends StatefulWidget {
  const SchoolSignUpPage({Key? key}) : super(key: key);

  @override
  _SchoolSignUpPageState createState() => _SchoolSignUpPageState();
}

class _SchoolSignUpPageState extends State<SchoolSignUpPage> {
  String? selectedSchool; // Variable to track the selected school
  List<String> schools = ['School 1', 'School 2', 'School 3'];

  // Controllers for the TextFormFields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
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
              //text can be clicked and show a popup
              GestureDetector(
                onTap: () {
                  showSchoolInfoDialog(context);
                },
                child: Text(
                  'لم أجد مدرستي؟',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF0A2F5A), // Make it look clickable
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
