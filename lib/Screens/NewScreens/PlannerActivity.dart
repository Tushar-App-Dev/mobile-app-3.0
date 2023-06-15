import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mmc_master/Widgets/Loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constants/constants.dart';
import 'SaveDataActivity.dart';

class PlannerActivity extends StatefulWidget {
  const PlannerActivity({Key key}) : super(key: key);

  @override
  State<PlannerActivity> createState() => _PlannerActivityState();
}

class _PlannerActivityState extends State<PlannerActivity> {
//   TextEditingController _eventController = TextEditingController();
//   TextEditingController _DescController = TextEditingController();
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
//   DateTime _focusedDay = DateTime.now();
//   DateTime _selectedDay;
//   DateTime _rangeStart;
//   DateTime  _rangeEnd;
//   bool isDaySelected=true;
//   bool isRangeSelected=false;
//   DateTime initialDate = DateTime.now();
//   DateTime fromDate, toDate;
//   String fromDatemon, fromDateyr, monString, toDatemon, toDateyr,Description;
//   String newFromDate, newToDate, formattedFromDate, formattedToDate;
//   List<String> TitlelList = ['Tillage','Planting','Fertilization','Spraying','Harvesting','Planned Cost','Other'];
//   String TitleValue;
//   final FocusNode TitleFocusNode = FocusNode();
//   // Map<DateTime, List<Event>> selectedEvents;
//   var id,title,start,end,color1,textcolor,idvalue;
//   var data;
//   Color bgcolor;
//   Future<List> _value;
//   Event _event = new Event();
//
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = _focusedDay;
//     fromDate = initialDate;
//     formattedFromDate = DateFormat('dd-MM-yyyy').format(fromDate);
//     newFromDate = DateFormat('yyyy-MM-dd').format(fromDate);
//
//     toDate = initialDate;
//     formattedToDate = DateFormat('dd-MM-yyyy').format(toDate);
//     newToDate = DateFormat('yyyy-MM-dd').format(toDate);
//     // selectedEvents = {};
//     _value=_event.getEvents();
//     // fetchPlannerData();
//   }
//
//   @override
//   void dispose() {
//     // _selectedEvents.dispose();
//     _eventController.dispose();
//     super.dispose();
//   }
//
//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     if (!isSameDay(_selectedDay, selectedDay)) {
//       setState(() {
//         _selectedDay = selectedDay;
//         _focusedDay = focusedDay;
//         _rangeStart = null; // Important to clean those
//         _rangeEnd = null;
//         isDaySelected = true;
//         // _rangeSelectionMode = RangeSelectionMode.toggledOff;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: ChangedLanguage(text:'Calendar'),
//         backgroundColor: Color(0xffECB34F),
//       ),
//       body: SingleChildScrollView(
//         child: Stack(
//             children: [
//               Column(
//                 children: [
//                   Card(
//                     elevation: 2.0,
//                     child: TableCalendar(
//                       firstDay: DateTime(1990),
//                       lastDay: DateTime(2050),
//                       focusedDay: _focusedDay,
//                       selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                       rangeStartDay: _rangeStart,
//                       rangeEndDay: _rangeEnd,
//                       calendarFormat: _calendarFormat,
//                       // rangeSelectionMode: _rangeSelectionMode,
//                       //  eventLoader: _getEventsfromDay,
//                       startingDayOfWeek: StartingDayOfWeek.monday,
//                       calendarStyle: CalendarStyle(
//                         outsideDaysVisible: false,
//                       ),
//                       headerStyle: HeaderStyle(
//                         formatButtonVisible: true,
//                         titleCentered: true,
//                         formatButtonShowsNext: false,
//                         formatButtonDecoration: BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         formatButtonTextStyle: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                       onDaySelected: _onDaySelected,
//                       // onRangeSelected: _onRangeSelected,
//                       onFormatChanged: (format) {
//                         if (_calendarFormat != format) {
//                           setState(() {
//                             _calendarFormat = format;
//                           });
//                         }
//                       },
//                       onPageChanged: (focusedDay) {
//                         _focusedDay = focusedDay;
//                       },
//                     ),
//                   ),
//                   FutureBuilder<List<Event>>(
//                       future:_value,
//                       builder: (context, AsyncSnapshot<List<Event>> snapshot) {
//                         return snapshot.hasData
//                             ?Container(
//                             height: height(context)*0.45,
//                             child: ListView.builder(
//                                 itemCount: snapshot.data.length,
//                                 itemBuilder: (context, index) {
//                                   if(snapshot.data[index].title=='Planting'){
//                                     bgcolor=Color(0xFF73b273);
//                                     textcolor=Color(0xFFffffff);
//                                   }
//                                   else if(snapshot.data[index].title=='Harvesting'){
//                                     bgcolor=Color(0xFFea7617);
//                                     textcolor=Color(0xFFffffff);
//                                   }
//                                   else if(snapshot.data[index].title=='Fertilization'){
//                                     bgcolor=Color(0xFF7156b3);
//                                     textcolor=Color(0xFFffffff);
//                                   }
//                                   else if(snapshot.data[index].title=='Spraying'){
//                                     bgcolor=Color(0xFF71a5c6);
//                                     textcolor=Color(0xFFffffff);
//                                   }
//                                   else if(snapshot.data[index].title=='Tillage'){
//                                     bgcolor=Color(0xFFdb392a);
//                                     textcolor=Color(0xFFffffff);
//                                   }
//                                   else{
//                                     bgcolor=Color(0xFF73b273);
//                                     textcolor=Color(0xFFffffff);
//                                   }
//                                   return snapshot.data[index].start.toString().substring(0,10)==_selectedDay.toString().substring(0,10)?Container(
//                                     margin: const EdgeInsets.symmetric(
//                                       horizontal: 12.0,
//                                       vertical: 4.0,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color:bgcolor,
//                                       border: Border.all(),
//                                       borderRadius: BorderRadius.circular(12.0),
//                                     ),
//                                     child: ListTile(
//                                       onTap: () => print('${snapshot.data[index].title}'),
//                                       leading: Container(
//                                         height: 40.0,
//                                         width: 40.0,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(30.0),
//                                         ),
//                                         child: CircleAvatar(
//                                           radius:30.0,
//                                           child: ChangedLanguage(text:'${snapshot.data[index].start.toString().substring(8,10)}'),
//                                           backgroundColor:Colors.white,
//                                         ),//ChangedLanguage(text:'${data[index]['start'].toString().substring(8,10)}'),
//                                       ),
//                                       title: ChangedLanguage(text:'${snapshot.data[index].title}',style: TextStyle(color:Color(0xFFffffff)),),
//                                       subtitle: ChangedLanguage(text:'${snapshot.data[index].start.toString().substring(0,10)}  to  ${snapshot.data[index].end.toString().substring(0,10)}',style: TextStyle(color:Color(0xFFffffff)),),
//                                       trailing:IconButton(
//                                           icon: Icon(
//                                             Icons.delete,
//                                             color:Colors.white,
//                                           ),
//                                           onPressed: () async {
//                                             return showDialog(
//                                                 context: context,
//                                                 barrierDismissible: true,
//                                                 builder: (BuildContext context) {
//                                                   return StatefulBuilder(
//                                                       builder: (BuildContext context,
//                                                           StateSetter setState) {
//                                                         return AlertDialog(
//                                                           content: new SingleChildScrollView(
//                                                             child: new ListBody(
//                                                               children: <Widget>[
//                                                                 ChangedLanguage(text:'Do you really want to delete this event.',
//                                                                   style: TextStyle(
//                                                                       fontWeight: FontWeight.w300,
//                                                                       fontSize: 18.0),),
//                                                                 SizedBox(
//                                                                   height: 15.0,
//                                                                 ),
//                                                                 Row(
//                                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                     children:[
//                                                                       MaterialButton(
//                                                                         onPressed: () {
//                                                                           Navigator.pop(context);
//                                                                         },
//                                                                         child: ChangedLanguage(text:'Close',style: TextStyle(color: Colors.white)),
//                                                                         color: Colors.deepOrangeAccent,
//                                                                       ),
//                                                                       MaterialButton(
//                                                                         onPressed: () {
//                                                                           _deleteEvent('${snapshot.data[index].id}');
//                                                                           Navigator.pop(context);
//                                                                         },
//                                                                         child: ChangedLanguage(text:'Delete',style: TextStyle(color: Colors.white),),
//                                                                         color: Color(0xff103d14),
//                                                                       ),
//                                                                     ]
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         );
//                                                       }
//                                                   );
//                                                 });
//                                           }
//                                       ),
//                                     ),
//                                   ):Container();
//                                 }
//                             )
//                         ): Container(
//                           height: height(context)*0.45,
//                           child: Center(
//                             child: ChangedLanguage(text:
//                               "No Data Found",
//                               style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight:
//                                   FontWeight.w500),
//                             ),
//                           ),
//                         );
//                       }),
//                 ],
//               ),
//             ]
//         ),
//       ),
//         floatingActionButton:Visibility(
//           visible: isDaySelected,
//           child: GestureDetector(
//             onTap:(){
//               Navigator.push(context, MaterialPageRoute(builder:(context)=>SaveDataActivity()));
//             },
//             child: Container(
//               margin: EdgeInsets.symmetric(horizontal: 20.0),
//               width: 316,
//               height: 57,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 color: Color(0xff103d14),
//               ),
//               padding: const EdgeInsets.only(left: 91, right: 122, top: 20, bottom: 19, ),
//               child:  ChangedLanguage(text:
//                 "Add Event",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontFamily: "Inter",
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         )
//     );
//   }
//
//   _datareciver(String toDate, String fromDate, String titleValue, String description) async {
//     print(fromDate);
//     print(toDate);
//     print(titleValue);
//     print(description);
//
//     var data, datavalue;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var uid = prefs.getString('userID');
//     print(uid);
//     var uri = Uri.parse(
//         'https://app.mapmycrop.com/calendar/api/insert.php');
//     var request = new http.MultipartRequest("POST", uri);
//     request.fields['userId'] = uid;
//     request.fields['title'] = titleValue;
//     request.fields['startDate'] = fromDate;
//     request.fields['endDate'] =toDate;
//     request.fields['activity'] = description;
//
//     print(request);
//
//     var response = await request.send();
//     if (response.statusCode == 200) {
//       print('Uploaded!');
//       response.stream.transform(utf8.decoder).listen((value) async {
//         data = jsonDecode(value);
//         print(data);
//         if (data["message"] == "Success!" ) {
//           FirebaseAnalytics.instance.logEvent(
//             name: "Planner",
//             parameters: {
//               "content_type": "Activity_planned",
//               "userID": uid,
//             },
//           );
//           Fluttertoast.showToast(
//               msg: "Planned Activity Successfully",
//               toastLength: Toast.LENGTH_LONG,
//               gravity: ToastGravity.BOTTOM,
//               timeInSecForIosWeb: 1,
//               backgroundColor: Colors.green,
//               textColor: Colors.white,
//               fontSize: 11.0
//           );
//           _value=_event.getEvents();
//           Navigator.pop(context);
//           // _NameController.clear();
//           _DescController.clear();
//           // fetchPlannerData();
//         }
//         else{
//           Fluttertoast.showToast(
//               msg: "Not Planned Data",
//               toastLength: Toast.LENGTH_LONG,
//               gravity: ToastGravity.BOTTOM,
//               timeInSecForIosWeb: 1,
//               backgroundColor: Colors.redAccent,
//               textColor: Colors.white,
//               fontSize: 11.0
//           );
//         }
//       });
//     }
//   }
//
//   _deleteEvent(String ID) async {
//     print(ID);
//
//     var data, datavalue;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var uid = prefs.getString('userID');
//     print(uid);
//     var uri = Uri.parse(
//         'https://app.mapmycrop.com/calendar/api/delete.php');
//     var request = new http.MultipartRequest("POST", uri);
//     // request.fields['userId'] = uid;
//     request.fields['id'] = ID;
//
//     print(request);
//
//     var response = await request.send();
//     if (response.statusCode == 200) {
//       setState(() {
//         _value=_event.getEvents();
//         print('Uploaded!');
//         Fluttertoast.showToast(
//             msg: "Activity Deleted Successfully",
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.BOTTOM,
//             timeInSecForIosWeb: 1,
//             backgroundColor: Colors.green,
//             textColor: Colors.white,
//             fontSize: 12.0
//         );
//       });
//     }
//   }
// }

