import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'user_state.dart';
import 'dart:math';

class studentAccount extends StatefulWidget {
  @override
  _studentAccount createState() => _studentAccount();
}

class _studentAccount extends State<studentAccount> {
  bool changesMade() {
    return modifiedName != initialName ||
        int.tryParse(modifiedClass) != initialClass ||
        modifiedPhone != initialPhoneNumber ||
        modifiedEmail != initialEmail ||
        modifiedPass != initialPass;
  }

  late String initialName = '';
  late int initialClass = 0;
  late String initialSchool = "";
  late String initialPhoneNumber = '';
  late String initialEmail = '';
  late String initialPass = '';

  late TextEditingController _nameController;
  late TextEditingController _classController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _passController;

  late TextEditingController _nameCheckController =
      TextEditingController(text: modifiedName);
  late TextEditingController _classCheckController =
      TextEditingController(text: modifiedClass);
  late TextEditingController _emailCheckController =
      TextEditingController(text: modifiedEmail);
  late TextEditingController _phonenCheckController =
      TextEditingController(text: modifiedPhone);
  late TextEditingController _PassCheckController =
      TextEditingController(text: modifiedPass);

  String? validateName(String? formName) {
    final validCharacters = RegExp(r'[!@#<>?":_`~;[\]\/|=+)(*&^%0-9-]');

    if (formName == null || formName.trim().isEmpty) {
      return "يرجى إدخال اسم";
    } else if ((validCharacters.hasMatch(formName))) {
      return 'يجب أن يحتوي الاسم على حروف فقط';
    } else if (formName != null && formName.length < 2) {
      return 'يجب أن يحتوى الاسم على حرفين على الأقل';
    } else
      return null;
  }

  String? validateClass(String? formClass) {
    final validCharacters = RegExp(r'[!@#<>?":_`~;[\]\/|=+)(*&^%a-zA-Z]');

    if (formClass == null || formClass.trim().isEmpty) {
      return "يرجى إدخال الصف الدراسي";
    } else if ((validCharacters.hasMatch(formClass))) {
      return 'يجب أن يحتوي الصف على ارقام فقط';
    } else if ( formClass.length < 2 || formClass.length > 2) {
      return 'يجب أن يحتوى على رقمين فقط ';
    } else
      return null;
  }

  String? validatePhone(String? formPhone) {
    RegExp regex =
        RegExp(r'^(00966|966|\+966|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{8})$');

    if (formPhone == null || formPhone.trim().isEmpty) {
      return "يرجى إدخال رقم هاتف";
    } else if (formPhone.length < 10) {
      return "يجب أن يحتوي الرقم على 10 خانات";
    }
    return null;
  }

