import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';
import 'StudentOppDetails.dart';

class studentOpportunity extends StatefulWidget {
  @override
  _studentOpportunity createState() => _studentOpportunity();
}

class _studentOpportunity extends State<studentOpportunity> {
  XFile? image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  bool showList1 = false;
  bool showList2 = false;

  List<String> currentList = List<String>.generate(30, (index) => 'Item $index');
  List<String> compList = List<String>.generate(30, (index) => 'Item $index');

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
                  right: 80,
                  top: 20,
                  child: Text(
                    'فرصي',
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
                icon: Icon(Icons.handshake_rounded))),
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
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
               Container(
                padding: EdgeInsets.only(left: 30),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showList2 = !showList2;
                    });
                  },
                  child: Text(
                    "المكتملة",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Color(0xFF0A2F5A)),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFFb4d392)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          color: Color(0xFFb4d392),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            
            Container(
              padding: EdgeInsets.only(right: 30),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showList1 = !showList1;
                  });
                },
                child: Text(
                  "الحالية",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Color(0xFF0A2F5A)),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFFb4d392)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
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

           SizedBox(height: 20.0),

            if (showList1) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: currentList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFf7f6d4),
                      ),
                      width: 70.0,
                      height: 90.0,
                      margin: EdgeInsets.only(bottom: 20),
                      child: ListTile(
                        title: Stack(
                          children: [
                            Positioned(
                              top: 12,
                              left: 140,
                              child: Text(
                                currentList[index],
                                style: TextStyle(
                                  color:  Color(0xFF0A2F5A),
                                  backgroundColor:
                                      Color.fromARGB(115, 127, 179, 71),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 50,
                              left: 140,
                              child: Text(
                                'Subtitle 1',
                                style: TextStyle(
                                  color:  Color(0xFF0A2F5A),
                                  fontSize: 12,
                                  backgroundColor:
                                      Color.fromARGB(115, 127, 179, 71),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 50,
                              left: 40,
                              child: Text(
                                'Subtitle 2',
                                style: TextStyle(
                                  color:  Color(0xFF0A2F5A),
                                  fontSize: 12,
                                  backgroundColor:
                                      Color.fromARGB(115, 127, 179, 71),
                                ),
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
                                      offset: Offset(0, 3),
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
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OpportunityDetails(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          
            if (showList2) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: compList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFf7f6d4),
                      ),
                      width: 70.0,
                      height: 90.0,
                      margin: EdgeInsets.only(bottom: 20),
                      child: ListTile(
                        title: Stack(
                          children: [
                            Positioned(
                              top: 12,
                              left: 140,
                              child: Text(
                                compList[index],
                                style: TextStyle(
                                  color: Color(0xFF0A2F5A),
                                  backgroundColor:
                                      Color.fromARGB(115, 127, 179, 71),
                                ),
                              ),
                            ),
                            Stack(
  children: [
    Stack(
  children: [
    Positioned(
      top: 40,
      left: 80,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    title: Text('Please choose media to select'),
                    content: Container(
                      height: MediaQuery.of(context).size.height / 6,
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              getImage(ImageSource.gallery);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.image),
                                Text('From Gallery'),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              getImage(ImageSource.camera);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.camera),
                                Text('From Camera'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Text(
              'رفع الشهادة',
              style: TextStyle(fontSize: 12,color: Color(0xFF0A2F5A)),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 187, 213, 159),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0.5),
            ),
          ),
          SizedBox(height: 20),
          if (image != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(image!.path),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                ),
              ),
            )
          else
            Text(
              "No Image",
              style: TextStyle(fontSize: 20),
            ),
        ],
      ),
    ),
  ],
),
  ],
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
                                      offset: Offset(0, 3),
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
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OpportunityDetails(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
     ), );
  }
}
