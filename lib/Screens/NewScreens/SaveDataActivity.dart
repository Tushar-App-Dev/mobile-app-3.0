import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mmc_master/Screens/NewScreens/PlannerActivity.dart';
import 'package:mmc_master/Screens/constant/Constant.dart';
import 'package:mmc_master/Widgets/Loading.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';

class SaveDataActivity extends StatefulWidget {
  const SaveDataActivity({Key key}) : super(key: key);

  @override
  State<SaveDataActivity> createState() => _SaveDataActivityState();
}

class _SaveDataActivityState extends State<SaveDataActivity> {
  List<String> TitlelList = [
    "Tilage",
    "Planting",
    "Fertilization",
    "Spraying",
    "Harvesting",
    "Planned Cost",
    "Other"
  ];
  String TitleValue, farmValue1;
  final FocusNode TitleFocusNode = FocusNode();
  DateTime initialDate = DateTime.now();
  DateTime fromDate, toDate;
  String fromDatemon,
      fromDateyr,
      monString,
      toDatemon,
      toDateyr,
      Description,
      api_key;
  String newFromDate, newToDate, formattedFromDate, formattedToDate;
  TextEditingController _eventController = TextEditingController();
  TextEditingController _DescController = TextEditingController();
  bool _descriptionvalidate = true;
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  List<String> farmIdList = [], farmNameList = [];
  String farm = 'Farm';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFarms();
    fromDate = initialDate;
    formattedFromDate = DateFormat('dd-MM-yyyy').format(fromDate);
    newFromDate = DateFormat('yyyy-MM-dd').format(fromDate);

