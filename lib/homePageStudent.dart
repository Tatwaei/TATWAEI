import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'StudentOppDetails.dart';
import 'studentAccount.dart';
import 'studentOpportunity.dart';
import 'StudentMyhours.dart';
import 'package:provider/provider.dart';
import 'user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tatwaei/login.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
CollectionReference internalOpportunity =
    FirebaseFirestore.instance.collection('internalOpportunity');
CollectionReference externalOpportunity =
    FirebaseFirestore.instance.collection('externalOpportunity');

class HomePageStudent extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageStudent> {
  Future<void> onRefresh() async {
    var newOpp = await getIngredients();
    setState(() {
      opp = newOpp;
      filteredItems = newOpp;
    });
  }

  final TextEditingController _searchController = TextEditingController();
  String searchValue = '';
  late String initialName = '';

  Future<List<DocumentSnapshot>> getIngredients() async {
    CollectionReference internalOpportunity =
        _firestore.collection('internalOpportunity');
    CollectionReference externalOpportunity =
        _firestore.collection('externalOpportunity');

    String userId = Provider.of<UserState>(context, listen: false).userId;

    String? schoolId;

    DocumentSnapshot studentSnapshot =
        await _firestore.collection('student').doc(userId).get();
    if (studentSnapshot.exists) {
      schoolId = studentSnapshot.get('schoolId') as String?;
    }

    DateTime now = DateTime.now();

    QuerySnapshot coordinatorSnapshot = await _firestore
        .collection('schoolCoordinator')
        .where('schoolId', isEqualTo: schoolId)
        .get();

    String? coordinatorEmail;
    if (coordinatorSnapshot.size > 0) {
      for (DocumentSnapshot doc in coordinatorSnapshot.docs) {
        String? docSchoolId = doc.get('schoolId') as String?;
        if (docSchoolId == schoolId) {
          coordinatorEmail = doc.get('email') as String?;
          break; // Exit the loop once the coordinator's email is found
        }
      }
    }
    QuerySnapshot internalSnapshot = await internalOpportunity
        .where('coordinator_email', isEqualTo: coordinatorEmail)
        .get();

    QuerySnapshot externalSnapshot = await externalOpportunity.get();

    List<DocumentSnapshot> internal = internalSnapshot.docs;
    List<DocumentSnapshot> external = externalSnapshot.docs;

    List<DocumentSnapshot> opp = [...internal, ...external].where((doc) {
      DateTime startDate = doc['startDate'].toDate();
      return startDate.isAfter(now);
    }).toList();

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

  bool filservice = false;
  bool filbusns = false;
  bool filsocial = false;
  bool filhealth = false;
  bool filother = false;
  String placeSelected = '';
  String selectedGender = '';

  void LogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'متأكد من تسجيل الخروج؟',
                style: TextStyle(
                  color: Color(0xFF0A2F5A),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // Close the dialog
                      try {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false,
                        );
                      } catch (error) {
                        print("Sign out error: $error");
                      }
                    },
                    child: Text('نعم',
                        style:
                            TextStyle(color: Color(0xFF0A2F5A), fontSize: 15)),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('لا',
                        style:
                            TextStyle(color: Color(0xFF0A2F5A), fontSize: 15)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _filterPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Color(0xFFf7f6d4),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 180, bottom: 10),
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        'المجال',
                        style:
                            TextStyle(fontSize: 25, color: Color(0xFF0A2F5A)),
                      ),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 187, 213, 159),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    SizedBox(height: 16),
                    Container(
                      margin: EdgeInsets.only(left: 100, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "خدمية",
                                style: TextStyle(
                                  color: Color(0xFF0A2F5A),
                                ),
                              ),
                              Checkbox(
                                activeColor: Color(0xFF0A2F5A),
                                value: filservice,
                                onChanged: (bool? val) {
                                  setState(() {
                                    print("work");
                                    filservice = val!;
                                  });
                                },
                              ),
                              SizedBox(width: 10),
                              Text("ادارية",
                                  style: TextStyle(
                                    color: Color(0xFF0A2F5A),
                                  )),
                              Checkbox(
                                activeColor: Color(0xFF0A2F5A),
                                value: filbusns,
                                onChanged: (bool? val) {
                                  setState(() {
                                    print("work2");
                                    filbusns = val!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 85, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("اجتماعية",
                                  style: TextStyle(
                                    color: Color(0xFF0A2F5A),
                                  )),
                              Checkbox(
                                activeColor: Color(0xFF0A2F5A),
                                value: filsocial,
                                onChanged: (bool? val) {
                                  setState(() {
                                    print("work3");
                                    filsocial = val!;
                                  });
                                },
                              ),
                              SizedBox(width: 10),
                              Text("صحية",
                                  style: TextStyle(
                                    color: Color(0xFF0A2F5A),
                                  )),
                              Checkbox(
                                activeColor: Color(0xFF0A2F5A),
                                value: filhealth,
                                onChanged: (bool? val) {
                                  setState(() {
                                    print("work4");
                                    filhealth = val!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 195, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("اخرى",
                                  style: TextStyle(
                                    color: Color(0xFF0A2F5A),
                                  )),
                              Checkbox(
                                activeColor: Color(0xFF0A2F5A),
                                value: filother,
                                onChanged: (bool? val) {
                                  setState(() {
                                    print("work5");
                                    filother = val!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 180, bottom: 10),
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        'المكان',
                        style:
                            TextStyle(fontSize: 25, color: Color(0xFF0A2F5A)),
                      ),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 187, 213, 159),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    SizedBox(height: 16),
                    Container(
                      margin: EdgeInsets.only(left: 150, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "داخل المدرسة",
                                style: TextStyle(
                                  color: Color(0xFF0A2F5A),
                                ),
                              ),
                              Radio<String>(
                                value: 'داخل المدرسة',
                                groupValue: placeSelected,
                                onChanged: (value) {
                                  setState(() {
                                    placeSelected = value!;
                                  });
                                },
                                activeColor: Color(0xFF0A2F5A),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "خارج المدرسة",
                                style: TextStyle(
                                  color: Color(0xFF0A2F5A),
                                ),
                              ),
                              Radio<String>(
                                value: 'خارج المدرسة',
                                groupValue: placeSelected,
                                onChanged: (value) {
                                  setState(() {
                                    placeSelected = value!;
                                  });
                                },
                                activeColor: Color(0xFF0A2F5A),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 180, bottom: 10),
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        'الجنس',
                        style:
                            TextStyle(fontSize: 25, color: Color(0xFF0A2F5A)),
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 187, 213, 159),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 120, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "ذكر",
                                style: TextStyle(
                                  color: Color(0xFF0A2F5A),
                                ),
                              ),
                              Radio<String>(
                                value: 'ذكر',
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value!;
                                  });
                                },
                                activeColor: Color(0xFF0A2F5A),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "انثى",
                                style: TextStyle(
                                  color: Color(0xFF0A2F5A),
                                ),
                              ),
                              Radio<String>(
                                value: 'انثى',
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value!;
                                  });
                                },
                                activeColor: Color(0xFF0A2F5A),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 185, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "كلاهما",
                                style: TextStyle(
                                  color: Color(0xFF0A2F5A),
                                ),
                              ),
                              Radio<String>(
                                value: 'كلاهما',
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value!;
                                  });
                                },
                                activeColor: Color(0xFF0A2F5A),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //margin: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 187, 213, 159)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('اغلاق',
                                style: TextStyle(color: Color(0xFF0A2F5A))),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 187, 213, 159),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedGender = '';
                                placeSelected = '';
                                filservice = false;
                                filbusns = false;
                                filsocial = false;
                                filhealth = false;
                                filother = false;
                              });
                            },
                            child: Text("حذف الكل",
                                style: TextStyle(color: Color(0xFF0A2F5A))),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 187, 213, 159)),
                            onPressed: () {
                              _applyFilter();
                              Navigator.of(context).pop();
                            }, //should handle the filtering
                            child: Text('تطبيق',
                                style: TextStyle(color: Color(0xFF0A2F5A))),
                          ),
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
    );
  }

  void _applyFilter() async {
    List<DocumentSnapshot> opp = await getIngredients();

    List<DocumentSnapshot> filteredOpportunities = opp.where((opportunity) {
      bool typeMatch = false;
      bool genderMatch = false;
      bool placeMatch = false;

      var interests = opportunity['interest'];
      if ((filservice || filbusns || filhealth || filsocial || filother)) {
        if (interests != null) {
          if ((filsocial && interests == "اجتماعية") ||
              (filbusns && interests == "ادارية") ||
              (filhealth && interests == "صحية") ||
              (filother && interests == "اخرى") ||
              (filservice && interests == "خدمية")) {
            typeMatch = true;
          }
        } //if nothing is chosen from interest, then consider it
      } else {
        typeMatch = true;
      }

      String gender = opportunity['gender'];
      if (selectedGender != '') {
        if (gender != null) {
          if ((selectedGender == 'ذكر' && gender == 'ذكر') ||
              (selectedGender == 'انثى' &&
                  (gender == 'انثى' || gender == 'أنثى')) ||
              (selectedGender == 'كلاهما' && gender == 'كلاهما')) {
            genderMatch = true;
          }
        }
      } else {
        //same thing here, no gender chosen , then consider all
        genderMatch = true;
      }

      String? collectionName = opportunity.reference.parent?.id;
      if (placeSelected != '') {
        if (collectionName != null) {
          if ((placeSelected == "داخل المدرسة" &&
                  collectionName == "internalOpportunity") ||
              (placeSelected == "خارج المدرسة" &&
                  collectionName == "externalOpportunity")) {
            placeMatch = true;
          }
        }
      } else {
        //same thing here, no placw chosen , then consider all
        placeMatch = true;
      }

      return typeMatch && genderMatch && placeMatch;
    }).toList();
    if (!filsocial &&
        !filbusns &&
        !filhealth &&
        !filother &&
        selectedGender.isEmpty &&
        placeSelected.isEmpty) {
      filteredOpportunities = opp;
    }

    setState(() {
      filteredItems = filteredOpportunities;
    });
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserName();
    });
  }

  Future<void> getUserName() async {
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
      });
    }
  }

  Future<String> getSource(DocumentSnapshot<Object?> opportunity) async {
    String source = '';
    DocumentReference<Object?> internalRef =
        internalOpportunity.doc(opportunity.id);
    DocumentReference<Object?> externalRef =
        externalOpportunity.doc(opportunity.id);

    DocumentSnapshot<Object?> internalSnapshot = await internalRef.get();
    DocumentSnapshot<Object?> externalSnapshot = await externalRef.get();

    if (internalSnapshot.exists) {
      source = 'داخلية';
    } else if (externalSnapshot.exists) {
      source = 'خارجية';
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
                              initialName,
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
                        builder: (context) => studentAccount()));
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                width: 100,
                color: Color.fromARGB(115, 127, 179, 71),
                child: ListTile(
                  title: Text(
                    'فرصي',
                    style: TextStyle(
                      color: Color(0xFF0A2F5A),
                      fontSize: 24,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => studentOpportunity()));
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                width: 100,
                color: Color.fromARGB(115, 127, 179, 71),
                child: ListTile(
                  title: Text(
                    'ساعاتي',
                    style: TextStyle(
                      color: Color(0xFF0A2F5A),
                      fontSize: 24,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => StudentMyhours()));

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
                    LogoutConfirmation(context);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 150),
                width: 100,
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
                      _filterPopup(context);
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
                      textAlign: TextAlign.center,
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
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<String>(
                      future: getSource(filteredItems[index]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                    right: 80,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color:
                                            Color.fromARGB(115, 127, 179, 71),
                                      ),
                                      child: Text(
                                        filteredItems[index]['name'],
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF0A2F5A),
                                          //    backgroundColor:
                                          //     Color.fromARGB(115, 127, 179, 71),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 50,
                                    left: 130,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color:
                                            Color.fromARGB(115, 127, 179, 71),
                                      ),
                                      child: Text(
                                        source,
                                        style: TextStyle(
                                          color: Color(0xFF0A2F5A),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 50,
                                    left: 20,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color:
                                            Color.fromARGB(115, 127, 179, 71),
                                      ),
                                      child: Text(
                                        filteredItems[index]['interest'],
                                        style: TextStyle(
                                          color: Color(0xFF0A2F5A),
                                          fontSize: 14,
                                        ),
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
                                            offset: Offset(0,
                                                3), // changes position of shadow
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
                                String oppId = filteredItems[index]
                                    .id; // Assuming filteredItems is a list of DocumentSnapshots
                                print('Clicked oppId: $oppId');
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      OpportunityDetails(oppId: oppId),
                                ));
                              },
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
