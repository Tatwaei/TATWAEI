import 'package:flutter/material.dart';
import 'dart:math';

class OpportunityDetails extends StatefulWidget {
  @override
  _OpportunityPageState createState() => _OpportunityPageState();
}

class _OpportunityPageState extends State<OpportunityDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Color(0xFFece793),
          iconTheme: IconThemeData(color: Color(0xFFD3CA25), size: 45.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(3),
                height: 58,
                width: 60,
                child: SizedBox(
                  child: Image.asset('images/logo1.png', fit: BoxFit.fill),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "تفاصيل الفرص",
                      style: TextStyle(
                        color: Color(0xFF0A2F5A),
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Container(
                    width: 70,
                    child: IconButton(
                      padding: EdgeInsets.only(left: 10),
                      iconSize: 60,
                      color: Color.fromARGB(115, 127, 179, 71),
                      onPressed: () {},
                      icon: Icon(Icons.handshake_rounded),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(right: 5, left: 5),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(pi),
                        child: Icon(Icons.arrow_back_rounded),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 620,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFece793),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(115, 127, 179, 71),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'اسم الفرصة',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5), //
                      child: Container(
                        height: 520,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFece793),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 5, left: 5, top: 3),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'تفاصيل الفرصة التطوعية',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 127, 179, 71),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5, left: 5, bottom: 5, top: 1),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'جمع فائض الطعام من المدارسن',
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 5, left: 5, top: 3),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "١٥ ديسمبر - ٢٦ ديسمبر",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 127, 179, 71),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5, left: 5, bottom: 5, top: 1),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "١٢ يوم",
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 5, left: 5, top: 3),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "المقاعد",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 127, 179, 71),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5, left: 5, bottom: 5, top: 1),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "عدد المقاعد",
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 5, left: 5, top: 3),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "المجال التطوعي",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 127, 179, 71),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5, left: 5, bottom: 5, top: 1),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "المجال",
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 5, left: 5, top: 3),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "مكان التطوع",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 127, 179, 71),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5, left: 5, bottom: 5, top: 1),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "المكان",
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 5, left: 5, top: 3),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "الموقع",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 127, 179, 71),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5, left: 5, bottom: 5, top: 1),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "لينك",
                                      style: TextStyle(
                                        color: Color(0xFF0A2F5A),
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 5, left: 5, top: 3),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "الفوائد المكتسبة من الفرصة التطوعية",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 127, 179, 71),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5, left: 5, bottom: 5, top: 1),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "الثواب-",
                                          style: TextStyle(
                                            color: Color(0xFF0A2F5A),
                                            fontSize: 16,
                                          ),
                                          softWrap: true,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "الاجر-",
                                          style: TextStyle(
                                            color: Color(0xFF0A2F5A),
                                            fontSize: 16,
                                          ),
                                          softWrap: true,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "خدمة المجتمع-",
                                          style: TextStyle(
                                            color: Color(0xFF0A2F5A),
                                            fontSize: 16,
                                          ),
                                          softWrap: true,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