    toDate = initialDate;
    formattedToDate = DateFormat('dd-MM-yyyy').format(toDate);
    newToDate = DateFormat('yyyy-MM-dd').format(toDate);
  }

  void getFarms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    farmIdList.clear();
    farmNameList.clear();
    //prefs.setString('api_key', 'c39f7457e507403bae918f7996db7a68');
    api_key = prefs.getString('api_key');
    var response = await http
        .get(Uri.parse('https://api.mapmycrop.com/farm/?api_key=$api_key'));
    print(response.statusCode);
    print(response.body);
    var data = await jsonDecode(response.body);
    print(data[0]['id']);
    print(data[0]['name']);
    for (int i = 0; i < data.length; i++) {
      setState(() {
        farmIdList.add(data[i]['id']);
        farmNameList.add(data[i]['name']);
      });
    }
    print(farmIdList);
    print(farmNameList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ChangedLanguage(text:'Add Event'),
        backgroundColor: Color(0xffECB34F),
        elevation: 0.0,
        centerTitle: false,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/new_images/back.png')),
      ),
      backgroundColor: Colors.grey.shade100,
      body: Form(
        key: _key,
        child: formUI(),
      ),
    );
  }

  Widget formUI() {
   // var width = width(context);
   // var height = height(context);
    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 70.0),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1.0, style: BorderStyle.solid, color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            child: TitlelList.isNotEmpty
                ? DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      focusNode: TitleFocusNode,
                      hint: Center(child: ChangedLanguage(text:'Select Title')),
                      value: TitleValue,
                      elevation: 25,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down_circle),
                      items: TitlelList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(
                              child: Text(
                            value,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          )),
                        );
                      }).toList(),
                      onChanged: (String newvalue) {
                        setState(() {
                          TitleValue = newvalue;
                        });
                      },
                    ),
                  )
                : Center(child: Loading()),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1.0, style: BorderStyle.solid, color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            child: farmNameList.length > 0
                ? DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      focusNode: TitleFocusNode,
                      hint: Center(child: ChangedLanguage(text:'Select Farm')),
                      value: farmValue1,
                      elevation: 25,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down_circle),
                      items: farmNameList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(
                              child: Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )),
                        );
                      }).toList(),
                      onChanged: (String newvalue) {
                        setState(() {
                          int index = farmNameList.indexOf(newvalue);
                          farmValue1 = newvalue;
                          farm = farmIdList[index];
                        });
                      },
                    ),
                  )
                : Center(
                    child: Container(
                      height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1.0,
                                style: BorderStyle.solid,
                                color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        child: Loading()),
                  )),
        // Container(
        //   decoration: ShapeDecoration(
        //     shape: RoundedRectangleBorder(
        //       side: BorderSide(width: 1.0, style: BorderStyle.solid),
        //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //     ),
        //   ),
        //   child: farmNameList.length > 0
        //       ? DropdownButtonHideUnderline(
        //           child: DropdownButton<String>(
        //             focusNode: TitleFocusNode,
        //             hint: Center(child: ChangedLanguage(text:farmNameList[0])),
        //             value: farmValue1,
        //             elevation: 25,
        //             isExpanded: true,
        //             icon: Icon(Icons.arrow_drop_down_circle),
        //             items: farmNameList.map((String value) {
        //               return DropdownMenuItem<String>(
        //                 value: value,
        //                 child: Center(
        //                     child: ChangedLanguage(text:
        //                   value,
        //                   style: TextStyle(fontWeight: FontWeight.w500),
        //                 )),
        //               );
        //             }).toList(),
        //             onChanged: (String newvalue) {
        //               setState(() {
        //                 int index = farmNameList.indexOf(newvalue);
        //                 farmValue1 = newvalue;
        //                 farm = farmIdList[index];
        //               });
        //             },
        //           ),
        //         )
        //       : Center(child: CircularProgressIndicator()),
        // ),
        SizedBox(
          height: 15.0,
        ),
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ChangedLanguage(text:
                'Start date',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: "Open Sans",
                ),
              ),
            ),
            SizedBox(
              width: width(context)*0.19,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ChangedLanguage(text:
                'End date',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: "Open Sans",
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Row(children: [
            Flexible(
              flex: 1,
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 1,
                      child: MaterialButton(
                        color: Colors.white,
                        elevation: 0.0,
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: fromDate ?? initialDate,
                                  firstDate:
                                      DateTime(DateTime.now().year - 1, 5),
                                  lastDate:
                                      DateTime(DateTime.now().year + 1, 9))
                              .then((date) {
                                print(date);
                            if (date != null) {
                              setState(() {
                                fromDate = date;
                                formattedFromDate =
                                    DateFormat('dd-MM-yyyy').format(fromDate);
                                newFromDate =
                                    DateFormat('yyyy-MM-dd').format(fromDate);
                              });
                            }
                            print(formattedFromDate + "      "+newFromDate);
                          });
                        },
                        child: Icon(Icons.calendar_today),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Flexible(
                      flex: 3,
                      child: Text(
                        '$formattedFromDate',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Flexible(
              flex: 1,
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 1,
                      child: MaterialButton(
                        color: Colors.white,
                        elevation: 0.0,
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: toDate ?? initialDate,
                                  firstDate:
                                      DateTime(DateTime.now().year - 1, 5),
                                  lastDate:
                                      DateTime(DateTime.now().year + 1, 9))
                              .then((date) {
                            if (date != null) {
                              setState(() {
                                toDate = date;
                                formattedToDate =
                                    DateFormat('dd-MM-yyyy').format(toDate);
                                newToDate =
                                    DateFormat('yyyy-MM-dd').format(toDate);
                              });
                            }
                          });
                        },
                        child: Icon(Icons.calendar_today),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Flexible(
                      flex: 3,
                      child: Text(
                        '$formattedToDate',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            // validator: (String value) {
            //   if (value.isEmpty) {
            //     setState(() {
            //       _descriptionvalidate = false;
            //     });
            //   } else {
            //     setState(() {
            //       _descriptionvalidate = true;
            //     });
            //   }
            // },
            maxLines: 3,
            onSaved: (String value) {
              Description = value;
            },
            controller: _DescController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _descriptionvalidate ? Colors.black : Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _descriptionvalidate ? Colors.black : Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintText: _descriptionvalidate
                  ? 'Description'
                  : 'Description is Required',
              hintStyle: TextStyle(
                  color: _descriptionvalidate ? Colors.black : Colors.red,
                  fontFamily: "Inter"),
              // labelText: 'Email ID / Phone Number',
              //floatingLabelBehavior: FloatingLabelBehavior.auto
            ),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 120,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
                color: Color(0xff103d14),
              ),
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 23,
              //   vertical: 15,
              // ),
              child: Center(
                child: ChangedLanguage(text:
                  "Back",
                  //textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: "Open Sans",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              if (TitleValue != null) {
                if (_key.currentState.validate()) {
                  // No any error in validation
                  _key.currentState.save();
                  _datareciver(newToDate, newFromDate, TitleValue, Description);
                } else {
                  // validation error
                  setState(() {
                    _validate = true;
                  });
                }
              } else {
                // Fluttertoast.showToast(
                //     msg: "Select value from dropdown Buttom",
                //     toastLength: Toast.LENGTH_LONG,
                //     gravity: ToastGravity.BOTTOM,
                //     timeInSecForIosWeb: 1,
                //     backgroundColor: Colors.redAccent,
                //     textColor: Colors.white,
                //     fontSize: 11.0);
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  title: 'Oops...',
                  text: 'Something went wrong,Please check details and try again!',
                );
              }
            },
            child: Container(
              width: 120,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xfff7941e),
              ),
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 23,
              //   vertical: 15,
              // ),
              child: Center(
                child: ChangedLanguage(text:
                  "Save Data",
                  //textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: "Open Sans",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ])
      ]),
    );
  }

  _datareciver(String toDate, String fromDate, String titleValue,
      String description) async {
    print(fromDate);
    print(toDate);
    print(titleValue);
    print(description);

    var data, datavalue;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('userID');
    var body = {
      "farm": farm,
      "title": titleValue,
      "description": description != null ? description : 'NA',
      "start_date": fromDate.toString(),
      "end_date": toDate.toString()
    };
    print(uid);
    print("$body");

    var response = await http.post(
        Uri.parse('https://api.mapmycrop.com/calendar-data/?api_key=$api_key'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body));
    data = jsonDecode(response.body);
    print(data);
    print(response.statusCode);
    if (response.statusCode == 201 || response.statusCode == 200) {
      setState(() {
        TitleValue = null;
        _DescController.clear();
        farmValue1 = null;
      });
      // FirebaseAnalytics.instance.logEvent(
      //   name: "Planner",
      //   parameters: {
      //     "content_type": "Activity_planned",
      //     "userID": uid,
      //   },
      // );
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Activity Planned Successfully!',
          confirmBtnColor: Colors.green,
          confirmBtnText: 'OK',
          onConfirmBtnTap: () {
            Navigator.pop(context);
            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //     builder: (BuildContext context) =>PlannerActivity()));
          });
      // Fluttertoast.showToast(
      //     msg: "Planned Activity Successfully",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.green,
      //     textColor: Colors.white,
      //     fontSize: 11.0);
      //_value = _event.getEvents();
      //Navigator.pop(context);
      // _NameController.clear();
      //_DescController.clear();
      // fetchPlannerData();
    } else {
      // Fluttertoast.showToast(
      //     msg: "Not Planned Data",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.redAccent,
      //     textColor: Colors.white,
      //     fontSize: 11.0);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Something went wrong,Please check details!',
      );
    }
    //});
  }
  // _datareciver(String toDate, String fromDate, String titleValue,
  //     String description) async {
  //   print(fromDate);
  //   print(toDate);
  //   print(titleValue);
  //   print(description);
  //
  //   var data, datavalue;
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var uid = prefs.getString('userID');
  //   print(uid);
  //   var uri = Uri.parse('https://app.mapmycrop.com/calendar/api/insert.php');
  //   var request = new http.MultipartRequest("POST", uri);
  //   request.fields['userId'] = uid;
  //   request.fields['title'] = titleValue;
  //   request.fields['startDate'] = fromDate;
  //   request.fields['endDate'] = toDate;
  //   request.fields['activity'] = description;
  //
  //   print(request);
  //
  //   var response = await request.send();
  //   if (response.statusCode == 200) {
  //     print('Uploaded!');
  //     response.stream.transform(utf8.decoder).listen((value) async {
  //       data = jsonDecode(value);
  //       print(data);
  //       if (data["message"] == "Success!") {
  //         FirebaseAnalytics.instance.logEvent(
  //           name: "Planner",
  //           parameters: {
  //             "content_type": "Activity_planned",
  //             "userID": uid,
  //           },
  //         );
  //         Fluttertoast.showToast(
  //             msg: "Planned Activity Successfully",
  //             toastLength: Toast.LENGTH_LONG,
  //             gravity: ToastGravity.BOTTOM,
  //             timeInSecForIosWeb: 1,
  //             backgroundColor: Colors.green,
  //             textColor: Colors.white,
  //             fontSize: 11.0);
  //         //_value=_event.getEvents();
  //         Navigator.pop(context);
  //         // _NameController.clear();
  //         _DescController.clear();
  //         // fetchPlannerData();
  //       } else {
  //         Fluttertoast.showToast(
  //             msg: "Not Planned Data",
  //             toastLength: Toast.LENGTH_LONG,
  //             gravity: ToastGravity.BOTTOM,
  //             timeInSecForIosWeb: 1,
  //             backgroundColor: Colors.redAccent,
  //             textColor: Colors.white,
  //             fontSize: 11.0);
  //       }
  //     });
  //   }
  // }
}
