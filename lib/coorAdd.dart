import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class coorAdd extends StatefulWidget {
  @override
  _coorAddState createState() => _coorAddState();
}

class _coorAddState extends State<coorAdd> {
  TextEditingController _opportunityController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedGender;
  String? _selectedInterest;
  TextEditingController _seatsController = TextEditingController();
  TextEditingController _hoursController = TextEditingController();

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
                  'إضافة فرصه ',
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
              buildDropdownRow(" الجنس ", _selectedGender, _updateSelectedGender, ["ذكر", "أنثى", "كلاهما"]),
              buildDropdownRow(" المجال التطوعي ", _selectedInterest, _updateSelectedInterest, ["ادارية", "خدمية", "صحية", "اجتماعية", "اخرى"]),
              buildRow(" المقاعد ", _seatsController),
              buildRow("عدد ساعات ", _hoursController),
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
      right: 20.0, // Adjusted right position for the second button
      child: FloatingActionButton(
        onPressed: () async {
          await addOpportunity();
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

      /*floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16.0,
            left: 16.0,
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
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () async {
                await addOpportunity();
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,*/
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
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildDropdownRow(String labelText, String? selectedValue, Function(String?) onChanged, List<String> dropdownItems) {
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
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            onChanged: onChanged,
            items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 20),
      ],
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
    final DateTime? picked = await showDatePicker(
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

  void _updateSelectedGender(String? value) {
    setState(() {
      _selectedGender = value;
    });
  }

  void _updateSelectedInterest(String? value) {
    setState(() {
      _selectedInterest = value;
    });
  }

  Future<void> addOpportunity() async {
    if (_opportunityController.text.isNotEmpty &&
        _detailsController.text.isNotEmpty &&
        _startDate != null &&
        _endDate != null &&
        _seatsController.text.isNotEmpty &&
        _selectedGender != null &&
        _selectedInterest != null &&
        _hoursController.text.isNotEmpty) {
      String opportunityId = FirebaseFirestore.instance.collection('internalOpportunity').doc().id;

      Timestamp startDateTimestamp = Timestamp.fromDate(_startDate!);
      Timestamp endDateTimestamp = Timestamp.fromDate(_endDate!);

      String? coordinatorEmail = FirebaseAuth.instance.currentUser?.email;

      Map<String, dynamic> opportunityData = {
        'opportunityId': opportunityId,
        'name': _opportunityController.text,
        'description': _detailsController.text,
        'startDate': startDateTimestamp,
        'endDate': endDateTimestamp,
        'numOfSeats': int.parse(_seatsController.text),
        'gender': _selectedGender,
        'interest': _selectedInterest,
        'numOfHours': int.parse(_hoursController.text),
        'coordinator_email': coordinatorEmail,
      };

      await FirebaseFirestore.instance.collection('internalOpportunity').doc(opportunityId).set(opportunityData);
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
              "تمت الإضافة بنجاح",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF0A2F5A),
              ),
            ),
          );
        },
      );
    } else {
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
              "الرجاء تعبئة جميع الحقول.",
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
  }
}

/*import 'package:flutter/material.dart';
import 'dart:math';
import 'package:tatwaei/homePageAdmin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tatwaei/homePageCoordinator.dart'; // Import FirebaseAuth

class coorAdd extends StatefulWidget {
  @override
  _coorAddState createState() => _coorAddState();
}

class _coorAddState extends State<coorAdd> {
  TextEditingController _opportunityController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedGender;
  String? _selectedInterest;
  TextEditingController _seatsController = TextEditingController();
  TextEditingController _benefitsController = TextEditingController();
  TextEditingController _hoursController = TextEditingController();

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
                  'إضافة فرصه ',
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
              buildDropdownRow(" الجنس ", _selectedGender, _updateSelectedGender, ["ذكر", "أنثى", "كلاهما"]),
              buildDropdownRow(" المجال التطوعي ", _selectedInterest, _updateSelectedInterest, ["ادارية", "خدمية", "صحية", "اجتماعية", "اخرى"]),
              buildRow(" المقاعد ", _seatsController),
              buildRow("عدد ساعات ", _hoursController),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16.0,
            left: 16.0,
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
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () async {
                // Your logic for adding the opportunity goes here
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
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildDropdownRow(String labelText, String? selectedValue, Function(String?) onChanged, List<String> dropdownItems) {
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
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            onChanged: onChanged,
            items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 20),
      ],
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
    final DateTime? picked = await showDatePicker(
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

  void _updateSelectedGender(String? value) {
    setState(() {
      _selectedGender = value;
    });
  }

  void _updateSelectedInterest(String? value) {
    setState(() {
      _selectedInterest = value;
    });
  }
}*/

