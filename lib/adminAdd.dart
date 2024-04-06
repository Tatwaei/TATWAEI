

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tatwaei/homePageAdmin.dart';

class adminAdd extends StatefulWidget {
  @override
  _adminAddState createState() => _adminAddState();
}

class _adminAddState extends State<adminAdd> {
  // Define controllers for text editing
  TextEditingController _opportunityController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  TextEditingController _seatsController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _hoursController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  String? _selectedGender;
  String? _selectedInterest;

  List<String> genderOptions = ['ذكر', 'انثى', 'كلاهما'];
  List<String> interestOptions = ['ادارية', 'خدمية', 'صحية', 'اجتماعية', 'اخرى'];

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
                  'إضافة فرصة ',
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
            icon: Icon(Icons.handshake_rounded),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
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
              buildRow(" الفرصة التطوعية", _opportunityController),
              buildRow("تفاصيل الفرصة التطوعية", _detailsController),
              buildDateRow("تاريخ البداية", _startDate, () {
                _selectStartDate(context);
              }),
              buildDateRow("تاريخ النهاية", _endDate, () {
                _selectEndDate(context);
              }),
              buildDoubleRow(
                " الجنس ",
                buildDropdownButton(
                  genderOptions,
                  _selectedGender,
                  (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                ),
                " المقاعد ",
                buildTextField(_seatsController),
              ),
              buildDoubleRow(
                "مكان التطوع  ",
                buildTextField(_placeController),
                " المجال التطوعي ",
                buildDropdownButton(
                  interestOptions,
                  _selectedInterest,
                  (String? newValue) {
                    setState(() {
                      _selectedInterest = newValue;
                    });
                  },
                ),
              ),
              buildRow("الموقع ", _locationController),
              buildRow("عدد ساعات ", _hoursController),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
       
      floatingActionButton: Stack(
  children: [
    Positioned(
      bottom: 16.0,
      left: 30.0, // Adjusted left position for the first button
      child: FloatingActionButton(
        onPressed: () {
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
                  "تم إلغاء الإضافة بنجاح",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF0A2F5A),
                  ),
                ),
              );
            },
          );
        },
        child: Text(
          "إلغاء",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(115, 127, 179, 71),
        elevation: 0,
      ),
    ),
    Positioned(
      bottom: 16.0,
      right: 10.0, // Adjusted right position for the second button
      child: FloatingActionButton(
        onPressed: () {
          if (_opportunityController.text.isNotEmpty &&
              _detailsController.text.isNotEmpty &&
              _startDate != null &&
              _endDate != null &&
              _seatsController.text.isNotEmpty &&
              _selectedGender != null &&
              _selectedInterest != null &&
              _locationController.text.isNotEmpty &&
              _hoursController.text.isNotEmpty) {
            Timestamp startDateTimestamp = Timestamp.fromDate(_startDate!);
            Timestamp endDateTimestamp = Timestamp.fromDate(_endDate!);

            Map<String, dynamic> opportunityData = {
              'name': _opportunityController.text,
              'description': _detailsController.text,
              'startDate': startDateTimestamp,
              'endDate': endDateTimestamp,
              'numOfSeats': int.parse(_seatsController.text),
              'gender': _selectedGender,
              'interest': _selectedInterest,
              'opportunityProvider': _placeController.text,
              'location': _locationController.text,
              'numOfHours': int.parse(_hoursController.text),
              'a_email': 'ContactTatwaei@gmail.com', // Administrator's email
            };

            FirebaseFirestore.instance.collection('externalOpportunity').add(opportunityData).then((_) {
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
                      "تمت إضافة الفرصة بنجاح",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF0A2F5A),
                      ),
                    ),
                  );
                },
              );
            }).catchError((error) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ),
                    content: Text(
                      "حدث خطأ أثناء إضافة الفرصة. يرجى المحاولة مرة أخرى.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF0A2F5A),
                      ),
                    ),
                  );
                },
              );
            });
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Icon(
                    Icons.warning,
                    color: Colors.orange,
                    size: 50,
                  ),
                  content: Text(
                    "يرجى ملء جميع الحقول المطلوبة",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF0A2F5A),
                    ),
                  ),
                );
              },
            );
          }
        },
        child: Text(
          "إضافة",
          style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        ),
        backgroundColor: Color.fromARGB(115, 127, 179, 71),
        elevation: 0,
      ),
    ),
  ],
),
floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

     
    );
  }

  Widget buildTextField(TextEditingController controller) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFFf7f6d4),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildRow(String labelText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              labelText,
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
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Add onPressed logic for editing
                  },
                  child: Icon(
                    Icons.edit,
                    color: Color(0xFFa7cc7f),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildDoubleRow(String leftLabelText, Widget leftWidget, String rightLabelText, Widget rightWidget) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    leftLabelText,
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
              leftWidget,
            ],
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    rightLabelText,
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
              rightWidget,
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDropdownButton(List<String> options, String? selectedValue, Function(String?) onChanged) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFFf7f6d4),
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.black),
        underline: Container(
          height: 2,
          color: Colors.grey,
        ),
        onChanged: onChanged,
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(value),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildDateRow(String labelText, DateTime? date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                labelText,
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
                Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    child: Icon(
                      Icons.calendar_today,
                      color: Color(0xFFa7cc7f),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    date != null ? "${date.day}/${date.month}/${date.year}" : "اختر تاريخ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: date != null ? Color(0xFF0A2F5A) : Color(0xFFa7cc7f),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime?
 picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color.fromARGB(115, 127, 179, 71), // Head background color
              onPrimary: Colors.white, // Head text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Color(0xFF0A2F5A), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color.fromARGB(115, 127, 179, 71), // Head background color
              onPrimary: Colors.white, // Head text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Color(0xFF0A2F5A), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }
}
