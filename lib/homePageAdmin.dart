import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'AdminInoppDetails.dart';
import 'AdminExoppDetails.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
CollectionReference internalOpportunity = FirebaseFirestore.instance.collection('internalOpportunity');
CollectionReference externalOpportunity = FirebaseFirestore.instance.collection('externalOpportunity');

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String searchValue = '';

Future<List<DocumentSnapshot>> getIngredients() async {
  CollectionReference internalOpportunity =
      _firestore.collection('internalOpportunity');
  CollectionReference externalOpportunity =
      _firestore.collection('externalOpportunity');

  QuerySnapshot internalSnapshot = await internalOpportunity.get();
  QuerySnapshot externalSnapshot = await externalOpportunity.get();

  List<DocumentSnapshot> internal = internalSnapshot.docs;
  List<DocumentSnapshot> external = externalSnapshot.docs;

  List<DocumentSnapshot> opp = [
    ...internal,
    ...external
  ];

  return opp;
}

List<DocumentSnapshot> opp = [];
List<DocumentSnapshot<Object?>> filteredItems = [];

late CollectionReference internalOpportunity;
late CollectionReference externalOpportunity;

void _performSearch() {
    print('Searching for: $searchValue ');

    // Perform the search logic here
    List<DocumentSnapshot> searchResults = opp
        .where((opportunity) =>
            opportunity['name'].toString().contains(searchValue))
        .toList();

    setState(() {
      filteredItems = searchResults;
    });
  }

  void _applyFilter() {
    // Apply the filter logic here
    print('Applying filter');
    // Update the UI or perform any other operations based on the filter
  }

@override
void initState() {
  super.initState();
   internalOpportunity = _firestore.collection('internalOpportunity');
    externalOpportunity = _firestore.collection('externalOpportunity');
  getIngredients().then((ingredients) {
    setState(() {
      opp = ingredients;
      filteredItems = opp;
    });
  });
}

Future<String> getSource(DocumentSnapshot<Object?> opportunity) async {
  String source = '';
  DocumentReference<Object?> internalRef = internalOpportunity.doc(opportunity.id);
  DocumentReference<Object?> externalRef = externalOpportunity.doc(opportunity.id);

  DocumentSnapshot<Object?> internalSnapshot = await internalRef.get();
  DocumentSnapshot<Object?> externalSnapshot = await externalRef.get();

  if (internalSnapshot.exists) {
    source = 'Internal';
  } else if (externalSnapshot.exists) {
    source = 'External';
  }

  return source;
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
                              "الادارة",
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
                    "فرص التطوع",
                    style: TextStyle(
                      color: Color(0xFF0A2F5A),
                      fontSize: 24,
                    ),
                  ),
                  onTap: () {
                    // Handle drawer item tap for home
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
                margin: EdgeInsets.only(top: 300),
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

      return FutureBuilder<String>(
        future: getSource(filteredItems[index]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Return a loading indicator if the data is still loading
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Handle the error case
            return Text('Error loading source');
          } else {
            // Data is loaded successfully, display the source
            String source = snapshot.data!;
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
                            left: 120,
                            child: Text(
                              filteredItems[index]['name'],
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: Color(0xFF0A2F5A),
                                backgroundColor:
                                    Color.fromARGB(115, 127, 179, 71),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 50,
                            left: 160,
                            child: Text(
                              source,
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
                              filteredItems[index]['interest'],
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
                }},
              );
                },
            ),),
          ],
        ),
      ),
    );
  }
}
