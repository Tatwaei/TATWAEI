import 'package:flutter/material.dart';
import 'dart:math';

class ConfirmStudentPage extends StatefulWidget {
  @override
  _ConfirmStudentPage createState() => _ConfirmStudentPage();
}

class _ConfirmStudentPage extends State<ConfirmStudentPage> {
  List<Map<String, dynamic>> items = [
    {'title': 'اسم الطالب الاول', 'subtitle': 'الصف الدرسي', 'id': 1},
    {'title': 'اسم الطالب الثاني', 'subtitle': 'الصف الدرسي', 'id': 1},
  ];

  void _deleteItem(int id) {
    setState(() {
      items.removeWhere((item) => item['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFFece793),
          iconTheme: const IconThemeData(color: Color(0xFFD3CA25), size: 45.0),
          title: Stack(
            alignment: Alignment.centerRight,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(0),
                    height: 58,
                    width: 60,
                  ),
                ],
              ),
              const Positioned(
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
              padding: const EdgeInsets.only(bottom: 6, left: 300),
              color: const Color.fromARGB(115, 127, 179, 71),
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.group_rounded))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                color: const Color(0xFFD3CA25),
                icon: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: const Icon(Icons.arrow_back),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                int itemId = items[index]['id'];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F6D4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color(0xFFc7dda0),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  items[index]['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0A2F5A),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _deleteItem(itemId),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 13),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFA90505),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Text(
                                        'رفض',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => _deleteItem(itemId),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 13),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF7EB347),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Text(
                                        'قبول',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 113),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFc7dda0),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      items[index]['subtitle'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0A2F5A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