  String? validateEmail(String? formEmail) {
    if (formEmail == null || formEmail.trim().isEmpty) {
      return "يرجى إدخال بريد إلكتروني";
    }
    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formEmail)) return 'يرج إدخال عنوان بريد صحيح';
    return null;
  }

  String? validatePass(String? formPass) {
    if (formPass == null || formPass.trim().isEmpty) {
      return "يرجى إدخال كلمة مرور";
    } else if (formPass.length < 6) {
      return "  يجب أن يحتوي الرقم على 6 خانات على الاقل";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: initialName);
    _classController = TextEditingController(text: initialClass.toString());
    _phoneNumberController =
        TextEditingController(text: initialPhoneNumber.toString());
    _emailController = TextEditingController(text: initialEmail);
    _passController = TextEditingController(text: initialPass);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserData();
    });
  }

  Future<void> getUserData() async {
    String userId = Provider.of<UserState>(context, listen: false).userId;
    DocumentSnapshot<Map<String, dynamic>> userDocument =
        await FirebaseFirestore.instance
            .collection('student')
            .doc(userId)
            .get();
    if (userDocument.exists) {
      setState(() {
        // Update your state with the retrieved data
        initialName = userDocument.get('name');
        initialClass = int.tryParse(userDocument.get('grade').toString()) ?? 0;
        initialPhoneNumber = userDocument.get('phoneNumber').toString();
        initialEmail = userDocument.get('email');
        initialPass = userDocument.get('password');

        String schoolId = userDocument.get('schoolId');
        getSchoolData(schoolId);
      });
    }
  }

  Future<void> getSchoolData(String schoolId) async {
    DocumentSnapshot<Map<String, dynamic>> schoolDocument =
        await FirebaseFirestore.instance
            .collection('school')
            .doc(schoolId)
            .get();

    if (schoolDocument.exists) {
      setState(() {
        // Update your state with the retrieved data
        initialSchool = schoolDocument.get('schoolName');
      });
    }
  }

  bool showNameForm = false;
  bool showClassForm = false;
  bool showPhoneNumberForm = false;
  bool showEmailForm = false;
  bool showPassForm = false;

  String modifiedName = "";
  String modifiedClass = "";
  String modifiedPhone = "";
  String modifiedEmail = "";
  String modifiedPass = "";

  @override
  void dispose() {
    _nameController.dispose();
    _classController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void updateName(String value) {
    setState(() {
      modifiedName = value.isNotEmpty ? value : initialName;
    });
  }

  void updateClass(String value) {
    setState(() {
      modifiedClass = value.isNotEmpty ? value : initialClass.toString();
    });
  }

  void updatePhone(String value) {
    setState(() {
      modifiedPhone = value.isNotEmpty ? value : initialPhoneNumber;
    });
  }

  void updateEmail(String value) {
    setState(() {
      modifiedEmail = value.isNotEmpty ? value : initialEmail;
    });
  }

  void updatePass(String value) {
    setState(() {
      modifiedPass = value.isNotEmpty ? value : initialPass;
    });
  }

  Future<void> saveUserData() async {
    String userId = Provider.of<UserState>(context, listen: false).userId;
    try {
      Map<String, dynamic> updatedData = {};

      if (modifiedName.isNotEmpty && modifiedName != initialName) {
        updatedData['name'] = modifiedName;
      }

      if (modifiedClass.isNotEmpty &&
          modifiedClass != initialClass.toString()) {
        updatedData['grade'] = modifiedClass;
        int? modifiedClassInt = int.tryParse(modifiedClass);
        if (modifiedClassInt != null) {
          initialClass = modifiedClassInt;
        }
      }

      if (modifiedPhone.isNotEmpty && modifiedPhone != initialPhoneNumber) {
        updatedData['phoneNumber'] = modifiedPhone;
      }

      if (modifiedEmail.isNotEmpty && modifiedEmail != initialEmail) {
        updatedData['email'] = modifiedEmail;
      }

      if (modifiedPass.isNotEmpty && modifiedPass != initialPass) {
        updatedData['password'] = modifiedPass;
      }

      if (updatedData.isNotEmpty) {
        // Update the state with the modified values before sending to the database
        setState(() {
          modifiedName = initialName;
          modifiedClass = initialClass.toString();
          modifiedPhone = initialPhoneNumber;
          modifiedEmail = initialEmail;
          modifiedPass = initialPass;
        });

        // Handle the error if necessary

        // Send the modified data to the database
        await FirebaseFirestore.instance
            .collection('student')
            .doc(userId)
            .update(updatedData);
        print('User data saved successfully');
      } else {
        print('No changes to save');
      }
    } catch (e) {
      print('Error saving user data: $e');
      // Handle the error if necessary
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
                    'حسابي ',
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
                icon: Icon(Icons.person))),
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
              SizedBox(height: 20.0),
              Expanded(
                child: Column(children: <Widget>[
                  //NAME
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "الاسم",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF0A2F5A),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFf7f6d4),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showNameForm = !showNameForm;
                                  if (showNameForm) {
                                    _nameController.text = modifiedName;
                                  }
                                });
                              },
                              child: Icon(
                                Icons.edit,
                                color: Color(0xFFa7cc7f),
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Visibility(
                                visible: showNameForm,
                                child: TextFormField(
                                  textAlign: TextAlign.right,
                                  controller: _nameController,
                                  onChanged: updateName,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: validateName,
                                  decoration: InputDecoration(
                                    labelText: 'الرجاء ادخال الاسم',
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !showNameForm,
                              child: Expanded(
                                child: Padding(
                                  padding: EdgeInsets.zero,
                                  child: Text(
                                    modifiedName.isNotEmpty
                                        ? modifiedName
                                        : initialName,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),

                  //EMAIL
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "الصف الدراسي",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF0A2F5A),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFf7f6d4),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showClassForm = !showClassForm;
                                  if (showClassForm) {
                                    _classController.text = modifiedClass;
                                  }
                                });
                              },
                              child: Icon(
                                Icons.edit,
                                color: Color(0xFFa7cc7f),
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Visibility(
                                visible: showClassForm,
                                child: TextFormField(
                                  textAlign: TextAlign.right,
                                  controller: _classController,
                                  onChanged: updateClass,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: validateClass,
                                  decoration: InputDecoration(
                                    labelText: 'الرجاء ادخال الصف الدراسي',
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !showClassForm,
                              child: Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 110),
                                  child: Text(
                                    modifiedClass.isNotEmpty
                                        ? modifiedClass
                                        : initialClass.toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                  //PHONE NUMBER
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "اسم المدرسة",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF0A2F5A),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFf7f6d4),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  initialSchool,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "رقم الجوال",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF0A2F5A),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xFFf7f6d4),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showPhoneNumberForm =
                                          !showPhoneNumberForm;
                                      if (showPhoneNumberForm) {
                                        _phoneNumberController.text =
                                            modifiedPhone;
                                      }
                                    });
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Color(0xFFa7cc7f),
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Visibility(
                                    visible: showPhoneNumberForm,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      maxLength: 10,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: ("05********"),
                                      ),
                                      controller: _phoneNumberController,
                                      onChanged: updatePhone,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: validatePhone,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !showPhoneNumberForm,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, right: 10),
                                    child: Text(
                                      modifiedPhone.isNotEmpty
                                          ? modifiedPhone
                                          : initialPhoneNumber.toString(),
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "البريد الالكتروني",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF0A2F5A),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color(0xFFf7f6d4),
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showEmailForm = !showEmailForm;
                                          if (showEmailForm) {
                                            _emailController.text =
                                                modifiedEmail;
                                          }
                                        });
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Color(0xFFa7cc7f),
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    Expanded(
                                      child: Visibility(
                                        visible: showEmailForm,
                                        child: TextFormField(
                                          textAlign: TextAlign.left,
                                          controller: _emailController,
                                          onChanged: updateEmail,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: validateEmail,
                                          decoration: InputDecoration(
                                            labelText:
                                                'الرجاء ادخال البريد الالكتروني',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !showEmailForm,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 10),
                                        child: Text(
                                          modifiedEmail.isNotEmpty
                                              ? modifiedEmail
                                              : initialEmail,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "كلمة المرور",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF0A2F5A),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color(0xFFf7f6d4),
                                    ),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showPassForm = !showPassForm;
                                              if (showPassForm) {
                                                _passController.text =
                                                    modifiedPass;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Color(0xFFa7cc7f),
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                          child: Visibility(
                                            visible: showPassForm,
                                            child: TextFormField(
                                              textAlign: TextAlign.left,
                                              controller: _passController,
                                              onChanged: updatePass,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: validatePass,
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'الرجاء ادخال كلمة المرور',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: !showPassForm,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 8.0, right: 10),
                                            child: Text(
                                              '*' *
                                                  (modifiedPass.isNotEmpty
                                                      ? modifiedPass.length
                                                      : initialPass.length),
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    padding: EdgeInsets.only(left: 110),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (changesMade()) {
                                          try {
                                            await saveUserData();
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 50,
                                                  ),
                                                  content: Text(
                                                    "تم حفظ المعلومات بنجاح",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Color(0xFF0A2F5A),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          } catch (error) {
                                            print(
                                                'Error saving user data: $error');
                                          }
                                        }
                                      },
                                      child: Text(
                                        "حفظ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFF0A2F5A)),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xFFb4d392)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
