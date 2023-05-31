import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'constant/Constant.dart';

class CalendarNew extends StatefulWidget {
  @override
  _CalendarNewState createState() => _CalendarNewState();
}

class _CalendarNewState extends State<CalendarNew> {
  TextEditingController _eventController = TextEditingController();
  TextEditingController _DescController = TextEditingController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  DateTime _rangeStart;
  DateTime _rangeEnd;
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
  String TitleValue1;
  final FocusNode TitleFocusNode = FocusNode();
  // Map<DateTime, List<Event>> selectedEvents;
  var id, title, start, end, color1, textcolor, idvalue;
  var data;
  Color bgcolor;
  Future<List> _value;
  Event _event = Event();
  String tilage = 'Tilage';
  String farm = 'Farm';
  @override
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
    _value = _event.getEvents();
    // fetchPlannerData();
  }

  @override
  void dispose() {
    // _selectedEvents.dispose();
    _eventController.dispose();
    //getFarms();
    super.dispose();
  }

  void getFarms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    farmIdList.clear();
    farmNameList.clear();
    //prefs.setString('api_key', 'c39f7457e507403bae918f7996db7a68');
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
    print(farmIdList);
    print(farmNameList);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        isDaySelected = true;
        // _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: Colors.green[800],
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
          Column(
            children: [
              TableCalendar(
                firstDay: DateTime(1990),
                lastDay: DateTime(2050),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: _calendarFormat,
                // rangeSelectionMode: _rangeSelectionMode,
                //  eventLoader: _getEventsfromDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  formatButtonTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onDaySelected: _onDaySelected,
                // onRangeSelected: _onRangeSelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              FutureBuilder<List<Event>>(
                  future: _value,
                  builder: (context, AsyncSnapshot<List<Event>> snapshot) {
                    return snapshot.hasData
                        ? Container(
                            height: height(context) * 0.45,
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  if (snapshot.data[index].title ==
                                      'Planting') {
                                    bgcolor = Color(0xFF73b273);
                                    textcolor = Color(0xFFffffff);
                                  } else if (snapshot.data[index].title ==
                                      'Harvesting') {
                                    bgcolor = Color(0xFFea7617);
                                    textcolor = Color(0xFFffffff);
                                  } else if (snapshot.data[index].title ==
                                      'Fertilization') {
                                    bgcolor = Color(0xFF7156b3);
                                    textcolor = Color(0xFFffffff);
                                  } else if (snapshot.data[index].title ==
                                      'Spraying') {
                                    bgcolor = Color(0xFF71a5c6);
                                    textcolor = Color(0xFFffffff);
                                  } else if (snapshot.data[index].title ==
                                      'Tillage') {
                                    bgcolor = Color(0xFFdb392a);
                                    textcolor = Color(0xFFffffff);
                                  } else {
                                    bgcolor = Color(0xFF73b273);
                                    textcolor = Color(0xFFffffff);
                                  }
                                  return snapshot.data[index].start
                                              .toString()
                                              .substring(0, 10) ==
                                          _selectedDay
                                              .toString()
                                              .substring(0, 10)
                                      ? Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: bgcolor,
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: ListTile(
                                            onTap: () => print(
                                                '${snapshot.data[index].title}'),
                                            leading: Container(
                                              height: 40.0,
                                              width: 40.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              child: CircleAvatar(
                                                radius: 30.0,
                                                child: Text(
                                                    '${snapshot.data[index].start.toString().substring(8, 10)}'),
                                                backgroundColor: Colors.white,
                                              ), //Text('${data[index]['start'].toString().substring(8,10)}'),
                                            ),
                                            title: Text(
                                              '${snapshot.data[index].title}',
                                              style: TextStyle(
                                                  color: Color(0xFFffffff)),
                                            ),
                                            subtitle: Text(
                                              '${snapshot.data[index].start.toString().substring(0, 10)}  to  ${snapshot.data[index].end.toString().substring(0, 10)}',
                                              style: TextStyle(
                                                  color: Color(0xFFffffff)),
                                            ),
                                            trailing: IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () async {
                                                  return showDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      builder: (BuildContext
                                                          context) {
                                                        return StatefulBuilder(
                                                            builder: (BuildContext
                                                                    context,
                                                                StateSetter
                                                                    setState) {
                                                          return AlertDialog(
                                                            content:
                                                                new SingleChildScrollView(
                                                              child:
                                                                  new ListBody(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    'Do you really want to delete this event.',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w300,
                                                                        fontSize:
                                                                            18.0),
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        15.0,
                                                                  ),
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        MaterialButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text('Close'),
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                        MaterialButton(
                                                                          onPressed:
                                                                              () {
                                                                            _deleteEvent('${snapshot.data[index].id}');
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text('Delete'),
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                      ]),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                      });
                                                }),
                                          ),
                                        )
                                      : Container();
                                }))
                        : Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 250, 8, 10),
                              child: Text(
                                "No Data Found",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ));
                  }),
            ],
          ),
        ]),
      ),
      floatingActionButton: Visibility(
        visible: isDaySelected,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.redAccent,
          label: Text("Add Event"),
          icon: Icon(Icons.add),
          onPressed: () => showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[
                          Text(
                            'Add Event',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20.0),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1.0, style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            child: TitlelList.length > 0
                                ? DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      focusNode: TitleFocusNode,
                                      hint: Center(child: Text(TitlelList[0])),
                                      value: TitleValue,
                                      elevation: 25,
                                      isExpanded: true,
                                      icon: Icon(Icons.arrow_drop_down_circle),
                                      items: TitlelList.map((String value) {
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
                                          TitleValue = newvalue;
                                        });
                                      },
                                    ),
                                  )
                                : Center(child: CircularProgressIndicator()),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1.0, style: BorderStyle.solid),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            child: farmNameList.length > 0
                                ? DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                focusNode: TitleFocusNode,
                                hint: Center(child: Text(farmNameList[0])),
                                value: TitleValue1,
                                elevation: 25,
                                isExpanded: true,
                                icon: Icon(Icons.arrow_drop_down_circle),
                                items: farmNameList.map((String value) {
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
                                    int index = farmNameList.indexOf(newvalue);
                                    TitleValue1 = newvalue;
                                    farm = farmIdList[index];
                                  });
                                },
                              ),
                            )
                                : Center(child: CircularProgressIndicator()),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text("Start Date:"),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            decoration: ShapeDecoration(
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
                                    child: Icon(Icons.calendar_today),
                                  ),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Text(
                                    '$formattedFromDate',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text("End Date:"),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            decoration: ShapeDecoration(
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
                                    child: Icon(Icons.calendar_today),
                                  ),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Text(
                                    '$formattedToDate',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),

                          TextField(
                            onChanged: (value) {
                              setState(() {
                                Description = value;
                              });
                            },
                            controller: _DescController,
                            decoration: InputDecoration(
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
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Close'),
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
                                  child: Text('Save Data'),
                                  color: Colors.blue,
                                ),
                              ]),
                        ],
                      ),
                    ),
                  );
                });
              }),
        ),
      ),
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
      // _NameController.clear();
      _DescController.clear();
      // fetchPlannerData();
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
    //});
  }
}