/*import 'package:flutter/material.dart';
import 'dart:math';
import 'package:tatwaei/homePageAdmin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tatwaei/homePageCoordinator.dart'; // Import FirebaseAuth

class coorAdd extends StatefulWidget {
  @override
  _coorAddState createState() => _coorAddState();
}

class _coorAddState extends State<coorAdd> {
  // Define controllers for text editing
  TextEditingController _opportunityController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _seatsController = TextEditingController();
  //TextEditingController _locationController = TextEditingController();
  TextEditingController _benefitsController = TextEditingController();
  TextEditingController _hoursController = TextEditingController();
  //TextEditingController _placeController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

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
                  'إضافة فرصه ',
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
              //buildDoubleRow(" الجنس ", _genderController, " المقاعد ", _seatsController),
              //buildDoubleRow( " المجال التطوعي ", _benefitsController),
              //buildRow("الموقع ", _locationController),
               buildRow("  المقاعد ", _seatsController),
                buildRow("  الجنس ", _genderController),
                buildRow(" المجال التطوعي ", _benefitsController),
              buildRow("عدد ساعات ", _hoursController),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16.0,
            left: 16.0,
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
                // After 5 seconds, navigate to HomePageAdmin
               /* Future.delayed(Duration(seconds: 5), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => homePageCoordinator()),
                  );
                });*/
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
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () async {
                // Check if all fields are filled
                if (_opportunityController.text.isNotEmpty &&
                    _detailsController.text.isNotEmpty &&
                    _startDate != null &&
                    _endDate != null &&
                    _seatsController.text.isNotEmpty &&
                    _genderController.text.isNotEmpty &&
                    _benefitsController.text.isNotEmpty &&
                   // _locationController.text.isNotEmpty &&
                    _hoursController.text.isNotEmpty) {
                  // Generate opportunity ID
                  String opportunityId = FirebaseFirestore.instance.collection('internalOpportunity').doc().id;

                  // Convert dates to Timestamp
                  Timestamp startDateTimestamp = Timestamp.fromDate(_startDate!);
                  Timestamp endDateTimestamp = Timestamp.fromDate(_endDate!);

                  // Get current user's email from Firebase Authentication
                  String? coordinatorEmail = FirebaseAuth.instance.currentUser?.email;

                  // Create internal opportunity data
                  Map<String, dynamic> opportunityData = {
                    'opportunityId': opportunityId,
                    'name': _opportunityController.text,
                    'description': _detailsController.text,
                    'startDate': startDateTimestamp,
                    'endDate': endDateTimestamp,
                    'numOfSeats': int.parse(_seatsController.text),
                    'gender': _genderController.text,
                    'interest': _benefitsController.text,
                    //'opportunityProvider': _placeController.text,
                    //'location': _locationController.text,
                    'numOfHours': int.parse(_hoursController.text),
                    'coordinator_email': coordinatorEmail, // Coordinator's email
                  };

                  // Add the internal opportunity to Firestore
                  FirebaseFirestore.instance.collection('internalOpportunity').doc(opportunityId).set(opportunityData).then((value) {
                    // Show success message
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
                            "تمت الإضافة بنجاح",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF0A2F5A),
                            ),
                          ),
                        );
                      },
                    );
                    // After 5 seconds, navigate to HomePageAdmin
                   /* Future.delayed(Duration(seconds: 5), () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => homePageCoordinator()),
                      );
                    });*/
                  }).catchError((error) {
                    // Show error message if something goes wrong
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
                            "حدث خطأ أثناء إضافة الفرصة التطوعية. الرجاء المحاولة مرة أخرى.",
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
                  // Show error message if any field is empty
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
                          "الرجاء تعبئة جميع الحقول.",
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
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildDoubleRow(String leftLabelText, TextEditingController leftController, String rightLabelText, TextEditingController rightController) {
    return Row(
      children: [
        Expanded(
          child: buildRow(leftLabelText, leftController),
        ),
        SizedBox(width: 20),
        Expanded(
          child: buildRow(rightLabelText, rightController),
        ),
      ],
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
    final DateTime? picked = await showDatePicker(
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
}*/

