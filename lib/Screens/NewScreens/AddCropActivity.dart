import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mmc_master/Screens/NewScreens/DashboardActivity.dart';
import 'package:mmc_master/Widgets/Loading.dart';
import 'package:mmc_master/constants/constants.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

import '../constant/Constant.dart';
import 'ExpertCall.dart';


class AddCropActivity extends StatefulWidget {
  const AddCropActivity({Key key}) : super(key: key);

  @override
  State<AddCropActivity> createState() => _AddCropActivityState();
}

class _AddCropActivityState extends State<AddCropActivity> {
  TextEditingController _DescController = TextEditingController();

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

  List<String> farmIdList = [], farmNameList = [], cropList=[],englishCropList = [],seasonList= ['2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024','2025',];
  String farmValue1;
  String cropValue,SeasonDropDownValue;
  final FocusNode farmFocusMode = FocusNode();
  final FocusNode cropFocusMode = FocusNode();
  final FocusNode seasonFocusNode = FocusNode();
  // Map<DateTime, List<Event>> selectedEvents;
  var id, title, start, end, color1, textcolor, idvalue;
  var data;
  Color bgcolor;

  String tilage = 'Tilage';
  String farm = 'Farm',crop = 'crop';
  @override
  void initState() {
    // TODO: implement initState
    getFarms();
    var now = DateTime.now();
    formattedFromDate =
        DateFormat('dd-MM-yyyy').format(now);
    formattedToDate =
        DateFormat('dd-MM-yyyy').format(now);


    super.initState();
  }
  getCrops(String api_key) async{

    // if(prefs.getStringList('translatedCropList').isNull||prefs.getStringList('translatedCropList').last!=prefs.getString('language')){
    //   print('this is global CropList   ${globalCropListTranslated.length}  1');
       var response = await http.get(Uri.parse("https://api.mapmycrop.com/crop?api_key=$api_key"));
      var cropData = jsonDecode(response.body);
      //print(cropData);
      for(int i = 0;i<cropData.length;i++){
        setState(() {
          cropList.add(cropData[i]['name']);
        });
      }
  }

