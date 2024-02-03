import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'CoordinatorInoppDetails.dart';
import 'CoordinatorExoppDetails.dart';
import 'coordinatorAccount.dart';
import 'CordinatorMyStudent.dart';
import 'confirm_student_signup.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String searchValue = '';

  List<String> items = List<String>.generate(100, (index) => 'Item $index');
  List<String> filteredItems = [];

  void _performSearch() {
    // Perform the search logic here
    print('Searching for: $searchValue ');

    setState(() {
      filteredItems = items
          .where(
              (item) => item.toLowerCase().contains(searchValue.toLowerCase()))
          .toList();
    });
    // Update the UI or perform any other operations based on the filter text
  }

  void _applyFilter() {
    // Apply the filter logic here
    print('Applying filter');
    // Update the UI or perform any other operations based on the filter
  }

  @override
  void initState() {
    super.initState();
    filteredItems = items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Color(0xFFece793),
          iconTheme: IconThemeData(color: Color(0xFFD3CA25), size: 45.0),
          title: Row(
            children: [
              Container(
                margin: EdgeInsets.all(3),
                height: 58,
                width: 60,
                child: SizedBox(
                  child: Image.asset('images/logo1.png', fit: BoxFit.fill),
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawer: Directionality(
        textDirection: TextDirection.rtl,
        child: Drawer(
          backgroundColor: Color(0xFFece793),
          child: ListView(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              child: IconButton(
                                padding: EdgeInsets.only(right: 40),
                                iconSize: 90,
                                color: Color.fromARGB(115, 127, 179, 71),
                                onPressed: () {},
                                icon: Icon(Icons.person),
                              ),
                            ),
                            Text(
                              ' الثانوية الرابعة',
                              style: TextStyle(
                                color: Color.fromARGB(115, 127, 179, 71),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                width: 100,
                color: Color.fromARGB(115, 127, 179, 71),
                child: ListTile(
                  title: Text(
                    'حسابي',
                    style: TextStyle(
                      color: Color(0xFF0A2F5A),
                      fontSize: 24,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => coordinatorAccount()));
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                width: 100,
                color: Color.fromARGB(115, 127, 179, 71),
                child: ListTile(
                  title: Text(
                    'طلابي',
                    style: TextStyle(
                      color: Color(0xFF0A2F5A),
                      fontSize: 24,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CordinatorMyStudent())); // Handle drawer item tap for settings
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                width: 100,
                color: Color.fromARGB(115, 127, 179, 71),
                child: ListTile(
                  title: Text(
                    'تأكيد الطلاب',
                    style: TextStyle(
                      color: Color(0xFF0A2F5A),
                      fontSize: 24,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConfirmStudentPage()));
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                width: 100,
                color: Color.fromARGB(115, 127, 179, 71),
                child: ListTile(
                  title: Text(
                    ' فرص التطوع',
                    style: TextStyle(
                      color: Color(0xFF0A2F5A),
                      fontSize: 24,
                    ),
                  ),
                  onTap: () {
                    // Handle drawer item tap for logout
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                width: 100,
                color: Color.fromARGB(115, 127, 179, 71),
                child: ListTile(
                  title: Text(
                    'تسجيل خروج',
                    style: TextStyle(
                      color: Color(0xFF0A2F5A),
                      fontSize: 24,
                    ),
                  ),
                  onTap: () {
                    // Handle drawer item tap for logout
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 70),
                width: 100,
                color: Color.fromARGB(115, 127, 179, 71),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "تواصل معنا ",
                        style: TextStyle(
                          color: Color(0xFF0A2F5A),
                          fontSize: 24,
                        ),
                      ),
                      onTap: () {
                        // Handle drawer item tap for logout
                      },
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.mail, // Change this to the desired icon
                          color: Color(0xFF0A2F5A),
                          size: 24,
                        ),
                        SizedBox(
                            width: 8), // Add some spacing between icon and text
                        Text(
                          "ContactTatwaei@gmail.com",
                          style: TextStyle(
                            color: Color(0xFF0A2F5A),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.x, // Change this to the desired icon
                          color: Color(0xFF0A2F5A),
                          size: 24,
                        ),
                        SizedBox(
                            width: 8), // Add some spacing between icon and text
                        Text(
                          "ContactTatwaei",
                          style:
                              TextStyle(color: Color(0xFF0A2F5A), fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 8, bottom: 8.0, left: 30, right: 30),
        child: Column(
          children: [
            Container(
              width: 500,
              height: 62,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      _applyFilter();
                    },
                    icon: Icon(
                      Icons.filter_list,
                      size: 30,
                      color: Color(0xFFD3CA25),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchValue = value;
                        });
                      },
                      onSubmitted: (value) {
                        _performSearch();
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Color(0xFFf7f6d4))),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xFFf7f6d4),
                        prefixIcon: IconButton(
                          alignment: Alignment(55, 0),
                          color: Color(0xFFD3CA25),
                          icon: Icon(Icons.search),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
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
                              filteredItems[index],
                              style: TextStyle(
                                color: Color(0xFF0A2F5A),
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
                                color: Color(0xFF0A2F5A),
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
                                color: Color(0xFF0A2F5A),
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
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OpportunityDetails()));
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
