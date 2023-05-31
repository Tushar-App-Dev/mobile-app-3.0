import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mmc_master/Screens/NewScreens/ScoutingActivity.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../constants/constants.dart';
import 'CropDetails.dart';

class ScoutingDataSaveActivity extends StatefulWidget {
  final String lat;
  final String lng;
  final String farmid;
  const ScoutingDataSaveActivity({Key key, this.lat, this.lng, this.farmid}) : super(key: key);

  @override
  State<ScoutingDataSaveActivity> createState() => _ScoutingDataSaveActivityState();
}

class _ScoutingDataSaveActivityState extends State<ScoutingDataSaveActivity> {

  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String topic,comments, api_key,farm,farmId,attachment;
  List<String> farmIdList = [], farmNameList = [];
  List<String> topicList = [
    'Disease',
    'Weeds',
    'Lodging',
    'Waterlogging',
    'Other',
    'Pests'
  ];
  bool _commentvalidate=true;
  TextEditingController _commentController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    getFarms();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //print(attachment.replaceAll("\"", ""));
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text('Save Field Data'),
          backgroundColor: Color(0xffECB34F),
          elevation: 0.0,
        ),
        backgroundColor:Colors.grey.shade200,
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
    var scrWidth = MediaQuery
        .of(context)
        .size
        .width;
    var scrHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0,top: 20),
              child: Text("Note Type ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize:16),),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                height: 50.0,
                decoration: ShapeDecoration(
                  color:Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    //focusNode: emailIDFocusNode,
                    //dropdownColor:Color(0xffECB34F),
                    hint: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('Type',style: TextStyle(color: Colors.black),),
                    ),
                    value: topic,
                    elevation: 25,
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down,color: Colors.black,),
                    items: topicList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left:15.0),
                          child: Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String newvalue) {
                      setState(() {
                        // FocusScope.of(context).requestFocus(new FocusNode());
                        topic = newvalue;
                        // getVillageData(zoneDropDownValue);
                      });
                    },
                  ),
                )),
            // Container(
            //     margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            //     height: 50.0,
            //     decoration: ShapeDecoration(
            //       color:Color(0xffECB34F),
            //       shape: RoundedRectangleBorder(
            //         side: BorderSide(width: 1.0, style: BorderStyle.solid),
            //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //       ),
            //     ),
            //     child: DropdownButtonHideUnderline(
            //       child: DropdownButton<String>(
            //         //focusNode: emailIDFocusNode,
            //         dropdownColor:Color(0xffECB34F),
            //         hint: Padding(
            //           padding: const EdgeInsets.only(left: 8.0),
            //           child: Text('Farm',style: TextStyle(color: Colors.white),),
            //         ),
            //         value: farm,
            //         elevation: 25,
            //         isExpanded: true,
            //         icon: Icon(Icons.keyboard_arrow_down,color: Colors.white,),
            //         items: farmNameList.map((String value) {
            //           return DropdownMenuItem<String>(
            //             value: value,
            //             child: Padding(
            //               padding: const EdgeInsets.only(left:15.0),
            //               child: Text(
            //                 value,
            //                 style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),
            //               ),
            //             ),
            //           );
            //         }).toList(),
            //         onChanged: (String newvalue) {
            //           setState(() {
            //             var index = farmNameList.indexOf(newvalue);
            //             // FocusScope.of(context).requestFocus(new FocusNode());
            //             farmId = farmIdList[index];
            //             farm = newvalue;
            //             // getVillageData(zoneDropDownValue);
            //           });
            //         },
            //       ),
            //     )),
            Container(
              padding:
              EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
              height: 70.0,
              child: TextFormField(
                //validator: _validateName,
                style: new TextStyle(color: Colors.black),
                keyboardType: TextInputType.text,
                controller: _commentController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: _commentvalidate ? 'Comment' : 'Comment required',
                  hintStyle: TextStyle(
                      color: _commentvalidate ? Colors.black : Colors.red),
                ),
                onSaved: (String value) {
                  setState(() {
                    comments = value;
                  }
                  );
                },
                validator: (String value) {
                  if (value.isEmpty) {
                    setState(() {
                      _commentvalidate = false;
                    });
                  } else {
                    setState(() {
                      _commentvalidate = true;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: IconButton(
                      iconSize: 23,
                      icon: const Icon(
                        FontAwesomeIcons.camera,
                        color: Colors.black54,
                      ),
                      onPressed: () async {
                        uploadImage(ImageSource.camera);
                      },
                    ),
                  ),
                  SizedBox(width: 20,),
                  Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: IconButton(
                      iconSize: 23,
                      icon: const Icon(
                        Icons.image,
                        color: Colors.black54,
                      ),
                      onPressed: () async {
                        uploadImage(ImageSource.gallery);
                      },
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Text('Select from gallary'),
                  // )
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                if(topic!=null && _commentController.text.isNotEmpty){
                  _datareciver(topic, _commentController.text);
                }
                else {
                  Fluttertoast.showToast(
                      msg: "Select Note type And Add Comment",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 15.0);
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0,vertical:10),
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0XFFF7941E),
                ),
                //padding: const EdgeInsets.only(left: 91, right: 122, top: 20, bottom: 19, ),
                child:  Center(
                  child: Text(
                    "Save",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  uploadImage(ImageSource imageSource) async {
    var image = await ImagePicker().pickImage(source: imageSource);
    var responseValue = '';

    var request = http.MultipartRequest('POST', Uri.parse(
        'https://api.mapmycrop.store/upload/?api_key=$api_key'));

    request.files.add(await http.MultipartFile.fromPath('file', image.path, contentType: MediaType("image", 'png')));
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) async {

      print(value);
      setState(() {
        responseValue= value;
        attachment = value;
      });
      /*if(value.isNotEmpty){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CropDetails(data:responseValue)));
      }*/
      //print(value);
    });
    /*if(responseValue.isNotEmpty){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CropDetails(data:responseValue)));
    }*/
  }

  void getFarms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    farmIdList.clear();
    farmNameList.clear();
    api_key = prefs.getString('api_key');
    var response = await http
        .get(Uri.parse('http://api.mapmycrop.store/farm/?api_key=$api_key'));
    print(response.statusCode);
    print(response.body);
    var data = await jsonDecode(response.body);
    print(data['features'][0]['properties']['id']);
    print(data['features'][0]['properties']['name']);
    for (int i = 0; i < data['features'].length; i++) {
      setState(() {
        farmIdList.add(data['features'][i]['properties']['id']);
        farmNameList.add(data['features'][i]['properties']['name']);
      });
    }
  }

  _datareciver(String type, String desc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var api_key = prefs.getString('api_key');

    print(desc);
    print(type);

    var body = {
      "farm": widget.farmid,
      "geometry": "POINT(${widget.lng} ${widget.lat})",
      "note_type": topic,
      "comments": comments,
      "attachment": attachment.replaceAll("\"", "")
    };
    var response = await http.post(Uri.parse('https://api.mapmycrop.store/scouting/?api_key=$api_key'),headers: {
      'accept': "application/json",
      'Content-Type': "application/json"
    },body: jsonEncode(body));

    print('the response is ${response.statusCode} and body is ${response.body}');


    if (response.statusCode == 201) {
      // FirebaseAnalytics.instance.logEvent(
      //   name: "Scouting",
      //   parameters: {
      //     "pagename":"Add_markers",
      //     //"userID":uid,
      //   },
      // );
      print('Uploaded!');
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: await changeLanguage('Scouting added Successfully!'),
        confirmBtnColor: Colors.green,
        confirmBtnText:await changeLanguage('OK'),
          onConfirmBtnTap:(){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ScoutingActivity()));
         }
      );
      // Fluttertoast.showToast(
      //     msg: "Data Successfully Saved",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.SNACKBAR,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor:Color(0xffECB34F),
      //     textColor: Colors.white,
      //     fontSize: 15.0);
      // //isMarkerOn=false;
      // Navigator.pop(context);
      // //fetchMarkersData();
    }
    else{
      Fluttertoast.showToast(
          msg: "Data Not Saved",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.red,
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }
}