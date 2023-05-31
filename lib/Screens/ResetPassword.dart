import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  bool _validate = false;
  String pwd;
  String uid;

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  void fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('userID');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('Reset Password', style: TextStyle(color:Colors.black),),
        iconTheme: const IconThemeData(color:Colors.black),
        backgroundColor:Colors.white,
        elevation: 0.0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
            //validator:_validateEmail,
            style: const TextStyle(color: Colors.black),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                // hintText: 'Enter your product title',
                labelStyle: TextStyle(color: Colors.grey),
                labelText: 'Enter New Password', floatingLabelBehavior: FloatingLabelBehavior.auto),
            onSaved: (String value) {
              pwd = value;
            },
        ),
          ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: MaterialButton(
                color: Colors.green[800],
                onPressed: () {
                    _sendToServer();
                },
                child:  const Text('Submit',style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return "Field is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }


  _sendToServer() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _dataSend(pwd);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  _dataSend(String pwd) async {
    print(pwd);
    var data,datavalue;
    var uri = Uri.parse(
        "https://app.mapmycrop.com/handler/user_manager.php");
    var request = http.MultipartRequest("POST", uri);
    print(request);
    request.fields['pwd'] = pwd;
    request.fields['uid'] = uid;
    request.fields['type'] = "CHANGE_PWD";
    var response = await request.send();
    if (response.statusCode == 200) print('Uploaded!');
    response.stream.transform(utf8.decoder).listen((value) async {
      data = jsonDecode(value);
      print(data);
      if (data['DATA'] == 'SUCCESS') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userID', datavalue.toString());
        Navigator.pop(context);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.red[100],
                title: const Text("Invalid Credentials"),
                content: Text(data['DATA']),
                actions: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.check),
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