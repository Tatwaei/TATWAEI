import 'package:flutter/material.dart';
import 'dart:math';

class CordinatorMyStudent extends StatefulWidget {
  @override
  _CordinatorMyStudent createState() => _CordinatorMyStudent();
}

class _CordinatorMyStudent extends State<CordinatorMyStudent> {
  List<String> items = List<String>.generate(100, (index) => 'Item $index');
  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = items;

    // _loadProfileData();
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
                    " طلابي  ",
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
                icon: Icon(Icons.group_rounded))),
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
                SizedBox(height: 5),
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
                                left: 205,
                                child: Text(
                                  filteredItems[index],
                                  style: TextStyle(
                                    backgroundColor:
                                        Color.fromARGB(115, 127, 179, 71),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 50,
                                left: 205,
                                child: Text(
                                  'رقم الطالب',
                                  style: TextStyle(
                                    fontSize: 12,
                                    backgroundColor:
                                        Color.fromARGB(115, 127, 179, 71),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 30,
                                left: 20,
                                child: Text(
                                  'الساعات',
                                  style: TextStyle(
                                    fontSize: 12,
                                    backgroundColor:
                                        Color.fromARGB(115, 127, 179, 71),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {}, //going to the student info page
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