_deleteEvent(String ID) async {
  print(ID);

  var data, datavalue;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var uid = prefs.getString('userID');
  print(uid);
  var uri = Uri.parse('https://app.mapmycrop.com/calendar/api/delete.php');
  var request = http.MultipartRequest("POST", uri);
  // request.fields['userId'] = uid;
  request.fields['id'] = ID;

  print(request);

  var response = await request.send();
  if (response.statusCode == 200) {

  }
}

class Event {
  String id, title, start, end, backgroundColor, textColor;
  static List<Event> event = [];

  Event(
      {this.id,
      this.title,
      this.start,
      this.end,
      this.backgroundColor,
      this.textColor});

  Future<List<Event>> getEvents() async {
    event.clear();
    var uid, data, datavalue;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('userID');
    var uri = Uri.parse("https://app.mapmycrop.com/calendar/api/load.php");
    var request = http.MultipartRequest("POST", uri);
    request.fields['userid'] = uid;

    print(request);

    var response = await request.send().timeout(const Duration(minutes: 2));
    if (response.statusCode == 200) print('Uploaded!');
    response.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .listen((value) async {
      data = value;
      print(data);
      for (var i = 0; i < data.length; i++) {
        event.add(
          Event(
            id: data[i]["id"],
            title: data[i]["title"],
            start: data[i]["start"],
            end: data[i]["end"],
            backgroundColor: data[i]["backgroundColor"],
            textColor: data[i]["textColor"],
          ),
        );
      }
    });
    return event;
  }
}