  getFarms()async{
  //  print('this is global CropList   ${globalCropListTranslated.length}');

    farmIdList.clear();
    farmNameList.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    api_key = prefs.getString('api_key');
    getCrops(api_key);
    var url = 'https://api.mapmycrop.com/farm/?api_key=$api_key';
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    //print(response.statusCode);
    //print(data[0]['name']);

    for(int i=0;i<data.length;i++){
      setState(() {
        farmNameList.add(data[i]['name']);
        farmIdList.add(data[i]['id']);
        //farmIdList
      });
    }
    //print(response.body);

  }
  _datareciver(String toDate, String fromDate, String farmValue,cropValue,
      String description) async {

    print(fromDate);
    print(toDate);
    print(farmValue);
    print(cropValue);
    print(description);

    var data, datavalue;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var body = {
      // "farm": farm,
      // "title": titleValue,
      // "description": description,
      // "start_date": fromDate.toString(),
      // "end_date": toDate.toString()
      "crop": cropValue,
      "sowing_date": fromDate,
      "harvesting_date": toDate,
      "season": 2023
    };
    // print(uid);
    print("$body");


    var response = await http.post(
        Uri.parse('https://api.mapmycrop.com/farm/add-crop?api_key=$api_key&farm_id=$farm'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body));
    data = jsonDecode(response.body);
    print(data);
    print(response.statusCode);

    if (response.statusCode == 200) {
      /*FirebaseAnalytics.instance.logEvent(
        name: "Planner",
        parameters: {
          "content_type": "Activity_planned",
          //"userID": uid,
        },
      );*/

      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: await changeLanguage('Crop Added Successfully!'),
          confirmBtnText:await changeLanguage('Ok'),
          onConfirmBtnTap:(){
            Navigator.pop(context);
          }
      );
      // Fluttertoast.showToast(
      //     msg: "Crop Added Successfully",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.green,
      //     textColor: Colors.white,
      //     fontSize: 11.0);
      //_value = _event.getEvents();
      // Navigator.pop(context);
      _DescController.clear();
      // fetchPlannerData();
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Sorry, something went wrong',
          onConfirmBtnTap:(){
            Navigator.pop(context);
          }
      );
      // Fluttertoast.showToast(
      //     msg: "No Crop Added",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.redAccent,
      //     textColor: Colors.white,
      //     fontSize: 11.0);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey.shade100,
      appBar: AppBar(
        title:  ChangedLanguage(text:'Crop Rotations',style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          /*fontFamily: "Inter"*/
          fontWeight: FontWeight.w600,
        ),),
        backgroundColor: Color(0xffECB34F),
        elevation: 0.0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/new_images/back.png')),
      ),
      body: SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30,),
              Container(
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 1.0, style: BorderStyle.solid),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  child: farmNameList.isNotEmpty?DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      focusNode: farmFocusMode,
                      menuMaxHeight:400,
                      hint: Center(child: ChangedLanguage(text:'Select Farm',style: TextStyle(color: Colors.black),)),
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
                                style: TextStyle(
                                    fontWeight: FontWeight.w500),
                              )),
                        );
                      }).toList(),
                      onChanged: (String newvalue) {

                        setState(() {
                          int index = farmNameList.indexOf(newvalue);
                          farmValue1 = newvalue;
                          farm = farmIdList[index];
                        });
                        print(farmIdList);
                        print(farm);
                      },
                    ),
                  ): Center(
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
                    ),
                  ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 1.0, style: BorderStyle.solid),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      focusNode: cropFocusMode,
                      menuMaxHeight:400,
                      hint: FutureBuilder(
                        future: changeLanguage(cropValue??"Select Crop"),
                        builder: (context, i) => i.hasData
                            ? Center(
                              child: Text(
                          i.data,
                          style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0),
                        ),
                            )
                            : Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.white,
                            child: Card(
                              child: SizedBox(
                                height:
                                height(context) * 0.014,
                                width: width(context) * 0.25,
                              ),
                            )),
                      ),
                      value: cropValue,
                      elevation: 25,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down_circle),
                      items: cropList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(
                              child: languageText(value)

                            /*ChangedLanguage(text:
                                value,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),FutureBuilder(future:changeLanguage(value),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.white,child: Card(
                                child: SizedBox(

                                ),
                              )),)*/
                          ),
                        );
                      }).toList(),
                      onChanged: (String newvalue) {
                        print(englishCropList[cropList.indexOf(newvalue)]);
                        cropValue = englishCropList[cropList.indexOf(newvalue)];
                        setState(() {
                          // int index = cropList.indexOf(newvalue);
                         // cropValue = newvalue;
                          cropValue = newvalue;
                          //farm = farmIdList[index];
                        });
                        print(cropValue);
                      },
                    ),
                  )
                //: Center(child: CircularProgressIndicator()),
              ),
              SizedBox(
                height: 10.0,
              ),
              ChangedLanguage(text:"Sowing Date:",style: TextStyle(color: Colors.black)),
              SizedBox(
                height: 5.0,
              ),
              Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1.0, style: BorderStyle.solid),
                    borderRadius:
                    BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                      width: 10.0,
                    ),
                    Flexible(
                      flex: 1,
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
              ChangedLanguage(text:"Harvesting Date:",style: TextStyle(color: Colors.black)),
              SizedBox(
                height: 5.0,
              ),
              Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1.0, style: BorderStyle.solid),
                    borderRadius:
                    BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                      width: 10.0,
                    ),
                    Flexible(
                      flex: 1,
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
              Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0,
                        style: BorderStyle
                            .solid),
                    borderRadius: BorderRadius
                        .all(
                        Radius.circular(10.0)),
                  ),
                ),
                child: seasonList.length > 0
                    ? DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    focusNode: seasonFocusNode,
                    hint: Center(child: ChangedLanguage(text:
                        'Select Season')),
                    value: SeasonDropDownValue,
                    elevation: 25,
                    isExpanded: true,
                    icon: Icon(Icons
                        .arrow_drop_down_circle),
                    items: seasonList.map((
                        String value) {
                      return DropdownMenuItem<
                          String>(
                        value: value,
                        child: Center(
                            child: Text(
                              value,
                              style:
                              TextStyle(
                                  fontWeight: FontWeight
                                      .w500),
                            )),
                      );
                    }).toList(),
                    onChanged: (
                        String newvalue) {
                      setState(() {
                        // FocusScope.of(context).requestFocus(new FocusNode());
                        SeasonDropDownValue = newvalue;
                        // getVillageData(zoneDropDownValue);
                      });
                    },
                  ),
                )
                    : Center(
                    child: CircularProgressIndicator()),
              ),
              SizedBox(
                height: 10.0,
              ),
              ChangedLanguage(text:"Description:",style: TextStyle(color: Colors.black)),
              SizedBox(
                height: 5.0,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    Description = value;
                  });
                },
                controller: _DescController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10))),
                  //hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.grey),
                  //labelText: 'Description',
                  //floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 120,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xff103d14),
                    ),
                    // padding: const EdgeInsets.symmetric(
                    //   horizontal: 23,
                    //   vertical: 20,
                    // ),
                    child: Center(
                      child: ChangedLanguage(text:
                      "Back",
                        //textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          // fontFamily: "Open Sans",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (newToDate != null &&
                        newFromDate != null &&
                        farmValue1 != null &&
                        cropValue!= null) {
                      print(newToDate);
                      print(newFromDate);
                      print(farmValue1);
                      print(cropValue);
                      print(Description);
                      // Navigator.pop(context);
                      _datareciver(newToDate, newFromDate,
                          farmValue1,cropValue, Description);
                    } else {
                      Fluttertoast.showToast(
                          msg:
                          "Sowing Date,Harvesting Date,Crop Name,Farm Name and season Should not be empty",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 12.0);
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
                    //   vertical: 20,
                    // ),
                    child: Center(
                      child: ChangedLanguage(text:
                      "Submit",
                        //textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          // fontFamily: "Open Sans",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
             /* Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white,width: 1),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        width: 100,
                        height: 50,
                        child: MaterialButton(
                          elevation: 0,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: ChangedLanguage(text:'Close',style: TextStyle(color: Colors.white)),
                          color: Color(0xff103d14),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color(0xfff7941e),
                            //border: Border.all(color: Colors.white,width: 1),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: MaterialButton(
                            clipBehavior: Clip.hardEdge,
                            elevation: 0,
                            onPressed: () {
                              if (newToDate != null &&
                                  newFromDate != null &&
                                  farmValue1 != null &&
                                  cropValue!= null) {
                                print(newToDate);
                                print(newFromDate);
                                print(farmValue1);
                                print(cropValue);
                                print(Description);
                                // Navigator.pop(context);
                                _datareciver(newToDate, newFromDate,
                                    farmValue1,cropValue, Description);
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                    "Sowing Date,Harvesting Date,Crop Name,Farm Name and season Should not be empty",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 12.0);
                              }
                            },
                            child: ChangedLanguage(text:'Save Data',style: TextStyle(color: Colors.white)),
                            color: Color(0xfff7941e)
                        ),
                      ),
                    ),
                  ]),*/
            ],
          ),
        )
      ),
    );
  }
}