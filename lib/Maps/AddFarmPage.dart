import 'dart:convert';
import 'dart:math' as Math;
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:search_map_location/widget/search_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/constant/Constant.dart';

class AddFarmScreen extends StatefulWidget {
  // final double lat,lng;
  // const AddFarmScreen({Key key, this.lat, this.lng}) : super(key: key);

  @override
  _AddFarmScreenState createState() => _AddFarmScreenState();
}

class _AddFarmScreenState extends State<AddFarmScreen> {

  //Completer<GoogleMapController> _controller = Completer();
  GoogleMapController controller;

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  List<LatLng> _polylatlangs = <LatLng>[];

  int _polygonIdCounter = 1;
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(18.5204, 73.8567),
    zoom: 17.0,
  );

  CameraPosition _position = _kInitialPosition;
  bool _isMapCreated = false;
  bool _isMoving = false;
  GoogleMapController _controller;

  //final Set<Marker> _markers = {};
  int _markerIdCounter = 1;
  bool _isPolygon = false;
  int _radioSelected1;
  var maptype = MapType.satellite;
  String occupierName, Description, FieldName;
  bool isOccupierSwitched = false;
  bool isSearchSwitched = false;
  final FocusNode occupierNameFocusNode = FocusNode();
  DateTime initialDate = DateTime.now();
  DateTime fromDate, toDate;
  String fromDatemon, fromDateyr, monString, toDatemon, toDateyr;
  String newFromDate, newToDate, formattedFromDate, formattedToDate;
  List<String> seasonList = ['2015','2016','2017','2018','2019','2020','2021','2022','2023','2024','2025','2026','2027','2028','2029','2030','2031','2032','2033'];
  List<String> emailList = [
    'Almonds',
    'Apple',
    'Beans',
    'Buckwheat',
    'Cocoa',
    'Canola',
    'Onion',
    'Cereals',
    'Citrus',
    'Coffee',
    'Cotton',
    'Custard Apple',
    'Fig',
    'Flax',
    'Fruit',
    'Grapes',
    'Green Chilli',
    'Green Peas',
    'Maize',
    'Mixed cereal Crops',
    'Nuts',
    'Oats',
    'Oilseed Crops',
    'Other',
    'Peanuts',
    'Peas',
    'Potatoes',
    'Pulses',
    'Rapeseed',
    'Rice',
    'Rye',
    'Sorghum',
    'Soybeans',
    'Spice',
    'Spring Barley',
    'Spring Cereals',
    'Spring Rapeseed',
    'Sugar Beet',
    'Sugarcane',
    'Sunflower',
    'Tobacco',
    'Tomato',
    'Tuber crops',
    'Vegetables',
    'Wheat',
    'Winter Barley',
    'Winter Cereals',
    'Winter Rapeseed',
    'Winter Sorghum',
    'Winter Wheat'
  ];

  String EmailDropDownValue,SeasonDropDownValue;
  File noticeProofImage;
  bool isImageSelected = true;
  bool isLoading = true;
  final FocusNode emailIDFocusNode = FocusNode();
  final FocusNode seasonFocusNode = FocusNode();
  var area;
  TextEditingController _DescController = TextEditingController();
  TextEditingController _NameController = TextEditingController();
  BitmapDescriptor icon;
  String searchAdd;

  @override
  void initState() {
    fromDate = initialDate;
    formattedFromDate = DateFormat('dd-MM-yyyy').format(fromDate);
    newFromDate = DateFormat('yyyy-MM-dd').format(fromDate);

    toDate = initialDate;
    formattedToDate = DateFormat('dd-MM-yyyy').format(toDate);
    newToDate = DateFormat('yyyy-MM-dd').format(toDate);
    super.initState();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    Position position = await _getGeoLocationPosition();
    GetAddressFromLatLong(position);
  }

  Future<Position> _getGeoLocationPosition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);
    print(placemarks);
    setState(() {
      _position = CameraPosition(
          zoom: 17,
          target:
          LatLng(position.latitude, position.longitude));
      _controller.animateCamera(CameraUpdate.newCameraPosition(_position));
    });
  }

  void _setMarker(LatLng point) {
    final String markerIdVal = 'marker_$_markerIdCounter';
    _markerIdCounter++;
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(markerIdVal),
          position: point,
          // infoWindow: InfoWindow(title: markerIdVal),
          // icon: icon,
          icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    });
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;
    _polygons.add(
      Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: _polylatlangs,
        strokeWidth: 3,
        fillColor: Colors.transparent,
      ),
    );
  }

  _calculateArea() {
    _polylatlangs.add(_polylatlangs[0]);
    area = calculatePolygonArea(_polylatlangs);
    // Fluttertoast.showToast(
    //     msg: calculatePolygonArea(_polylatlangs).toString() + " Acres",
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.green,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  static double calculatePolygonArea(List coordinates) {
    double area = 0;

    if (coordinates.length > 2) {
      for (var i = 0; i < coordinates.length - 1; i++) {
        var p1 = coordinates[i];
        var p2 = coordinates[i + 1];
        area += convertToRadian(p2.longitude - p1.longitude) *
            (2 +
                Math.sin(convertToRadian(p1.latitude)) +
                Math.sin(convertToRadian(p2.latitude)));
      }

      area = area * 6378137 * 6378137 / 2;
    }

    return area.abs() * 0.000247105; //sq meters to Acres
  }

  static double convertToRadian(double input) {
    return input * Math.pi / 180;
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height * 0.80;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    final GoogleMap googleMap = GoogleMap(
      padding: EdgeInsets.only(bottom: 60, top: 80),
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      onMapCreated: onMapCreated,
      initialCameraPosition: _position,
      mapType: maptype,
      markers: _markers,
      polygons: _polygons,
      onCameraMove: _updateCameraPosition,
      onTap: (point) {
        if (_isPolygon) {
          setState(() {
            _polylatlangs.add(point);
            _setPolygon();
            _setMarker(point);
            print(_polylatlangs);
          });
        }
      },
    );

    Widget _fabPolygon() {
      return FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _polylatlangs.removeLast();
            // _markers.remove(_markers.firstWhere(
            //         (Marker marker) =>
            //     marker.markerId ==
            //         MarkerId(_polylatlangs.last.toString())));
            if( _polylatlangs.length < 1){
              _markers.clear();
            }
            else{
              _markers.remove(_markers.last);
            }
          });
        },
        icon: Icon(Icons.undo),
        label: Text('Undo point'),
        backgroundColor: Colors.green,
      );
    }

    return Container(
      color: Colors.green[800],
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: _polylatlangs.length > 0 && _isPolygon ? _fabPolygon() : null,
          body: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: googleMap,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 40.0,
                        margin: EdgeInsets.symmetric(horizontal:15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.green,
                        ),
                        child: IconButton(
                          color: Colors.white,
                            icon: Icon(Icons.arrow_back,),
                            onPressed: () {
                              Navigator.pop(context);
                            }
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: SwitchListTile(
                        activeColor: Colors.green[800],
                        value: isOccupierSwitched,
                        onChanged: (bool value) {
                          setState(() {
                            isOccupierSwitched = value;
                            print(isOccupierSwitched);
                          });
                        },
                      ),
                    ),
                  ]
              ),
              Positioned(
                top: 60,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  width: width(context) - 50,
                  color: Colors.white,
                  child:TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Address',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        left: 15,
                        top: 15,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                         onPressed: searchnavigate,
                        iconSize: 30,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                         searchAdd = val;
                      });
                    },
                  ),
               ),
              ),
              Positioned(
                top: 50,
                right: 20.0,
                child: Visibility(
                  visible: isOccupierSwitched,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.green,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0, left: 0.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: _radioSelected1,
                                activeColor: Colors.purple,
                                onChanged: (value) {
                                  setState(() {
                                    maptype = MapType.normal;
                                    _radioSelected1 = value as int;
                                    isOccupierSwitched=false;
                                    // _radioVal1 = 'Normal';
                                    // print(_radioVal1);
                                  });
                                },
                              ),
                              const Text("Normal"),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 2,
                                groupValue: _radioSelected1,
                                activeColor: Colors.purple,
                                onChanged: (value) {
                                  setState(() {
                                    maptype = MapType.satellite;
                                    _radioSelected1 = value as int;
                                    isOccupierSwitched=false;
                                    // _radioVal1 = 'Normal';
                                    // print(_radioVal1);
                                  });
                                },
                              ),
                              const Text("Satellite"),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 3,
                                groupValue: _radioSelected1,
                                activeColor: Colors.purple,
                                onChanged: (value) {
                                  setState(() {
                                    maptype = MapType.hybrid;
                                    _radioSelected1 = value as int;
                                    isOccupierSwitched=false;
                                    // _radioVal1 = 'Normal';
                                    // print(_radioVal1);
                                  });
                                },
                              ),
                              const Text("Hybrid"),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 4,
                                groupValue: _radioSelected1,
                                activeColor: Colors.purple,
                                onChanged: (value) {
                                  setState(() {
                                    maptype = MapType.terrain;
                                    _radioSelected1 = value as int;
                                    isOccupierSwitched=false;
                                    // _radioVal1 = 'Normal';
                                    // print(_radioVal1);
                                  });
                                },
                              ),
                              const Text("Terrain"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.65,
                left: 10.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.green,
                      ),
                      child: _isPolygon != true ? IconButton(
                        icon: Icon(FontAwesomeIcons.edit, color: Colors.white,),
                        onPressed: () {
                          setState(() {
                            _isPolygon = true;
                            Fluttertoast.showToast(
                                msg: "Draw Your Farm",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 13.0
                            );
                          });
                        },
                      ) : IconButton(
                        icon: Icon(FontAwesomeIcons.edit, color: Colors.black,),
                        //drawPolygon
                        onPressed: () {
                          setState(() {
                            _isPolygon = false;
                          });
                        },
                      )
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.72,
                left: 10.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.green,
                    ),
                    child: IconButton(
                        icon: Icon(FontAwesomeIcons.save, color: Colors.white,),
                        onPressed: () {
                          _calculateArea();
                          print(area);
                          double lat1, lng1, lat2, lng2;
                          List<String> arr = <String>[];
                          List<String> arr2 = <String>[];
                          List<String> arr3 = <String>[];
                          List<String> arr4 = <String>[];
                          List<String> arr5 = <String>[];
                          List<String> arr6 = <String>[];

                          print(_polylatlangs.length);

                          for (var i = 0; i < _polylatlangs.length; i++) {
                            lat1 = _polylatlangs[i].latitude;
                            lng1 = _polylatlangs[i].longitude;
                            arr.clear();
                            arr4.clear();
                            arr4.add(lng1.toString());
                            arr4.add(lat1.toString());

                            arr.add(lat1.toString());
                            arr.add(lng1.toString());
                            //print(arr);
                            arr2.add(arr.toString());
                            arr5.add(arr4.toString());
                          }
                          print(arr2);
                          print(arr5);

                          return showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return AlertDialog(
                                        content: new SingleChildScrollView(
                                          child: new ListBody(
                                            children: <Widget>[
                                              Text('Save Field Data',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20.0),),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Text("Field Name :"),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              TextField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    FieldName = value;
                                                  });
                                                },
                                                controller: _NameController,
                                                decoration: InputDecoration(
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                      borderRadius: BorderRadius
                                                          .all(
                                                          Radius.circular(10))),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                      borderRadius: BorderRadius
                                                          .all(
                                                          Radius.circular(10))),
                                                  // hintText: 'Enter your product title',
                                                  labelStyle: TextStyle(
                                                      color: Colors.black),
                                                  labelText: 'Field Name',
                                                  floatingLabelBehavior: FloatingLabelBehavior
                                                      .auto,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Text("Crop Name:"),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Container(
                                                decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(width: 1.0,
                                                        style: BorderStyle
                                                            .solid),
                                                    borderRadius: BorderRadius
                                                        .all(
                                                        Radius.circular(10.0)),
                                                  ),
                                                ),
                                                child: emailList.length > 0
                                                    ? DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    focusNode: emailIDFocusNode,
                                                    hint: Center(child: Text(
                                                        emailList[0])),
                                                    value: EmailDropDownValue,
                                                    elevation: 25,
                                                    isExpanded: true,
                                                    icon: Icon(Icons
                                                        .arrow_drop_down_circle),
                                                    items: emailList.map((
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
                                                        EmailDropDownValue =
                                                            newvalue;
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
                                              Text("Sowing Date:"),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Container(
                                                decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(width: 1.0,
                                                        style: BorderStyle
                                                            .solid),
                                                    borderRadius: BorderRadius
                                                        .all(
                                                        Radius.circular(10.0)),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: [
                                                    Flexible(
                                                      flex: 1,
                                                      child: MaterialButton(
                                                        onPressed: () {
                                                          showDatePicker(
                                                              context: context,
                                                              initialDate: fromDate ??
                                                                  initialDate,
                                                              firstDate: DateTime(
                                                                  DateTime
                                                                      .now()
                                                                      .year - 1,
                                                                  5),
                                                              lastDate: DateTime(
                                                                  DateTime
                                                                      .now()
                                                                      .year + 1,
                                                                  9))
                                                              .then((date) {
                                                            if (date != null) {
                                                              setState(() {
                                                                fromDate = date;
                                                                formattedFromDate =
                                                                    DateFormat(
                                                                        'dd-MM-yyyy')
                                                                        .format(
                                                                        fromDate);
                                                                newFromDate =
                                                                    DateFormat(
                                                                        'yyyy-MM-dd')
                                                                        .format(
                                                                        fromDate);
                                                              });
                                                            }
                                                          });
                                                        },
                                                        child: Icon(Icons
                                                            .calendar_today),
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
                                                          fontSize: 18,),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Text("Harvest Date:"),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Container(
                                                decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(width: 1.0,
                                                        style: BorderStyle
                                                            .solid),
                                                    borderRadius: BorderRadius
                                                        .all(
                                                        Radius.circular(10.0)),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: [
                                                    Flexible(
                                                      flex: 1,
                                                      child: MaterialButton(
                                                        onPressed: () {
                                                          showDatePicker(
                                                              context: context,
                                                              initialDate: toDate ??
                                                                  initialDate,
                                                              firstDate: DateTime(
                                                                  DateTime
                                                                      .now()
                                                                      .year - 1,
                                                                  5),
                                                              lastDate: DateTime(
                                                                  DateTime
                                                                      .now()
                                                                      .year + 1,
                                                                  9))
                                                              .then((date) {
                                                            if (date != null) {
                                                              setState(() {
                                                                toDate = date;
                                                                formattedToDate =
                                                                    DateFormat(
                                                                        'dd-MM-yyyy')
                                                                        .format(
                                                                        toDate);
                                                                newToDate =
                                                                    DateFormat(
                                                                        'yyyy-MM-dd')
                                                                        .format(
                                                                        toDate);
                                                              });
                                                            }
                                                          });
                                                        },
                                                        child: Icon(Icons
                                                            .calendar_today),
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
                                                          fontSize: 18,),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Text("Season:"),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Container(
                                                decoration: ShapeDecoration(
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
                                                    hint: Center(child: Text(
                                                        seasonList[0])),
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
                                              Text("Description:"),
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
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                      borderRadius: BorderRadius
                                                          .all(
                                                          Radius.circular(10))),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                      borderRadius: BorderRadius
                                                          .all(
                                                          Radius.circular(10))),
                                                  // hintText: 'Enter your product title',
                                                  labelStyle: TextStyle(
                                                      color: Colors.black),
                                                  labelText: 'Description',
                                                  floatingLabelBehavior: FloatingLabelBehavior
                                                      .auto,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              MaterialButton(
                                                onPressed: () {
                                                  if (newToDate != null && arr2.length != null &&
                                                      EmailDropDownValue !=
                                                          null &&
                                                      newFromDate != null &&
                                                      FieldName != null &&
                                                      arr5!=null) {
                                                    Navigator.pop(context);
                                                    _datareciver(
                                                        Description, arr2,
                                                        EmailDropDownValue,
                                                        newFromDate, FieldName,arr5,newToDate,SeasonDropDownValue);
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg: "Description, FieldName,Crop Name, Sowing date Should not be empty",
                                                        toastLength: Toast
                                                            .LENGTH_LONG,
                                                        gravity: ToastGravity
                                                            .CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors
                                                            .red,
                                                        textColor: Colors.white,
                                                        fontSize: 12.0
                                                    );
                                                  }
                                                },
                                                child: Text('Save Data'),
                                                color: Colors.blue,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                );
                              });
                        } //_optionsDialogBox,
                      //print(_polylatlangs);
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.79,
                left: 10.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.green,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.my_location, color: Colors.white,),
                      onPressed: fetchLocation,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  searchnavigate() {
    locationFromAddress(searchAdd).then((result) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(result[0].latitude, result[0].longitude),
        zoom: 12,
      )));
    });
  }

  void _updateCameraPosition(CameraPosition position) {
    setState(() {
      _position = position;
    });
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
      _isMapCreated = true;
      fetchLocation();
    });
  }

  _datareciver(String desc,List points,String cropName,String sowing,String fieldName,List points2, String harvest, String season) async {
    print(desc);
    print(points);
    print(cropName);
    print(sowing);
    print(fieldName);
    print(points2);
    print(season);
    print(area);
    print(harvest);
    var random = new Random();
    print(random.nextInt(10000));

    print('{"name":"$cropName","geo_json":{"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[$points]}}}');

    var data, datavalue;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('userID');
    print(uid);
    var uri = Uri.parse(
        'https://app.mapmycrop.com/handler/insert_polygon.php'); //data_manager.php
    var request = new http.MultipartRequest("POST", uri);
    request.fields['REF_NO'] = random.nextInt(10000).toString();
    request.fields['USER_ID'] = uid;
    request.fields['NAME'] = fieldName;
    request.fields['CROP_TYPE'] = cropName;
    request.fields['SOWING_DATE'] = sowing;//HARVEST_DATE
    request.fields['SEASON'] = season;//sowing.substring(0,3);
    request.fields['HARVEST_DATE'] = harvest;
    request.fields['DESC'] = desc !=null ? desc :'';
    request.fields['AREA'] = area.toString();
    request.fields['POLY_CENTER'] = points[1].toString();
    request.fields['LAT'] = _polylatlangs.first.latitude.toString();
    request.fields['LNG'] =  _polylatlangs.first.longitude.toString();
    request.fields['GEOM'] = points.toString();
    request.fields['POLY_ID'] = '{"name":"$cropName","geo_json":{"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[$points2]}}}';

    print(request);

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Uploaded!');
      response.stream.transform(utf8.decoder).listen((value) async {
        data = jsonDecode(value);
        print(data);
        if (data["status"] == "SUCCESS| Polygon Created." ) {
          // Fluttertoast.showToast(
          //     msg: "Polygon Created Successfully",
          //     toastLength: Toast.LENGTH_LONG,
          //     gravity: ToastGravity.BOTTOM,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.green,
          //     textColor: Colors.white,
          //     fontSize: 11.0
          //   );
          // FirebaseAnalytics.instance.logEvent(
          //   name: "Draw_farm",
          //   parameters: {
          //     "userID":uid,
          //     "Comment":"Polygon Created Successfully",
          //   },
          // );
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Polygon Created Successfully'),
          ));
          Navigator.pop(context);
          _NameController.clear();
          _DescController.clear();
          }
        else{
          Fluttertoast.showToast(
              msg: "Polygon not created",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 11.0
          );
        }
        // Navigator.pop(context);
        // // fetchLocation();
      });
    }
  }
}