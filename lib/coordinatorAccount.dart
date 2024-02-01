import 'package:flutter/material.dart';
import 'dart:math';

class coordinatorAccount extends StatefulWidget {

  @override
  _coordinatorAccount createState() => _coordinatorAccount();
}

class _coordinatorAccount extends State<coordinatorAccount> {
  bool showSchoolForm = false;
  bool showPhoneNumberForm = false;
  bool showEmailForm = false;
  bool showPassForm = false;
  bool showAddressForm = false;

  String initialSchool = "الثانوية الرابعة ";
  String initialPhoneNumber = "0118102502";
  String initialEmail = "Schoolth04@gmail.com";
  String initialPass = "12345";
  String initialAddress = "حي الغدير";

  String modifiedSchool = "";
  String modifiedPhone = "";
  String modifiedEmail = "";
  String modifiedPass = "";
  String modifiedAddress = "";

  late TextEditingController _schoolController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController ;
  late TextEditingController _passController ;
  late TextEditingController _addressController ;

  @override
  void initState() {
    super.initState();
    _schoolController = TextEditingController(text: initialSchool);
    _phoneNumberController = TextEditingController(text: initialPhoneNumber);
    _emailController = TextEditingController(text: initialEmail);
    _passController = TextEditingController(text: initialPass);
    _addressController = TextEditingController(text: initialAddress);
  }

   @override
  void dispose() {
    _schoolController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _addressController.dispose();
    super.dispose();
  }


   void updateSchool(String value) {
    setState(() {
      modifiedSchool = _schoolController.text;
    });
  }

   void updatePhone(String value) {
    setState(() {
      modifiedPhone = _phoneNumberController.text;
    });
  }

  void updateEmail(String value) {
    setState(() {
      modifiedEmail = _emailController.text;
    });
  }

  void updatePass(String value) {
    setState(() {
      modifiedPass = _passController.text;
    });
  }

  void updateAddress(String value) {
    setState(() {
      modifiedAddress = _addressController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
        backgroundColor: Color(0xFFece793),
        iconTheme: IconThemeData(color: Color(0xFFD3CA25), size: 45.0),
        
          title:Stack(
            alignment: Alignment.centerRight,
            children: [
              Row(
                children:[
              Container(
                margin: EdgeInsets.all(0),
                height: 58,
                width: 60,
                       ),],),
              Positioned(
                right:70,
                top:20,
                child: Text( 'حسابي ',
                style: TextStyle(
                  color: Color(0xFF0A2F5A),
                  fontSize: 28,
                                ),),),],),
                                
                leading: IconButton(
                iconSize: 70,
                padding: EdgeInsets.only(bottom: 6,left:300),
                color: Color.fromARGB(115, 127, 179, 71),
                onPressed: () {},
                 icon: Icon(Icons.person) )
            
    ),),
        
      body:SingleChildScrollView(
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
                 ),),
              SizedBox(height: 20.0),

              Expanded(
               child:Column(
                children: <Widget>[
                  //NAME
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                      padding: EdgeInsets.only(),
                     child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "الاسم",
                          style: TextStyle(
                              fontSize: 20,
                               color: Color(0xFF0A2F5A),
                                         ), ),),),
                 
