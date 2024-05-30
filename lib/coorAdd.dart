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
        child: Column(
          children: [
            Container(
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
                  buildDropdownRow(" الجنس ", _selectedGender, _updateSelectedGender, ["ذكر", "انثى", "كلاهما"]),
                  buildDropdownRow(" المجال التطوعي ", _selectedInterest, _updateSelectedInterest, ["ادارية", "خدمية", "صحية", "اجتماعية", "اخرى"]),
                  buildRow(" المقاعد ", _seatsController),
                  buildRow("عدد ساعات ", _hoursController),
                         ],
              ),
            ),
               
                Container(
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                        child: ElevatedButton(
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
                  
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                              onPressed: () async {
                                await addOpportunity();
                              },
                              child: Text(
                                "إضافة",
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
                ),
          ],
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
              primary: Color.fromARGB(115, 127, 179, 71), //  background color
              onPrimary: Colors.white, //  text color
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