// class Event {
//   String id,
//       title,
//       start,
//       end,
//       backgroundColor,
//       textColor;
//   static List<Event> event = [];
//
//   Event(
//       {
//         this.id,
//         this.title,
//         this.start,
//         this.end,
//         this.backgroundColor,
//         this.textColor
//       });
//
//   Future<List<Event>> getEvents() async {
//     event.clear();
//     var uid,data, datavalue;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     uid = prefs.getString('userID');
//     var uri = Uri.parse(
//         "https://app.mapmycrop.com/calendar/api/load.php");
//     var request = new http.MultipartRequest("POST", uri);
//     request.fields['userid'] = uid;
//
//     print(request);
//
//     var response = await request.send().timeout(const Duration(minutes: 2));
//     if (response.statusCode == 200) print('Uploaded!');
//     response.stream.transform(utf8.decoder).transform(json.decoder).listen((value) async {
//       data = value;
//       print(data);
//       for (var i = 0; i < data.length; i++) {
//         event.add(
//           Event(
//             id: data[i]["id"],
//             title: data[i]["title"],
//             start: data[i]["start"],
//             end: data[i]["end"],
//             backgroundColor: data[i]["backgroundColor"],
//             textColor: data[i]["textColor"],
//           ),
//         );
//       }
//     });
//     return event;
//   }
// }
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
  List eventList = [], alleventList = [];
  String TitleValue;
  String TitleValue1;
  final FocusNode TitleFocusNode = FocusNode();

  // Map<DateTime, List<Event>> selectedEvents;
  var id, title, start, end, color1, textcolor, idvalue;
  var data;
  Color bgcolor;
  Color dotcolor = Color(0xFFdb392a);
  Future<List> _value;
  Event _event = Event();
  String tilage = 'Tilage';
  String farm = 'select farm';

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
    getAllEvents();
    print(farmIdList);
    print(farmNameList);
  }

  getAllEvents() async {
    for (int i = 0; i < farmIdList.length; i++) {
      var response = await http.get(Uri.parse(
          'https://api.mapmycrop.com/calendar-data/${farmIdList[i]}?api_key=$api_key'));
      print(response.body);

      setState(() {
        var data = jsonDecode(response.body);
        alleventList.addAll(data);
      });
    }
    print(alleventList);
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

  List listOfDayEvents(DateTime dateTime) {
    var temp = [];
    for (int i = 0; i < eventList.length; i++) {
      // print(alleventList[i]['start_date']);
      // print(dateTime.toString().substring(0, 10));
      if (eventList[i]['start_date'] == dateTime.toString().substring(0, 10)) {
        temp.add(0);
      }
    }
    return temp;
  }

  Widget FarmDropDown(Function onChanged) {
    return Container(
      height: 40,
      //margin: EdgeInsets.only(left: 40),
      margin: EdgeInsets.all(15),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.0, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      child: farmNameList.length > 0
          ? DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                focusNode: TitleFocusNode,
                hint: Center(child: ChangedLanguage(text:farm)),
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
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            )
          : Center(child: Loading()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: const ChangedLanguage(text:'Farm Planner'),
          backgroundColor: Color(0xffECB34F),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset('assets/new_images/back.png')),
        ),
        body: Stack(
            children: [
          Column(
            children: [
              FarmDropDown((String newvalue) async {
                setState(() {
                  int index = farmNameList.indexOf(newvalue);
                  TitleValue1 = newvalue;
                  farm = farmIdList[index];
                });
                print(farm);
                print(api_key);
                var response = await http.get(Uri.parse(
                    'https://api.mapmycrop.com/calendar-data/$farm?api_key=$api_key'));
                print(response.body);

                setState(() {
                  var data = jsonDecode(response.body);
                  eventList = data;
                });
                //print(eventList);
                //print(eventList[0]['farm']);
              }),
              Card(
                margin: const EdgeInsets.symmetric(horizontal:10.0,vertical: 4.0),
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  side: BorderSide(color: Color(0xffECB34F), width:1.0),
                ),
                child: TableCalendar(
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
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    // Weekend days color (Sat,Sun)
                    weekendStyle: TextStyle(color: Colors.brown),
                  ),
                  daysOfWeekHeight: 30.0,
                  rowHeight: 50.0,
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.deepPurple.shade400,
                      shape: BoxShape.circle,
                    ),
                    outsideDaysVisible: false,
                    //markerDecoration: BoxDecoration(color:dotcolor, shape: BoxShape.circle),
                    weekendTextStyle: TextStyle(color: Colors.brown),
                  ),
                  calendarBuilders: CalendarBuilders(
                      markerBuilder: (BuildContext context, date, events) {
                    //print('the auto input is $events');
                    List row = <Widget>[];
                    if (eventList.isEmpty) return const SizedBox();
                    for (int i = 0; i < eventList.length; i++) {
                      if (eventList[i]['start_date'] ==
                          date.toString().substring(0, 10)) {
                        row.add(SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 22, left: 1.5, right: 1.5),
                            //padding: const EdgeInsets.all(1),
                            child: Container(
                              // height: 7, // for vertical axis
                              width: 5, // for horizontal axis
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: eventList[i]['title'] == "Planting"
                                      ? Color(0xFF73b273)
                                      : eventList[i]['title'] == "Harvesting"
                                          ? Color(0xFFea7617)
                                          : eventList[i]['title'] ==
                                                  "Fertilization"
                                              ? Color(0xFF7156b3)
                                              : eventList[i]['title'] ==
                                                      'Spraying'
                                                  ? Color(0xFF71a5c6)
                                                  : eventList[i]['title'] ==
                                                          'Tilage'
                                                      ? Color(0xFFdb392a):
                                                          eventList[i]['title'] ==
                                                              'Planned Cost'?Colors.black
                                                                  : Colors.greenAccent),
                            ),
                          ),
                        ));
                      }
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: row,
                    );
                  }),
                  // headerStyle: HeaderStyle(
                  //   formatButtonVisible: true,
                  //   titleCentered: true,
                  //   formatButtonShowsNext: false,
                  //   formatButtonDecoration: BoxDecoration(
                  //     color: Color(0xffECB34F),
                  //     borderRadius: BorderRadius.circular(4.0),
                  //   ),
                  //   formatButtonTextStyle: TextStyle(
                  //     color: Colors.white,
                  //   ),
                  // ),
                  headerStyle: const HeaderStyle(
                    titleTextStyle:
                        TextStyle(color: Colors.white, fontSize: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    formatButtonTextStyle:
                        TextStyle(color: Colors.black, fontSize: 13.0),
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 28,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 28,
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
                  eventLoader: listOfDayEvents,
                  // calendarBuilders: CalendarBuilders(
                  //   selectedBuilder: (context,dateTime,_){
                  //     return Container(height)
                  //
                  //   }
                  // ),
                ),
              ),
              eventList.isNotEmpty
                  ? Expanded(
                      // color: Colors.red,
                      //height: height(context) * 0.4,
                      child: Padding(
                      padding: const EdgeInsets.only(bottom: 70.0),
                      child: ListView.builder(
                          itemCount: eventList.length,
                          itemBuilder: (context, index) {
                            if (eventList[index]['title'] == 'Planting') {
                              bgcolor = Color(0xFF73b273);
                              textcolor = Color(0xFFffffff);
                            } else if (eventList[index]['title'] ==
                                'Harvesting') {
                              bgcolor = Color(0xFFea7617);
                              textcolor = Color(0xFFffffff);
                            } else if (eventList[index]['title'] ==
                                'Fertilization') {
                              bgcolor = Color(0xFF7156b3);
                              textcolor = Color(0xFFffffff);
                            } else if (eventList[index]['title'] ==
                                'Spraying') {
                              bgcolor = Color(0xFF71a5c6);
                              textcolor = Color(0xFFffffff);
                            } else if (eventList[index]['title'] == 'Tilage') {
                              bgcolor = Color(0xFFdb392a);
                              textcolor = Color(0xFFffffff);
                            } else {
                              bgcolor = Color(0xFF73b273);
                              textcolor = Color(0xFFffffff);
                            }
                            print(_selectedDay);
                            return eventList[index]['start_date'] ==
                                    _selectedDay.toString().substring(0, 10)
                                ? Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 4.0,
                                    ),
                                    //height: 50,
                                    decoration: BoxDecoration(
                                      color: bgcolor,
                                      //border: Border.all(),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: ListTile(
                                      title: ChangedLanguage(text:eventList[index]['title']),
                                      subtitle: ChangedLanguage(text:
                                          "${eventList[index]['start_date']} to ${eventList[index]['end_date']}"),
                                      trailing: IconButton(
                                          icon: Icon(
                                            Icons.delete_sharp,
                                            color: Colors.red.shade600,
                                          ),
                                          onPressed: () async {
                                            return showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (BuildContext context,
                                                              StateSetter
                                                                  setState) {
                                                    return AlertDialog(
                                                      content:
                                                          new SingleChildScrollView(
                                                        child: new ListBody(
                                                          children: <Widget>[
                                                            ChangedLanguage(text:
                                                              'Do you really want to delete this event.',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize:
                                                                      18.0),
                                                            ),
                                                            SizedBox(
                                                              height: 15.0,
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  MaterialButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: ChangedLanguage(text:
                                                                        'Close'),
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                  MaterialButton(
                                                                    onPressed:
                                                                        () async {
                                                                      // _deleteEvent(
                                                                      //     '${eventList[index]['id']}',
                                                                      //     index, context);
                                                                      var response =
                                                                          await http
                                                                              .delete(Uri.parse('https://api.mapmycrop.com/calendar-data/${eventList[index]['id']}?api_key=$api_key'));
                                                                      print(response
                                                                          .body);
                                                                      print(response
                                                                          .statusCode);

                                                                      if (response
                                                                              .statusCode ==
                                                                          200) {
                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                            content:
                                                                                ChangedLanguage(text:'activity deleted successfully')));
                                                                        setState(
                                                                            () {
                                                                          eventList
                                                                              .removeAt(index);
                                                                        });
                                                                      }
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.pushReplacement(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (BuildContext context) => super.widget));
                                                                    },
                                                                    child: ChangedLanguage(text:
                                                                        'Delete'),
                                                                    color: Colors
                                                                        .red,
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
                          }),
                    ))
                  : Container()
              /*FutureBuilder<List<Event>>(
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
                                              child: ChangedLanguage(text:
                                                  '${snapshot.data[index].start.toString().substring(8, 10)}'),
                                              backgroundColor: Colors.white,
                                            ), //ChangedLanguage(text:'${data[index]['start'].toString().substring(8,10)}'),
                                          ),
                                          title: ChangedLanguage(text:
                                            '${snapshot.data[index].title}',
                                            style: TextStyle(
                                                color: Color(0xFFffffff)),
                                          ),
                                          subtitle: ChangedLanguage(text:
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
                                                                ChangedLanguage(text:
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
                                                                            ChangedLanguage(text:'Close'),
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
                                                                            ChangedLanguage(text:'Delete'),
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
                            child: ChangedLanguage(text:
                              "No Data Found",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ));
                }),*/
            ],
          ),
        ]),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Flexible(
              //flex: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SaveDataActivity()));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 28.0),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xff103d14),
                  ),
                  // padding: const EdgeInsets.only(
                  //   left: 91, right: 122, top: 20, bottom: 19,),
                  child: Center(
                    child: ChangedLanguage(text:
                      "Add Event",
                      //textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
        // Visibility(
        //   visible: isDaySelected,
        //   child: FloatingActionButton.extended(
        //     backgroundColor: Colors.redAccent,
        //     label: ChangedLanguage(text:"Add Event"),
        //     icon: Icon(Icons.add),
        //     onPressed: () => showDialog(
        //         context: context,
        //         barrierDismissible: true,
        //         builder: (BuildContext context) {
        //           return StatefulBuilder(
        //               builder: (BuildContext context, StateSetter setState) {
        //             return AlertDialog(
        //               content: SingleChildScrollView(
        //                 child: new ListBody(
        //                   children: <Widget>[
        //                     ChangedLanguage(text:
        //                       'Add Event',
        //                       style: TextStyle(
        //                           fontWeight: FontWeight.w500, fontSize: 20.0),
        //                     ),
        //                     SizedBox(
        //                       height: 15.0,
        //                     ),
        //                     Container(
        //                       decoration: ShapeDecoration(
        //                         shape: RoundedRectangleBorder(
        //                           side: BorderSide(
        //                               width: 1.0, style: BorderStyle.solid),
        //                           borderRadius:
        //                               BorderRadius.all(Radius.circular(10.0)),
        //                         ),
        //                       ),
        //                       child: TitlelList.length > 0
        //                           ? DropdownButtonHideUnderline(
        //                               child: DropdownButton<String>(
        //                                 focusNode: TitleFocusNode,
        //                                 hint: Center(child: ChangedLanguage(text:TitlelList[0])),
        //                                 value: TitleValue,
        //                                 elevation: 25,
        //                                 isExpanded: true,
        //                                 icon: Icon(Icons.arrow_drop_down_circle),
        //                                 items: TitlelList.map((String value) {
        //                                   return DropdownMenuItem<String>(
        //                                     value: value,
        //                                     child: Center(
        //                                         child: ChangedLanguage(text:
        //                                       value,
        //                                       style: TextStyle(
        //                                           fontWeight: FontWeight.w500),
        //                                     )),
        //                                   );
        //                                 }).toList(),
        //                                 onChanged: (String newvalue) {
        //                                   setState(() {
        //                                     TitleValue = newvalue;
        //                                   });
        //                                 },
        //                               ),
        //                             )
        //                           : Center(child: CircularProgressIndicator()),
        //                     ),
        //                     SizedBox(
        //                       height: 12.0,
        //                     ),
        //                     FarmDropDown((String newvalue) {
        //                       setState(() {
        //                         int index = farmNameList.indexOf(newvalue);
        //                         TitleValue1 = newvalue;
        //                         farm = farmIdList[index];
        //                       });
        //                     }),
        //                     SizedBox(
        //                       height: 10.0,
        //                     ),
        //                     ChangedLanguage(text:"Start Date:"),
        //                     SizedBox(
        //                       height: 5.0,
        //                     ),
        //                     Container(
        //                       decoration: ShapeDecoration(
        //                         shape: RoundedRectangleBorder(
        //                           side: BorderSide(
        //                               width: 1.0, style: BorderStyle.solid),
        //                           borderRadius:
        //                               BorderRadius.all(Radius.circular(10.0)),
        //                         ),
        //                       ),
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                         children: [
        //                           Flexible(
        //                             flex: 1,
        //                             child: MaterialButton(
        //                               onPressed: () {
        //                                 showDatePicker(
        //                                         context: context,
        //                                         initialDate:
        //                                             fromDate ?? initialDate,
        //                                         firstDate: DateTime(
        //                                             DateTime.now().year - 1, 5),
        //                                         lastDate: DateTime(
        //                                             DateTime.now().year + 1, 9))
        //                                     .then((date) {
        //                                   if (date != null) {
        //                                     setState(() {
        //                                       fromDate = date;
        //                                       formattedFromDate =
        //                                           DateFormat('dd-MM-yyyy')
        //                                               .format(fromDate);
        //                                       newFromDate =
        //                                           DateFormat('yyyy-MM-dd')
        //                                               .format(fromDate);
        //                                     });
        //                                   }
        //                                 });
        //                               },
        //                               child: Icon(Icons.calendar_today),
        //                             ),
        //                           ),
        //                           SizedBox(
        //                             width: 15.0,
        //                           ),
        //                           Flexible(
        //                             flex: 3,
        //                             child: ChangedLanguage(text:
        //                               '$formattedFromDate',
        //                               style: TextStyle(
        //                                 fontSize: 18,
        //                               ),
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                     SizedBox(
        //                       height: 10.0,
        //                     ),
        //                     ChangedLanguage(text:"End Date:"),
        //                     SizedBox(
        //                       height: 5.0,
        //                     ),
        //                     Container(
        //                       decoration: ShapeDecoration(
        //                         shape: RoundedRectangleBorder(
        //                           side: BorderSide(
        //                               width: 1.0, style: BorderStyle.solid),
        //                           borderRadius:
        //                               BorderRadius.all(Radius.circular(10.0)),
        //                         ),
        //                       ),
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                         children: [
        //                           Flexible(
        //                             flex: 1,
        //                             child: MaterialButton(
        //                               onPressed: () {
        //                                 showDatePicker(
        //                                         context: context,
        //                                         initialDate:
        //                                             toDate ?? initialDate,
        //                                         firstDate: DateTime(
        //                                             DateTime.now().year - 1, 5),
        //                                         lastDate: DateTime(
        //                                             DateTime.now().year + 1, 9))
        //                                     .then((date) {
        //                                   if (date != null) {
        //                                     setState(() {
        //                                       toDate = date;
        //                                       formattedToDate =
        //                                           DateFormat('dd-MM-yyyy')
        //                                               .format(toDate);
        //                                       newToDate = DateFormat('yyyy-MM-dd')
        //                                           .format(toDate);
        //                                     });
        //                                   }
        //                                 });
        //                               },
        //                               child: Icon(Icons.calendar_today),
        //                             ),
        //                           ),
        //                           SizedBox(
        //                             width: 15.0,
        //                           ),
        //                           Flexible(
        //                             flex: 3,
        //                             child: ChangedLanguage(text:
        //                               '$formattedToDate',
        //                               style: TextStyle(
        //                                 fontSize: 18,
        //                               ),
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                     SizedBox(
        //                       height: 12.0,
        //                     ),
        //                     TextField(
        //                       onChanged: (value) {
        //                         setState(() {
        //                           Description = value;
        //                         });
        //                       },
        //                       controller: _DescController,
        //                       decoration: InputDecoration(
        //                         focusedBorder: OutlineInputBorder(
        //                             borderSide: BorderSide(color: Colors.black),
        //                             borderRadius:
        //                                 BorderRadius.all(Radius.circular(10))),
        //                         enabledBorder: OutlineInputBorder(
        //                             borderSide: BorderSide(color: Colors.black),
        //                             borderRadius:
        //                                 BorderRadius.all(Radius.circular(10))),
        //                         // hintText: 'Enter your product title',
        //                         labelStyle: TextStyle(color: Colors.black),
        //                         labelText: 'Description',
        //                         floatingLabelBehavior: FloatingLabelBehavior.auto,
        //                       ),
        //                     ),
        //                     SizedBox(
        //                       height: 10.0,
        //                     ),
        //                     Row(
        //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                         children: [
        //                           MaterialButton(
        //                             onPressed: () {
        //                               Navigator.pop(context);
        //                             },
        //                             child: ChangedLanguage(text:'Close'),
        //                             color: Colors.blue,
        //                           ),
        //                           MaterialButton(
        //                             onPressed: () {
        //                               if (newToDate != null &&
        //                                   newFromDate != null &&
        //                                   TitleValue != null &&
        //                                   Description != null) {
        //                                 print(newToDate);
        //                                 print(newFromDate);
        //                                 print(TitleValue);
        //                                 print(Description);
        //                                 // Navigator.pop(context);
        //                                 _datareciver(newToDate, newFromDate,
        //                                     TitleValue, Description);
        //                               } else {
        //                                 Fluttertoast.showToast(
        //                                     msg:
        //                                         "Description, newToDate,newFromDate,TitleValue Should not be empty",
        //                                     toastLength: Toast.LENGTH_LONG,
        //                                     gravity: ToastGravity.CENTER,
        //                                     timeInSecForIosWeb: 1,
        //                                     backgroundColor: Colors.red,
        //                                     textColor: Colors.white,
        //                                     fontSize: 12.0);
        //                               }
        //                             },
        //                             child: ChangedLanguage(text:'Save Data'),
        //                             color: Colors.blue,
        //                           ),
        //                         ]),
        //                   ],
        //                 ),
        //               ),
        //             );
        //           });
        //         }),
        //   ),
        // ),
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

  _deleteEvent(String ID, int index, BuildContext context) async {
    print(ID);
    var response = await http.delete(Uri.parse(
        'https://api.mapmycrop.com/calendar-data/${eventList[index]['id']}?api_key=$api_key'));
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: ChangedLanguage(text:'activity deleted successfully')));
      setState(() {
        eventList.removeAt(index);
      });
    }
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
