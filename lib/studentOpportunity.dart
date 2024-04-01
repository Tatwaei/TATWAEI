import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'user_state.dart';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'StudentOppDetails.dart';

class studentOpportunity extends StatefulWidget {
  @override
  _studentOpportunity createState() => _studentOpportunity();
}

class Opportunity1 {
  final String name;
  final String interest;
  final String source;
  final String opportunityId;

  Opportunity1(this.name, this.interest, this.source, this.opportunityId);
}

class Opportunity2 {
  final String name;
  final String opportunityId;

  Opportunity2(this.name, this.opportunityId);
}

class _studentOpportunity extends State<studentOpportunity> {
  XFile? image;
  final ImagePicker picker = ImagePicker();
  String? imageUrl;

  Future getImage(ImageSource media, int index) async {
    var img = await picker.pickImage(source: media);

    if (img != null) {
      File imageFile = File(img.path);
      await uploadImageToFirebase(imageFile);
    }
    setState(() {
      image = img;
    });
    myAlert(index);
  }

  Future<void> uploadImageToFirebase(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }

  void saveImageUrlToFirestore(
      String imageUrl, BuildContext context, int index) {
    String studentId = Provider.of<UserState>(context, listen: false).userId;
    String opportunityId = compList[index].opportunityId;
    FirebaseFirestore.instance
        .collection('seat')
        .where('studentId', isEqualTo: studentId)
        .where('opportunityId', isEqualTo: opportunityId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) {
        FirebaseFirestore.instance
            .collection('seat')
            .doc(documentSnapshot.id)
            .update({'certificate': imageUrl}).then((value) {
          print('Image URL saved to Firestore successfully.');
        }).catchError((error) {
          print('Error saving image URL to Firestore: $error');
          showErrorMessage(context);
        });
      });
    }).catchError((error) {
      print('Error retrieving document from Firestore: $error');
      showErrorMessage(context);
    });
  }

