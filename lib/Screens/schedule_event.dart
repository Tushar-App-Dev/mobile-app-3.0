import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'constant/Constant.dart';

class ScheduleEvent extends StatefulWidget {
  final String email;
  final String user;
  final String phone;
  const ScheduleEvent({Key key, this.user, this.email, this.phone}) : super(key: key);

  @override
  State<ScheduleEvent> createState() => _ScheduleEventState();
}

class _ScheduleEventState extends State<ScheduleEvent> {

  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String uid,_user,comments;
  String _setTime, _setDate, api_key;
  int _radioSelected1;
  var expert;
  String _hour, _minute, _time,Email;

  String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  List<String> emailList = [
    'Phone',
    'WhatsApp Video',
    'Zoom',
  ];
  List<String> farmsIdList = [];

  List<String> topicList = [
    'General',
    'Disease',
    'Plantation',
    'Harvesting',
    'Pesticides',
    'Best Practices'
  ];

  String EmailDropDownValue,topic;


  @override
  void initState() {
    _dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());//DateFormat.yMd().format(DateTime.now());
    _timeController.text = '00:00';
    getFarms();
    super.initState();
  }
  void getFarms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    farmsIdList.clear();
    //prefs.setString('api_key', 'c39f7457e507403bae918f7996db7a68');
    api_key = prefs.getString('api_key');
    var response = await http.get(
        Uri.parse('https://api.mapmycrop.com/farm/?api_key=$api_key'));
    print(response.statusCode);
    print(response.body);
    var data = await jsonDecode(response.body);
    print(data[0]['id']);
    for(int i=0;i<data['features'].length;i++){
      farmsIdList.add(data[i]['id']);
    }
  }

 var obj = {

};


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          //physics: BouncingScrollPhysics(),
          child: Form(
            child: formUI(),
            key: _key,
          ),
        ),
      ),
    );
  }

  Widget formUI() {
    var scrWidth = width(context);
    var scrHeight = height(context);
   return Stack(
     children: [
       Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Align(
             alignment: Alignment.centerLeft,
             child: Padding(
               padding: const EdgeInsets.only(left: 40.0, top: 60),
               child: Text(
                 'Welcome',
                 style: TextStyle(
                   fontFamily: 'Cardo',
                   fontSize: 35,
                   color: Color(0xff0C2551),
                   fontWeight: FontWeight.w900,
                 ),
               ),
               //
             ),
           ),
           Align(
             alignment: Alignment.centerLeft,
             child: Padding(
               padding: const EdgeInsets.only(left: 40, top: 5),
               child: Text(
                 'Schedule an Event',
                 style: TextStyle(
                   fontFamily: 'Nunito Sans',
                   fontSize: 15,
                   color: Colors.grey,
                   fontWeight: FontWeight.w700,
                 ),
               ),
             ),
           ),
           SizedBox(
             height: 40,
           ),
           Container(
             padding: EdgeInsets.only(top: 10, bottom: 10,left:50,right: 50),
             height: 70.0,
             child: TextFormField(
               // validator: _validateFirstName,
               readOnly: true,
               keyboardType:
               TextInputType.text,
               textInputAction:
               TextInputAction.next,
               maxLines: 1,
               style: new TextStyle(
                   color: Colors.black),
               initialValue: widget.user,
               decoration: InputDecoration(
                   focusedBorder: OutlineInputBorder(
                       borderSide: BorderSide(
                           color:
                           Colors.black),
                       borderRadius:
                       BorderRadius.all(
                           Radius.circular(
                               10))),
                   enabledBorder: OutlineInputBorder(
                       borderSide: BorderSide(
                           color:
                           Colors.black),
                       borderRadius:
                       BorderRadius.all(
                           Radius.circular(10))),
                   labelStyle: TextStyle(color: Colors.black),
                   labelText: "Name"),
               onSaved: (String val) {
                 setState(() {
                 });
               },
             ),
           ),
           Container(
             margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
             height: 50.0,
             child: Row(
               //mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Flexible(
                   flex: 1,
                   child: Container(
                     margin: EdgeInsets.only(left:50.0,right: 30.0),
                     height:70.0,
                     child: InkWell(
                       onTap: () {
                         _selectDate(context);
                       },
                       child: TextFormField(
                         style: TextStyle(fontSize: 17),
                         textAlign: TextAlign.center,
                         enabled: false,
                         keyboardType: TextInputType.text,
                         controller: _dateController,
                         onSaved: (String val) {
                           _setDate = val;
                         },
                         decoration: InputDecoration(
                             disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                             labelText: 'Choose Date',
                             floatingLabelBehavior: FloatingLabelBehavior.auto,
                             contentPadding: EdgeInsets.all(5)),
                       ),
                     ),
                   ),
                 ),
                 Container(width: 2,height: 30,color: Colors.grey,),
                 Flexible(
                   flex: 1,
                   child: Container(
                     margin: EdgeInsets.only(left:20.0,right: 50.0),
                     height:70.0,
                     child: InkWell(
                       onTap: () {
                         _selectTime(context);
                       },
                       child: TextFormField(
                         style: TextStyle(fontSize: 18,),
                         textAlign: TextAlign.center,
                         onSaved: (String val) {
                           _setTime = val;
                         },
                         enabled: false,
                         keyboardType: TextInputType.text,
                         controller: _timeController,
                         decoration: InputDecoration(
                             disabledBorder:
                             UnderlineInputBorder(borderSide: BorderSide.none),
                             labelText: 'Choose Time',
                             //floatingLabelBehavior: FloatingLabelBehavior.auto,
                             contentPadding: EdgeInsets.all(5)),
                       ),
                     ),
                   ),
                 ),
               ],
             ),
           ),
           Container(
               margin: EdgeInsets.symmetric(horizontal: 50.0,vertical: 10.0),
               height: 50.0,
               decoration: ShapeDecoration(
                 shape: RoundedRectangleBorder(
                   side: BorderSide(
                       width: 1.0, style: BorderStyle.solid),
                   borderRadius:
                   BorderRadius.all(Radius.circular(10.0)),
                 ),
               ),
               child:DropdownButtonHideUnderline(
                 child: DropdownButton<String>(
                   //focusNode: emailIDFocusNode,
                   hint: Padding(
                     padding: const EdgeInsets.only(left: 8.0),
                     child: Text('Choose farm'),
                   ),
                   value: EmailDropDownValue,
                   elevation: 25,
                   isExpanded: true,
                   icon:
                   Icon(Icons.arrow_drop_down_circle),
                   items: farmsIdList.map((String value) {
                     return DropdownMenuItem<String>(
                       value: value,
                       child: Center(
                           child: Text(
                             value,
                             style: TextStyle(
                                 fontWeight: FontWeight.w500),
                           )),
                     );
                   }).toList(),
                   onChanged: (String newvalue) {
                     setState(() {
                       // FocusScope.of(context).requestFocus(new FocusNode());
                       EmailDropDownValue = newvalue;
                       // getVillageData(zoneDropDownValue);
                     });
                   },
                 ),
               )
           ),
           Container(
             padding: EdgeInsets.only(top: 10, bottom: 10,left:50,right: 50),
             height:70.0,
             child: TextFormField(
               validator: _validateEmail,
               style: new TextStyle(color: Colors.black),
               keyboardType: TextInputType.text,
               //controller: _emailController,
               initialValue:widget.email!=null?widget.email:'',
               decoration: InputDecoration(
                   focusedBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.black),
                       borderRadius: BorderRadius.all(Radius.circular(10))),
                   enabledBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.black),
                       borderRadius: BorderRadius.all(Radius.circular(10))),
                   // hintText: 'Enter your product title',
                   labelStyle: TextStyle(color: Colors.grey),
                   labelText: 'Email', floatingLabelBehavior: FloatingLabelBehavior.auto),
               onSaved: (String value) {
                 Email = value;
               },
             ),
           ),

           Container(
             padding: EdgeInsets.only(top: 10, bottom: 10,left:50,right: 50),
             height:70.0,
             child: TextFormField(
               validator: _validateName,
               style: new TextStyle(color: Colors.black),
               keyboardType: TextInputType.text,
               controller: _commentController,
               decoration: InputDecoration(
                   focusedBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.black),
                       borderRadius: BorderRadius.all(Radius.circular(10))),
                   enabledBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.black),
                       borderRadius: BorderRadius.all(Radius.circular(10))),
                   // hintText: 'Enter your product title',
                   labelStyle: TextStyle(color: Colors.grey),
                   labelText: 'Comments',
                   floatingLabelBehavior: FloatingLabelBehavior.auto
               ),
               onSaved: (String value) {
                 setState(() {
                   comments = value;
                 });
               },
             ),
           ),
           Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 GestureDetector(
                   onTap: (){
                     Navigator.pop(context);
                   },
                   child: Container(
                     margin: EdgeInsets.symmetric(vertical: 20),
                     width: scrWidth * 0.35,
                     height:50,
                     decoration: BoxDecoration(
                       color: Colors.green,//Color(0xff0962ff),
                       borderRadius: BorderRadius.circular(20),
                     ),
                     child: Center(
                       child: Text(
                         'Back',
                         style: TextStyle(
                           fontFamily: 'ProductSans',
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                           color: Colors.white70,
                         ),
                       ),
                     ),
                   ),
                 ),
                 GestureDetector(
                   onTap: (){
                     _sendToServer();
                   },
                   child: Container(
                     margin: EdgeInsets.symmetric(vertical: 20),
                     width: scrWidth * 0.35,
                     height:50,
                     decoration: BoxDecoration(
                       color: Colors.green,//Color(0xff0962ff),
                       borderRadius: BorderRadius.circular(20),
                     ),
                     child: Center(
                       child: Text(
                         'Submit',
                         style: TextStyle(
                           fontFamily: 'ProductSans',
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                           color: Colors.white70,
                         ),
                       ),
                     ),
                   ),
                 ),
               ]
           ),
         ],
       ),
       ClipPath(
         clipper: OuterClippedPart(),
         child: Container(
           color: Colors.green,//Color(0xff0962ff),
           width: scrWidth,
           height: scrHeight,
         ),
       ),
       //
       ClipPath(
         clipper: InnerClippedPart(),
         child: Container(
           color: Colors.orange,//Color(0xff0c2551),
           width: scrWidth,
           height: scrHeight,
         ),
       ),
     ],
   );
  }

  String _validateName(String value) {
    if (value.length == 0) {
      return "Field is Required";
    } else {
      return null;
    }
  }
  String _validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Field is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      _datareciver(widget.user,Email,_dateController.text,_timeController.text,_commentController.text,EmailDropDownValue,widget.phone,topic,expert);
      //fetchVillageDetails();
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }

  _datareciver(String user, String email, String date, String time, String comment, String emailDropDownValue, String phone, String topic, String expert,) async {
    print(user);
    print(date);
    print(time);
    print(emailDropDownValue);
    print(comment);
    print(email);
    print(phone);
    print(topic);
    print(expert);

    var data;
    var uri = Uri.parse(
        "https://app.mapmycrop.com/handler/contact_expert.php");
    var request = new http.MultipartRequest("POST", uri);
    print(request);
    request.fields['name'] = user;
    request.fields['date'] = date.toString();
    request.fields['time'] = time.toString();
    request.fields['medium'] = emailDropDownValue;
    request.fields['comment'] = comment;
    request.fields['contact'] = phone;
    request.fields['email'] = email;
    request.fields['topic'] = topic;
    request.fields['expert'] = expert;

    var response = await request.send();
    if (response.statusCode == 200) print('Uploaded!');
    response.stream.transform(utf8.decoder).listen((value) async {
      data = jsonDecode(value);
      //datavalue=data['USER_ID'];
      print(data);
      //print(data['DATA']);
      if (data['DATA'] == 'SUCCESS') {
        //  FirebaseAnalytics.instance.logEvent(
        //   name: "Schedule_call",
        //   parameters: {
        //     "name": user,
        //     "contact": phone,
        //   },
        // );
        Fluttertoast.showToast(
            msg: " Your request for contact an expert has been sent successfully.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 12.0
        );
        Navigator.of(context).pop();
      }
       else {
         showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.red[100],
                title: Text("Invalid Data"),
                content: Text(data['DATA']),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.check,color: Colors.green,),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
      }
    });
  }
}

class OuterClippedPart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    //
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 4);
    //
    path.cubicTo(size.width * 0.55, size.height * 0.16, size.width * 0.85,
        size.height * 0.05, size.width / 2, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class InnerClippedPart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    //
    path.moveTo(size.width * 0.7, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.1);
    //
    path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.11, size.width * 0.7, 0);

    //
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}