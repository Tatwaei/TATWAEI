import 'package:flutter/material.dart';
import 'dart:math';

class coorAdd extends StatefulWidget {
  @override
  _coorAddState createState() => _coorAddState();
}

class _coorAddState extends State<coorAdd> {
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
      body: Expanded(
        child: SingleChildScrollView(
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
                // Replace these with your desired text and box fields
                buildRow(" الفرصة التطوعية"),
                buildRow("تفاصيل الفرصة التطوعية"),
                buildDoubleRow("  تاريخ النهاية", "تاريخ البداية  "),
                 buildRow(" المقاعد "),
                  buildRow(" المجال التطوعي "),
                buildRow(" الجنس "),
                buildRow("الفوائد المكتسبه من الفرصة التطوعية "),
                buildRow("صوره "),
              ],
            ),
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
                // Add onPressed logic for the first button
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
              onPressed: () {
                // Add onPressed logic for the second button
              },
              child: Text(
                "تعديل",
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

  Widget buildRow(String labelText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(),
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                // Add onPressed logic for editing
              },
              child: Text(
                labelText,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF0A2F5A),
                ),
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
                child: Text(
                  "Field Value", // Replace with your field value
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildDoubleRow(String leftLabelText, String rightLabelText) {
    return Row(
      children: [
        Expanded(
          child: buildRow(leftLabelText),
        ),
        SizedBox(width: 20),
        Expanded(
          child: buildRow(rightLabelText),
        ),
      ],
    );
  }
}