Future<String> getCertificateFromFirestore(BuildContext context, int index) async {
  String studentId = Provider.of<UserState>(context, listen: false).userId;
  String opportunityId = compList[index].opportunityId;

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('seat')
        .where('studentId', isEqualTo: studentId)
        .where('opportunityId', isEqualTo: opportunityId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assuming there's only one document for this studentId and opportunityId
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      return documentSnapshot['certificate'] ?? ''; // Return certificate if exists
    } else {
      print('No document found for studentId $studentId and opportunityId $opportunityId');
      return ''; // Return empty string if document not found
    }
  } catch (error) {
    print('Error retrieving certificate from Firestore: $error');
    return ''; // Return empty string in case of error
  }
}

  void showSuccessMessage(BuildContext context) {
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
            "تم رفع الشهادة بنجاح",
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

  void showErrorMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(
            Icons.error,
            color: Colors.green,
            size: 50,
          ),
          content: Text(
            "حدث خطأ الرجاء المحاولة مرة أخرى",
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

  bool showList1 = false;
  bool showList2 = false;

  List<Opportunity1> currentList = [];
  List<Opportunity2> compList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentOpp();
      getCompOpp();
    });
    //// modifiedClass = initialClass.toString();
  }

  Future<void> getCurrentOpp() async {
    String studentId = Provider.of<UserState>(context, listen: false).userId;
    QuerySnapshot<Map<String, dynamic>> seatSnapshot = await FirebaseFirestore
        .instance
        .collection('seat')
        .where('studentId', isEqualTo: studentId)
        .get();

    if (seatSnapshot.docs.isNotEmpty) {
      DateTime todayDate = DateTime.now();

      for (var seatDoc in seatSnapshot.docs) {
        String opportunityId = seatDoc.data()['opportunityId'];

        // Retrieve internal opportunity
        DocumentSnapshot<Map<String, dynamic>> internalOpportunitySnapshot =
            await FirebaseFirestore.instance
                .collection('internalOpportunity')
                .doc(opportunityId)
                .get();

        if (internalOpportunitySnapshot.exists) {
          DateTime endDate =
              internalOpportunitySnapshot.get('endDate').toDate();

          if (endDate.isAfter(todayDate)) {
            String name = internalOpportunitySnapshot.get('name');
            String interest = internalOpportunitySnapshot.get('interest');
            Opportunity1 opportunity = Opportunity1(
                name, interest, 'داخلية', opportunityId); // Set source as internal
            currentList.add(opportunity);
          }
        }

        // Retrieve external opportunity
        DocumentSnapshot<Map<String, dynamic>> externalOpportunitySnapshot =
            await FirebaseFirestore.instance
                .collection('externalOpportunity')
                .doc(opportunityId)
                .get();

        if (externalOpportunitySnapshot.exists) {
          DateTime endDate =
              externalOpportunitySnapshot.get('endDate').toDate();

          if (endDate.isAfter(todayDate)) {
            String name = externalOpportunitySnapshot.get('name');
            String interest = externalOpportunitySnapshot.get('interest');
            Opportunity1 opportunity = Opportunity1(name, interest, 'خارجية', opportunityId);
            currentList.add(opportunity);
          }
        }
      }
    }
  }

  Future<void> getCompOpp() async {
    String studentId = Provider.of<UserState>(context, listen: false).userId;
    QuerySnapshot<Map<String, dynamic>> seatSnapshot = await FirebaseFirestore
        .instance
        .collection('seat')
        .where('studentId', isEqualTo: studentId)
        .get();

    if (seatSnapshot.docs.isNotEmpty) {
      DateTime todayDate = DateTime.now();

      for (var seatDoc in seatSnapshot.docs) {
        String opportunityId = seatDoc.data()['opportunityId'];

        // Retrieve internal opportunity
        DocumentSnapshot<Map<String, dynamic>> internalOpportunitySnapshot =
            await FirebaseFirestore.instance
                .collection('internalOpportunity')
                .doc(opportunityId)
                .get();

        if (internalOpportunitySnapshot.exists) {
          DateTime endDate =
              internalOpportunitySnapshot.get('endDate').toDate();

          if (endDate.isBefore(todayDate)) {
            String name = internalOpportunitySnapshot.get('name');
            Opportunity2 opportunity = Opportunity2(name,opportunityId);
            compList.add(opportunity);
          }
        }

        // Retrieve external opportunity
        DocumentSnapshot<Map<String, dynamic>> externalOpportunitySnapshot =
            await FirebaseFirestore.instance
                .collection('externalOpportunity')
                .doc(opportunityId)
                .get();

        if (externalOpportunitySnapshot.exists) {
          DateTime endDate =
              externalOpportunitySnapshot.get('endDate').toDate();

          if (endDate.isBefore(todayDate)) {
            String name = externalOpportunitySnapshot.get('name');
            Opportunity2 opportunity = Opportunity2(name,opportunityId);
            compList.add(opportunity);
          }
        }
      }
    }
  }

  void myAlert(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFFf4f1be),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('الرجاء اختيار طريقةالرفع',
                textDirection: TextDirection.rtl,
                style: TextStyle(color: Color(0xFF0A2F5A))),
            content: Container(
              height: MediaQuery.of(context).size.width * 0.8,
              width: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                children: [
                  if (image != null)
                    Container(
                      width: 200, // Set the desired width of the container
                      height: 200, // Set the desired height of the container
                      child: Image.file(
                        File(image!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (image == null)
                    Text(
                      'No Image Uploaded',
                      style: TextStyle(fontSize: 20),
                    ),
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery, index);
                    },
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Icon(Icons.image, color: Color(0xFF0A2F5A)),
                        Text('من المعرض',
                            style: TextStyle(color: Color(0xFF0A2F5A))),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera, index);
                    },
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Icon(Icons.camera, color: Color(0xFF0A2F5A)),
                        Text(
                          'من الكاميرا',
                          style: TextStyle(color: Color(0xFF0A2F5A)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ButtonBar(
                buttonPadding: EdgeInsets.only(right: 80),
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFb4d392)),
                    ),
                    child: Text('الغاء',
                        style: TextStyle(color: Color(0xFF0A2F5A))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (imageUrl != null) {
                        saveImageUrlToFirestore(imageUrl!, context, index);
                        showSuccessMessage(context);
                      } else {
                        showErrorMessage(context);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFb4d392)),
                    ),
                    child:
                        Text('حفظ', style: TextStyle(color: Color(0xFF0A2F5A))),
                  ),
                ],
              ),
            ],
          );
        });
  }

  void myAlert2(BuildContext context, String opportunityId) {
    String studentId = Provider.of<UserState>(context, listen: false).userId;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('seat')
              .where('studentId', isEqualTo: studentId)
              .where('opportunityId', isEqualTo: opportunityId)
              .get(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the data to load, you can show a loading indicator
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              // If there's an error, you can show an error message
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              // If the document doesn't exist or there's no data, you can show a message
              return Text('No Data Found');
            }

            // Assuming there's only one document matching the query
            DocumentSnapshot<Map<String, dynamic>> document =
                snapshot.data!.docs[0];

            // Access the image URL from the document snapshot
            String imageUrl = document.get('certificate');
            String documentId = document.id;
            print('Document Snapshot: $documentId');

            print('Image URL: $imageUrl');

            return AlertDialog(
              backgroundColor: Color(0xFFf4f1be),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              content: Container(
                height: MediaQuery.of(context).size.width * 0.8,
                width: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  children: [
                    if (imageUrl != null && imageUrl.isNotEmpty)
                      Container(
                        width: 200,
                        height: 200,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (imageUrl == null || imageUrl.isEmpty)
                      Text(
                        'No Image Uploaded',
                        style: TextStyle(fontSize: 20),
                      ),
                  ],
                ),
              ),
              actions: [
                ButtonBar(
                  buttonPadding: EdgeInsets.only(right: 50),
                  children: [
                    ElevatedButton(
                      onPressed: () {
                          Navigator.pop(context);
                        },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFFb4d392)),
                      ),
                      child: Text(
                        'اغلاق',
                        style: TextStyle(color: Color(0xFF0A2F5A)),
                      ),
                    ), 
                  ],
                ),
              ],
            );
          },
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
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFF0A2F5A)),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Color(0xFFb4d392); // Color when pressed
                            }
                            return showList2
                                ? Color.fromARGB(255, 230, 248, 211)
                                : Color(
                                    0xFFb4d392); // Default color and color when not pressed
                          },
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFF0A2F5A)),
                      ),
                      style: ButtonStyle(
                         backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Color(0xFFb4d392); // Color when pressed
                            }
                            return showList1
                                ? Color.fromARGB(255, 230, 248, 211)
                                : Color(
                                    0xFFb4d392); // Default color and color when not pressed
                          },
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                                right: 80,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color.fromARGB(115, 127, 179, 71),
                                  ),
                                  child: Text(
                                    currentList[index].name,
                                    style: TextStyle(
                                      color: Color(0xFF0A2F5A),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 50,
                                left: 120,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color.fromARGB(115, 127, 179, 71),
                                  ),
                                  child: Text(
                                    currentList[index].source == 'داخلية'
                                        ? 'داخلية'
                                        : 'خارجية',
                                    style: TextStyle(
                                      color: Color(0xFF0A2F5A),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 50,
                                left: 20,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color.fromARGB(115, 127, 179, 71),
                                  ),
                                  child: Text(
                                    currentList[index].interest,
                                    style: TextStyle(
                                      color: Color(0xFF0A2F5A),
                                      fontSize: 12,
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
                            String oppId = currentList[index].opportunityId;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => OpportunityDetails(oppId: oppId,),
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
                                top: 16,
                                right: 80,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color.fromARGB(115, 127, 179, 71),
                                  ),
                                  child: Text(
                                    compList[index].name,
                                    style: TextStyle(
                                      color: Color(0xFF0A2F5A),
                                    ),
                                  ),
                                ),
                              ),
                              Stack(
                                children: [
                                  Positioned(
                                    top: 55,
                                    right: 195,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          child: ElevatedButton(
                                            onPressed: () async {
     String certificate= await getCertificateFromFirestore(context, index); 

  if (certificate != null && certificate.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('يوجد شهادة مرفوعة'),
        
      ),
    );
    myAlert2(context,compList[index].opportunityId);
  } else {
    myAlert(index);
  }                                            },
                                            child: Text(
                                              'رفع الشهادة',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFF0A2F5A)),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 187, 213, 159),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        image != null
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.file(
                                                    //to show image, you type like this.
                                                    File(image!.path),
                                                    fit: BoxFit.cover,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 300,
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                "No Image",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                      ],
                                    ),
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
                            String oppId = compList[index].opportunityId;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => OpportunityDetails(oppId: oppId,),
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
      ),
    );
  }
}
