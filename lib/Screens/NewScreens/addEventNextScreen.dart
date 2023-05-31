import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

import '../AddEventNew.dart';

class AddEventNextScreen extends StatefulWidget {
  const AddEventNextScreen({Key key}) : super(key: key);

  @override
  State<AddEventNextScreen> createState() => _AddEventNextScreenState();
}

class _AddEventNextScreenState extends State<AddEventNextScreen> {

  TextEditingController _DescController = TextEditingController();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  bool isDaySelected = false;
  bool isRangeSelected = false;
  DateTime initialDate = DateTime.now();
  DateTime fromDate, toDate;
  String fromDatemon,
      fromDateyr,
      monString,
      toDatemon,
      toDateyr,
      Description,
      api_key,
      farmValue;
  String newFromDate, newToDate, formattedFromDate, formattedToDate;
  List<String> TitlelList = [
    "Tilage",
    "Planting",
    "Fertilization",
    "Spraying",
    "Harvesting",
    "Planned Cost",
    "Other"
  ];
  List<String> farmIdList = [], farmNameList = [];
  String TitleValue;
  final FocusNode TitleFocusNode = FocusNode();
  // Map<DateTime, List<Event>> selectedEvents;
  var id, title, start, end, color1, textcolor, idvalue;
  var data;
  Color bgcolor;
  Future<List> _value;
  Event _event = Event();
  String tilage = 'Tilage';
  String farm = 'Farm';
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
      "farm": farmValue,
      "title": titleValue,
      "description": description,
      "start_date": fromDate.toString(),
      "end_date": toDate.toString()
    };
    print(uid);
    print("$body");


    var response = await http.post(
        Uri.parse('http://api.mapmycrop.store/calendar-data/?api_key=$api_key'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body));
    data = jsonDecode(response.body);
    print(data);
    print(response.statusCode);
    if (response.statusCode == 201) {
      // FirebaseAnalytics.instance.logEvent(
      //   name: "Planner",
      //   parameters: {
      //     "content_type": "Activity_planned",
      //     "userID": uid,
      //   },
      // );
      Fluttertoast.showToast(
          msg: "Planned Activity Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 11.0);
      _value = _event.getEvents();
      Navigator.pop(context);

      _DescController.clear();
    } else {
      Fluttertoast.showToast(
          msg: "Not Planned Data",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 11.0);
    }
  }
  void initState() {
    super.initState();
    getFarms();
    _selectedDay = _focusedDay;
    fromDate = initialDate;
    formattedFromDate = DateFormat('dd-MM-yyyy').format(fromDate);
    newFromDate = DateFormat('yyyy-MM-dd').format(fromDate);

    toDate = initialDate;
    formattedToDate = DateFormat('dd-MM-yyyy').format(toDate);
    newToDate = DateFormat('yyyy-MM-dd').format(toDate);
    // selectedEvents = {};
    //_value = _event.getEvents();
    // fetchPlannerData();
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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          const Text(
            'Add Event',
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 20.0),
          ),
          const SizedBox(
            height: 15.0,
          ),
          DropdownButton(
              value: 'farm',
              items:
              farmNameList.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: new Text(item),
                );
              }).toList(),
              onChanged: (value) {}),
          Container(
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1.0, style: BorderStyle.solid),
                  borderRadius:
                  BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              child: DropdownButton(
                  value: tilage,
                  items: TitlelList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (value) {})),
          const SizedBox(
            height: 10.0,
          ),
          const Text("Start Date:"),
          const SizedBox(
            height: 5.0,
          ),
          Container(
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1.0, style: BorderStyle.solid),
                borderRadius:
                BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 1,
                  child: MaterialButton(
                    onPressed: () {
                      showDatePicker(
                          context: context,
                          initialDate:
                          fromDate ?? initialDate,
                          firstDate: DateTime(
                              DateTime.now().year - 1, 5),
                          lastDate: DateTime(
                              DateTime.now().year + 1, 9))
                          .then((date) {
                        if (date != null) {
                          setState(() {
                            fromDate = date;
                            formattedFromDate =
                                DateFormat('dd-MM-yyyy')
                                    .format(fromDate);
                            newFromDate =
                                DateFormat('yyyy-MM-dd')
                                    .format(fromDate);
                          });
                        }
                      });
                    },
                    child: const Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Flexible(
                  flex: 3,
                  child: Text(
                    '$formattedFromDate',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Text("End Date:"),
          const SizedBox(
            height: 5.0,
          ),
          Container(
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1.0, style: BorderStyle.solid),
                borderRadius:
                BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 1,
                  child: MaterialButton(
                    onPressed: () {
                      showDatePicker(
                          context: context,
                          initialDate:
                          toDate ?? initialDate,
                          firstDate: DateTime(
                              DateTime.now().year - 1, 5),
                          lastDate: DateTime(
                              DateTime.now().year + 1, 9))
                          .then((date) {
                        if (date != null) {
                          setState(() {
                            toDate = date;
                            formattedToDate =
                                DateFormat('dd-MM-yyyy')
                                    .format(toDate);
                            newToDate = DateFormat('yyyy-MM-dd')
                                .format(toDate);
                          });
                        }
                      });
                    },
                    child: const Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Flexible(
                  flex: 3,
                  child: Text(
                    '$formattedToDate',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                Description = value;
              });
            },
            controller: _DescController,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius:
                  BorderRadius.all(Radius.circular(10))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius:
                  BorderRadius.all(Radius.circular(10))),
              // hintText: 'Enter your product title',
              labelStyle: TextStyle(color: Colors.black),
              labelText: 'Description',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                  color: Colors.blue,
                ),
                MaterialButton(
                  onPressed: () {
                    if (newToDate != null &&
                        newFromDate != null &&
                        TitleValue != null &&
                        Description != null) {
                      print(newToDate);
                      print(newFromDate);
                      print(TitleValue);
                      print(Description);
                      // Navigator.pop(context);
                      _datareciver(newToDate, newFromDate,
                          TitleValue, Description);
                    } else {
                      Fluttertoast.showToast(
                          msg:
                          "Description, newToDate,newFromDate,TitleValue Should not be empty",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 12.0);
                    }
                  },
                  child: const Text('Save Data'),
                  color: Colors.blue,
                ),
              ]),
        ],
      ),
    );
  }
}