                      SizedBox( height: 10, ),

                       Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFFf7f6d4),
                                                    ),
                        child: Row(
                               children: [
                               GestureDetector(
                               onTap: () {
                                   setState(() {
                                    showSchoolForm = !showSchoolForm;
                                    if (showSchoolForm) {
                                    _schoolController.text = modifiedSchool;
                                  } }); },
                               child: Icon(
                                         Icons.edit,
                                         color: Color(0xFFa7cc7f),
                                          ), ),
                              
                               SizedBox(width: 8.0),

                               Expanded( child:Visibility(
                               visible: showSchoolForm,
                               child: TextFormField(
                                  textAlign: TextAlign.right,
                                   //autovalidateMode:
                                 //AutovalidateMode.onUserInteraction,
                                //controller: _firstnameController,
                               //validator: validateFirstnam
                             //validator: validationPhoneNumber,
                                  controller: _schoolController,
                                  onChanged: updateSchool,
                                  decoration: InputDecoration(
                                          labelText: 'الرجاء ادخال الاسم',
                    ),),  ),), 
                             
                              Visibility(
                              visible: !showSchoolForm,
                              child:  Padding(
                                padding: EdgeInsets.only(left:8,right: 10),
                              child: Text(modifiedSchool.isNotEmpty
                                    ? modifiedSchool
                                    : initialSchool,
                                    style: TextStyle(fontSize: 18),),
                              ),),], ), ),
                      

                                SizedBox(height: 20,)
                    ],
                  ),
                          
                                                 //PHONE NUMBER
                                                 Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: <Widget>[
                                                  Align(
                                                 alignment: Alignment.centerRight,
                                                 child: Text(  "رقم الجوال",
                                                   style: TextStyle(
                                                   fontSize: 20,
                                                   color: Color(0xFF0A2F5A),),),
                                                    ),
                     
                                                    SizedBox( height: 10, ),
                    
                    
                                                                              Container(
                                                        height: 40,     
                                                         decoration: BoxDecoration(
                                                         borderRadius: BorderRadius.circular(15),
                                                         color: Color(0xFFf7f6d4), ),       
                                                         child: Row(
                                                         children: [ GestureDetector(
                                                         onTap: () {
                                                             setState(() {
                                                             showPhoneNumberForm = !showPhoneNumberForm;
                                                             if (showPhoneNumberForm) {
                                                              _phoneNumberController.text = modifiedPhone;
                                                                   } }); },
                                                         child: Icon(
                                                            Icons.edit,
                                                            color: Color(0xFFa7cc7f),
                                                                   ),
                                                                       ),
       
                                                          SizedBox(width: 8.0),
                                
                                                          Expanded( child:Visibility(
                                                            visible: showPhoneNumberForm,
                                                            child: TextFormField(
                                                            textAlign: TextAlign.right,
                                                             //autovalidateMode:
                                                            //AutovalidateMode.onUserInteraction,
                                                           //controller: _firstnameController,
                                                          //validator: validateFirstnam
                                                         //validator: validationPhoneNumber,
                                                             maxLength: 12,
                                                             autovalidateMode: AutovalidateMode.onUserInteraction,
                                                             keyboardType: TextInputType.number,
                                                             decoration: InputDecoration(
                                                            hintText: ("9665********"),
                                                                  ),
                                                            controller: _phoneNumberController,
                                                            onChanged: updatePhone,
                                                            ),  ),), 
                             
                                                            Visibility(
                                                            visible: !showPhoneNumberForm,
                                                            child: Padding(
                                                            padding: EdgeInsets.only(left: 8.0,right:10),                                                            child: Text(modifiedPhone.isNotEmpty
                                                                     ? modifiedPhone
                                                                     : initialPhoneNumber,
                                                                      style: TextStyle(fontSize: 18),),
                                                                  ),),], ), ),
                 
                                                    SizedBox(height: 10,),
                   
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                      Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Text( "البريد الالكتروني",
                                                        style: TextStyle(
                                                        fontSize: 20,
                                                        color: Color(0xFF0A2F5A),),),
                                                           ),
    
                                                    SizedBox(height: 10,),

                                                     Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFFf7f6d4),
                                                    ),
                        child: Row(
                               children: [
                               GestureDetector(
                               onTap: () {
                                   setState(() {
                                    showEmailForm = !showEmailForm;
                                    if (showEmailForm) {
                                    _emailController.text = modifiedEmail;
                                  } }); },
                               child: Icon(
                                         Icons.edit,
                                         color: Color(0xFFa7cc7f),
                                          ), ),
                              
                               SizedBox(width: 8.0),

                               Expanded( child:Visibility(
                               visible: showEmailForm,
                               child: TextFormField(
                                  textAlign: TextAlign.right,
                                   //autovalidateMode:
                                 //AutovalidateMode.onUserInteraction,
                                //controller: _firstnameController,
                               //validator: validateFirstnam
                             //validator: validationPhoneNumber,
                                  controller: _emailController,
                                  onChanged: updateEmail,
                                  decoration: InputDecoration(
                                          labelText: 'الرجاء ادخال الايميل',
                    ),),  ),), 
                             
                              Visibility(
                              visible: !showEmailForm,
                              child:  Padding(
                              padding: EdgeInsets.only(left:8,right: 10),                              child: Text(modifiedEmail.isNotEmpty
                                    ? modifiedEmail
                                    : initialEmail,
                                    style: TextStyle(fontSize: 18),),
                              ),),], ), ),
                      
       
                                                            SizedBox(height: 20,),

                                                            Column(
                                                             crossAxisAlignment: CrossAxisAlignment.start,
                                                             children: <Widget>[
                                                            Align(
                                           alignment: Alignment.centerRight,
                                          child: Text( "كلمة المرور",
                                               style: TextStyle(
                                               fontSize: 20,
                                               color: Color(0xFF0A2F5A), ),
                                               ),),
      

                                                             SizedBox( height: 10, ),
                                                            
                                                             Container(
                        height: 40,
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                            color: Color(0xFFf7f6d4),
                                                  ),       
                        child: Row(
                        children: [ GestureDetector(
                                    onTap: () {
                                    setState(() {
                                    showPassForm = !showPassForm;
                                    if (showPassForm) {
                                    _passController.text = modifiedPass;
                                  } }); },
                                    child: Icon(
                                           Icons.edit,
                                         color: Color(0xFFa7cc7f),
                                                ),
                                                ),
       
                                    SizedBox(width: 8.0),
                                
                                    Expanded( child:Visibility(
                                             visible: showPassForm,
                                             child: TextFormField(
                                             textAlign: TextAlign.right,
                                              //autovalidateMode:
                                             //AutovalidateMode.onUserInteraction,
                                           //controller: _firstnameController,
                                         //validator: validateFirstnam
                                       //validator: validationPhoneNumber,
                                             controller: _passController,
                                             onChanged: updatePass,
                                             obscureText: true,
                                             decoration: InputDecoration(
                                             labelText: 'الرجاء ادخال كلمة المرور',
                                             ),),  ),), 
                             
                                             Visibility(
                                                 visible: !showPassForm,
                                                 child: Expanded(
                                                 child: TextFormField(
                                                 // textAlign: TextAlign.justify,
                                                  decoration: InputDecoration(border:InputBorder.none ),
                                                   obscureText: true, // Hide the text and display as asterisks
                                                   initialValue: modifiedPass.isNotEmpty ? modifiedPass : initialPass,
                                                  style: TextStyle(fontSize: 18),),
                                              ),),], ),
                                               ),
                            
                      
                                          SizedBox(height: 20,),

                       
                   
                                          Align(
                                           alignment: Alignment.centerRight,
                                          child: Text( " العنوان",
                                               style: TextStyle(
                                               fontSize: 20,
                                               color: Color(0xFF0A2F5A), ),
                                               ),),
      
                                           SizedBox(height: 10),
                       Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFFf7f6d4),
                                                    ),
                        child: Row(
                               children: [
                               GestureDetector(
                               onTap: () {
                                   setState(() {
                                    showAddressForm = !showAddressForm;
                                    if (showAddressForm) {
                                    _addressController.text = modifiedAddress;
                                  } }); },
                               child: Icon(
                                         Icons.edit,
                                         color: Color(0xFFa7cc7f),
                                          ), ),
                              
                               SizedBox(width: 8.0),

                               Expanded( child:Visibility(
                               visible: showAddressForm,
                               child: TextFormField(
                                  textAlign: TextAlign.right,
                                   //autovalidateMode:
                                 //AutovalidateMode.onUserInteraction,
                                //controller: _firstnameController,
                               //validator: validateFirstnam
                             //validator: validationPhoneNumber,
                                  controller: _addressController,
                                  onChanged: updateAddress,
                                  decoration: InputDecoration(
                                          labelText: 'الرجاء ادخال العنوان',
                    ),),  ),), 
                             
                              Visibility(
                              visible: !showAddressForm,
                              child:  Padding(
                              padding: EdgeInsets.only(left:8,right: 10),                              child: Text(modifiedEmail.isNotEmpty
                                    ? modifiedAddress
                                    : initialAddress,
                                    style: TextStyle(fontSize: 18),),
                              ),),], ), ),



        
      SizedBox(height: 20),
      Container(
        padding: EdgeInsets.only(left: 110),
        child: ElevatedButton(
          onPressed: () {
            // SaveEdit();
             showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Color(0xFFf7f6d4),
                  title: Icon(Icons.check_circle,
                        color: Colors.green,
                        size: 50,),
                  content: Text("تم حفظ المعلومات بنجاح",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20,color: Color(0xFF0A2F5A))
                  ,));},);
          },
          child: Text(
            "حفظ",
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
                    ],
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
         
    );

    
  }
}