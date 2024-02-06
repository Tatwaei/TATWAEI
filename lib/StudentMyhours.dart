import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class StudentMyhours extends StatefulWidget {
  @override
  _StudentMyhours createState() => _StudentMyhours();
}

class _StudentMyhours extends State<StudentMyhours> {
  List<String> items = List<String>.generate(2, (index) => 'Item $index');
  List<String> filteredItems = [];
  @override
  void initState() {
    super.initState();
    filteredItems = items;

    // _loadProfileData();
  }

  void _showCertificatePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFFf7f6d4),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('images/certificate.jpg'),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 187, 213, 159)),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the pop-up
                  },
                  child:
                      Text('اغلاق', style: TextStyle(color: Color(0xFF0A2F5A))),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                    " ساعاتي  ",
                    style: TextStyle(
                      color: Color(0xFF0A2F5A),
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
            leading: IconButton(
                iconSize: 60,
                padding: EdgeInsets.only(bottom: 6, left: 300),
                color: Color.fromARGB(115, 127, 179, 71),
                onPressed: () {},
                icon: Icon(Icons.access_time))),
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
                  padding: EdgeInsets.only(bottom: 20, left: 310),
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
              Padding(
                padding: EdgeInsets.only(left: 5, bottom: 5, top: 1),
                child: Container(
                  margin: EdgeInsets.fromLTRB(170, 1, 1, 1),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(115, 127, 179, 71),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    "الساعات التي تم اكمالها",
                    style: TextStyle(color: Color(0xFF0A2F5A), fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 5.0),
              Padding(
                padding: EdgeInsets.only(left: 5, bottom: 5, top: 1),
                child: Container(
                  color: Color(0xFFf7f6d4),
                  height: 250,
                  width: 400,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 5,
                        right: 10,
                        child: Text(
                          'عدد الساعات',
                          style: TextStyle(
                            fontSize: 12,
                            backgroundColor: Color.fromARGB(115, 127, 179, 71),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        color: Color(0xFFf7f6d4),
                        height: 200,
                        width: 400,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                color: Colors.transparent,
                                radius: 30,
                              ),
                              PieChartSectionData(
                                color: Color.fromARGB(115, 127, 179, 71),
                                value:
                                    50, // Your actual value for the outer part
                                radius: 30,
                              ),
                            ],
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: EdgeInsets.only(left: 1, bottom: 5, top: 1),
                child: Container(
                  //width: 70,
                  margin: EdgeInsets.fromLTRB(170, 1, 1, 1),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(115, 127, 179, 71),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    "فرص تطوع تم التحقق ",
                    style: TextStyle(color: Color(0xFF0A2F5A), fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 5.0),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 70.0,
                      height: 90.0,
                      margin: EdgeInsets.only(bottom: 20),
                      color: Color(0xFFf7f6d4),
                      child: ListTile(
                        title: Stack(
                          children: [
                            Positioned(
                              top: 12,
                              left: 140,
                              child: Text(
                                filteredItems[index],
                                style: TextStyle(
                                  backgroundColor:
                                      Color.fromARGB(115, 127, 179, 71),
                                ),
                              ),
                            ),
                            Positioned(
                              child: Stack(
                                children: [
                                  // Other positioned widgets or elements in the stack...

                                  Positioned(
                                    top: 30,
                                    left: 5,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        _showCertificatePopup(
                                            context); // Handle button press
                                      },
                                      icon: IconTheme(
                                        data: IconThemeData(
                                            size: 10,
                                            color: Color(
                                                0xFF0A2F5A)), // Set your desired icon size
                                        child:
                                            Icon(Icons.remove_red_eye_rounded),
                                      ),
                                      label: Text(
                                        'عرض الشهاده',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0A2F5A),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 187, 213, 159),
                                        fixedSize: Size(90, 1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: Container(
                                width: 70.0,
                                height: 70.0,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage('images/logo1.png'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //onTap: () {},
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
