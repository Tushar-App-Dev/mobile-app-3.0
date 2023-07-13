import 'dart:convert';
import 'dart:math' as Math;
import 'dart:async';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_places_autocomplete/maps_places_autocomplete.dart';
import 'package:maps_places_autocomplete/model/place.dart';
import 'package:maps_places_autocomplete/model/suggestion.dart';
import 'package:mmc_master/Screens/NewScreens/DashboardActivity.dart';
import 'package:mmc_master/constants/constants.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../constant/Constant.dart';

class AddNewFarmsActivity extends StatefulWidget {
  // final double lat,lng;
  // const AddFarmScreen({Key key, this.lat, this.lng}) : super(key: key);

  @override
  _AddNewFarmsActivityState createState() => _AddNewFarmsActivityState();
}

class _AddNewFarmsActivityState extends State<AddNewFarmsActivity> {

  //Completer<GoogleMapController> _controller = Completer();
  GoogleMapController controller;

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  List<LatLng> _polylatlangs = <LatLng>[];
  Set<Marker> _marker1 = Set<Marker>();

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
  var maptype = MapType.hybrid;
  String occupierName, Description, FieldName,cropValue;
  bool isOccupierSwitched = false;
  bool isSearchSwitched = false;
  bool isdrawvisible=false;
  final FocusNode occupierNameFocusNode = FocusNode();
  DateTime initialDate = DateTime.now();
  DateTime fromDate, toDate;
  String fromDatemon, fromDateyr, monString, toDatemon, toDateyr;
  String newFromDate, newToDate, formattedFromDate, formattedToDate,api_key;
  List<String> seasonList = ['2015','2016','2017','2018','2019','2020','2021','2022','2023','2024','2025','2026','2027','2028','2029','2030','2031','2032','2033'];
  List<String> cropList = [];
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
  String _streetNumber;
  String _street;
  String _city;
  String _state;
  String _zipCode;
  String _vicinity;
  String _country;
  double _lat;
  double _lng;

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
    getCrops();
  }

  Future<void> fetchLocation() async {
    Position position = await _getGeoLocationPosition();
    GetAddressFromLatLong(position);
  }

  void onSuggestionClick(Place placeDetails) {
    setState(() {
      _streetNumber = placeDetails.streetNumber;
      _street = placeDetails.street;
      _city = placeDetails.city;
      _state = placeDetails.state;
      _zipCode = placeDetails.zipCode;
      _country = placeDetails.country;
      _vicinity = placeDetails.vicinity;
      _lat = placeDetails.lat;
      _lng = placeDetails.lng;
      _setMarker1(LatLng(_lat, _lng));
    });
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_lat, _lng),
      zoom: 17,
    )));
    print(_lat);
    print(_lng);
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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

  void _setMarker1(LatLng point) {
    final String markerIdVal = 'marker_$_markerIdCounter';
    _markerIdCounter++;
    setState(() {
      _marker1.add(
        Marker(
          markerId: MarkerId(markerIdVal),
          position: point,
          // infoWindow: InfoWindow(title: markerIdVal),
          // icon: icon,
          icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        )
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

  getCrops() async{
    // var response = await http.get(Uri.parse("https://api.mapmycrop.com/farm/add-crop?api_key=$api_key&farm_id=33625bb0963543f996268d3fb83af221"));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var api_key1 = prefs.getString('api_key');
    var response = await http.get(Uri.parse("https://api.mapmycrop.com/crop?api_key=$api_key1"));
    var cropData = jsonDecode(response.body);
    print(cropData);
    for(int i = 0;i<cropData.length;i++){
      setState(() {
        cropList.add(cropData[i]['name']);
      });
    }
    //print(cropList);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    final GoogleMap googleMap = GoogleMap(
      padding: const EdgeInsets.only(bottom: 60, top: 80),
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      onMapCreated: onMapCreated,
      initialCameraPosition: _position,
      mapType: maptype,
      markers: _markers.length==0?_marker1:_markers,
      polygons: _polygons,
      onCameraMove: _updateCameraPosition,
      onTap: (point) {
        if (_isPolygon) {
          setState(() {
            _polylatlangs.add(point);
            _setPolygon();
            _setMarker(point);
            _setMarker1(point);
            print(_polylatlangs);
          });
        }
      },
    );

    Widget _fabPolygon() {
      return Tooltip(
        waitDuration: Duration(seconds: 1),
        showDuration: Duration(seconds: 2),
        padding: EdgeInsets.all(5),
        height: 35,
        textStyle: TextStyle(
            fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.green),
        message: 'Undo Button',
        child: Container(
          height: 40,
          child: FloatingActionButton.extended(
            onPressed: () {
              setState(() {
                _polylatlangs.removeLast();
                // _markers.remove(_markers.firstWhere(
                //         (Marker marker) =>
                //     marker.markerId ==
                //         MarkerId(_polylatlangs.last.toString())));
                if( _polylatlangs.length < 1){
                  setState(() {
                    _markers.clear();
                    _marker1.clear();
                  });
                }
                else{
                  setState(() {
                    _markers.remove(_markers.last);
                  });
                }
              });
            },
            icon: const Icon(Icons.undo),
            label: const ChangedLanguage(text:'Undo'),
            backgroundColor: Colors.green,
          ),
        ),
      );
    }

    return Container(
      color: const Color(0xffECB34F),
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: _polylatlangs.length > 0 && _isPolygon ? _fabPolygon() : null,
          body: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: googleMap,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal:20),
                        padding: const EdgeInsets.only(left: 3,right: 5,top: 5,bottom: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_outlined,size: 18,),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // _isPolygon != true ?GestureDetector(
                          //   onTap:(){
                          //     setState(() {
                          //       _isPolygon = true;
                          //       Fluttertoast.showToast(
                          //           msg: "Draw Your Farm",
                          //           toastLength: Toast.LENGTH_LONG,
                          //           gravity: ToastGravity.CENTER,
                          //           timeInSecForIosWeb: 1,
                          //           backgroundColor: Colors.green,
                          //           textColor: Colors.white,
                          //           fontSize: 13.0
                          //       );
                          //     });
                          //   },
                          //   child: Container(
                          //     //color: Colors.white,
                          //     height: height(context)*0.038,
                          //     width: width(context)*0.15,
                          //     padding: const EdgeInsets.symmetric(vertical: 5),
                          //     decoration: BoxDecoration(
                          //         color: Colors.green,
                          //         borderRadius: BorderRadius.circular(5)
                          //     ),
                          //     child: Center(
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: const [
                          //           Text('Draw'),
                          //           Icon(Icons.add,size: 15,)
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ):GestureDetector(
                          //   onTap:(){
                          //     setState(() {
                          //       _isPolygon = false;
                          //     });
                          //   },
                          //   child: Container(
                          //     //color: Colors.white,
                          //     height: height(context)*0.038,
                          //     width: width(context)*0.15,
                          //     padding: const EdgeInsets.symmetric(vertical: 5),
                          //     decoration: BoxDecoration(
                          //         color: Colors.green,
                          //         borderRadius: BorderRadius.circular(5)
                          //     ),
                          //     child: Center(
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: const [
                          //           Text('Draw'),
                          //           Icon(Icons.add,size: 15,)
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   width: 20,
                          // ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                isOccupierSwitched = true;
                                print(isOccupierSwitched);
                              });
                            },
                            child: Container(
                              height: 35,
                              width: width(context)*0.09,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18)
                              ),
                              child: const Icon(Icons.map_outlined),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 50,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  width: width(context)*0.92,
                  //color: Colors.transparent,
                  child: MapsPlacesAutocomplete(
                      mapsApiKey: 'AIzaSyCK7jH4DKtCSJ4KGTdGnFLqkMBO0Zqq2dM',

                      onSuggestionClick: onSuggestionClick,
                      buildItem: (Suggestion suggestion, int index) {
                        return Container(
                            margin: const EdgeInsets.fromLTRB(2, 2, 2, 0),
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.centerLeft,
                            color: Colors.white,
                            child: FutureBuilder(future:changeLanguage1(suggestion.description),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.white,child: Card(
                              child: SizedBox(
                                height: height(context)*0.014,
                                width: width(context)*0.5,
                              ),
                            )),)
                          /*ChangedLanguage(text:suggestion.description)*/
                        );
                      },
                      inputDecoration: const InputDecoration(
                        filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38)),
                          hintText:
                          "Search",
                          errorText: null),
                      clearButton: const Icon(Icons.close),
                  ),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     hintText: 'Enter Address',
                  //     filled: true,
                  //     fillColor: Colors.white,
                  //     //border: InputBorder.none,
                  //     border: OutlineInputBorder(
                  //       borderSide: const BorderSide(
                  //         color: Colors.black,//this has no effect
                  //       ),
                  //       borderRadius: BorderRadius.circular(10.0),
                  //     ),
                  //     contentPadding: const EdgeInsets.only(
                  //       left: 15,
                  //       top: 15,
                  //     ),
                  //     suffixIcon: IconButton(
                  //       icon: const Icon(Icons.search),
                  //       onPressed: searchnavigate,
                  //       iconSize: 30,
                  //     ),
                  //   ),
                  //   onChanged: (val) {
                  //     setState(() {
                  //       searchAdd = val;
                  //     });
                  //   },
                  // ),
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
                      color: const Color(0xffECB34F),
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
                                activeColor: Colors.white,
                                fillColor:
                                MaterialStateColor.resolveWith((states) => Colors.white),
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
                              const ChangedLanguage(text:"Normal",style: TextStyle(color: Colors.white),),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 2,
                                groupValue: _radioSelected1,
                                activeColor: Colors.white,
                                fillColor:
                                MaterialStateColor.resolveWith((states) => Colors.white),
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
                              const ChangedLanguage(text:"Satellite",style: TextStyle(color: Colors.white),),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 3,
                                groupValue: _radioSelected1,
                                activeColor: Colors.white,
                                fillColor:
                                MaterialStateColor.resolveWith((states) => Colors.white),
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
                              const ChangedLanguage(text:"Hybrid",style: TextStyle(color: Colors.white),),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 4,
                                groupValue: _radioSelected1,
                                activeColor: Colors.white,
                                fillColor:
                                MaterialStateColor.resolveWith((states) => Colors.white),
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
                              const ChangedLanguage(text:"Terrain",style: TextStyle(color: Colors.white),),
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
                      color:  _isPolygon == false?Colors.green:Colors.orange,
                    ),
                    child: _isPolygon != true? Tooltip(
                      message: 'Draw your farm',
                      waitDuration: Duration(seconds: 1),
                      showDuration: Duration(seconds: 2),
                      padding: EdgeInsets.all(5),
                      height: 35,
                      textStyle: TextStyle(
                          fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), color: Colors.green),
                      //message: 'My Account',
                      child: IconButton(
                          icon: const Icon(FontAwesomeIcons.plus, color: Colors.white,),
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
                          }
                      ),
                    ):IconButton(
                        icon: const Icon(FontAwesomeIcons.drawPolygon, color: Colors.white,),
                        onPressed: () {
                          setState(() {
                            _isPolygon = false;
                          });
                        }
                    ),
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
                    child: Tooltip(
                      waitDuration: Duration(seconds: 1),
                      showDuration: Duration(seconds: 2),
                      padding: EdgeInsets.all(5),
                      height: 35,
                      textStyle: TextStyle(
                          fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), color: Colors.green),
                      message: 'Save Farm',
                      child: IconButton(
                          icon: const Icon(FontAwesomeIcons.save, color: Colors.white,),
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
                            //for(int i=0;i<6;i++)
                            String Polygon = "Polygon()";

                            print(_polylatlangs.length);

                            for (var i = 0; i < _polylatlangs.length; i++) {
                              lat1 = _polylatlangs[i].latitude;
                              lng1 = _polylatlangs[i].longitude;
                              arr.clear();
                              arr4.clear();
                              arr4.add(lat1.toString());
                              arr4.add(lng1.toString());

                              arr.add(lng1.toString());
                              arr.add(lat1.toString());
                              //print(arr);
                              arr2.add(arr.toString().replaceAll(',', ''));
                              arr5.add(arr4.toString());
                            }
                            //print(arr2);
                            //print(arr5);
                            return showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return AlertDialog(
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                const ChangedLanguage(text:'Save Your Farm Data',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 20.0),),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                const ChangedLanguage(text:"Field Name :"),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Container(
                                                  height:50,
                                                  child: TextField(
                                                    onChanged: (value) {
                                                      setState(() {
                                                        FieldName = value;
                                                      });
                                                    },
                                                    controller: _NameController,
                                                    decoration: const InputDecoration(
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
                                                      //hintText: 'Field Name',
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      //labelText: 'Field Name',
                                                      // floatingLabelBehavior: FloatingLabelBehavior
                                                      //     .auto,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 8.0,
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
                                                        //focusNode: cropFocusMode,
                                                        hint: Center(child:ChangedLanguage(text:'Select Crop')),
                                                        value: cropValue,
                                                        elevation: 25,
                                                        isExpanded: true,
                                                        icon: Icon(Icons.arrow_drop_down_circle),
                                                        items: cropList.map((String value) {
                                                          return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Center(
                                                                child: ChangedLanguage(text:
                                                                  value,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w500),
                                                                )),
                                                          );
                                                        }).toList(),
                                                        onChanged: (String newvalue) {

                                                          setState(() {
                                                            // int index = cropList.indexOf(newvalue);
                                                            cropValue = newvalue;
                                                            //farm = farmIdList[index];
                                                          });
                                                        },
                                                      ),
                                                    )
                                                  //: Center(child: CircularProgressIndicator()),
                                                ),
                                                SizedBox(
                                                  height: 8.0,
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
                                                        width:10.0,
                                                      ),
                                                      Flexible(
                                                        flex: 2,
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
                                                // SizedBox(
                                                //   height: 8.0,
                                                // ),
                                                // Text("Harvesting Date:",style: TextStyle(color: Colors.black)),
                                                // SizedBox(
                                                //   height: 5.0,
                                                // ),
                                                // Container(
                                                //   decoration: ShapeDecoration(
                                                //     color: Colors.white,
                                                //     shape: RoundedRectangleBorder(
                                                //       side: BorderSide(
                                                //           width: 1.0, style: BorderStyle.solid),
                                                //       borderRadius:
                                                //       BorderRadius.all(Radius.circular(10.0)),
                                                //     ),
                                                //   ),
                                                //   child: Row(
                                                //     mainAxisAlignment: MainAxisAlignment.start,
                                                //     children: [
                                                //       Flexible(
                                                //         flex: 1,
                                                //         child: MaterialButton(
                                                //           onPressed: () {
                                                //             showDatePicker(
                                                //                 context: context,
                                                //                 initialDate:
                                                //                 toDate ?? initialDate,
                                                //                 firstDate: DateTime(
                                                //                     DateTime.now().year - 1, 5),
                                                //                 lastDate: DateTime(
                                                //                     DateTime.now().year + 1, 9))
                                                //                 .then((date) {
                                                //               if (date != null) {
                                                //                 setState(() {
                                                //                   toDate = date;
                                                //                   formattedToDate =
                                                //                       DateFormat('dd-MM-yyyy')
                                                //                           .format(toDate);
                                                //                   newToDate = DateFormat('yyyy-MM-dd')
                                                //                       .format(toDate);
                                                //                 });
                                                //               }
                                                //             });
                                                //           },
                                                //           child: Icon(Icons.calendar_today),
                                                //         ),
                                                //       ),
                                                //       SizedBox(
                                                //         width: 10.0,
                                                //       ),
                                                //       Flexible(
                                                //         flex: 2,
                                                //         child: Text(
                                                //           '$formattedToDate',
                                                //           style: TextStyle(
                                                //             fontSize: 15,
                                                //           ),
                                                //         ),
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),
                                                SizedBox(
                                                  height: 8.0,
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
                                                              child: ChangedLanguage(text:
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
                                                  height: 8.0,
                                                ),
                                                 ChangedLanguage(text:"Discription :"),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Container(
                                                  height:50,
                                                  child: TextField(
                                                    onChanged: (value) {
                                                      setState(() {
                                                        Description = value;
                                                      });
                                                    },
                                                    controller: _DescController,
                                                    decoration: const InputDecoration(
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
                                                      //hintText: 'Discription',
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      //labelText: 'Field Name',
                                                      // floatingLabelBehavior: FloatingLabelBehavior
                                                      //     .auto,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                MaterialButton(
                                                  onPressed: () {
                                                    if (arr2.length != null &&
                                                        FieldName != null && cropValue!=null && newFromDate!=null && SeasonDropDownValue!=null) {
                                                      //Navigator.pop(context);
                                                      _datareciver(arr2, FieldName,Description);
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg: "Fieldname,Cropname,Start date and Season Should not be empty",
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
                                                  child: const ChangedLanguage(text:'Save Data',style:TextStyle(color: Colors.white)),
                                                  color: Color(0xffECB34F),
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
                      icon: const Icon(Icons.my_location, color: Colors.white,),
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
      //print(result);
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

  _datareciver(List points, String fieldName, String description) async {
    //print(desc);
    print('POLYGON((${points.toString().replaceAll('[', '').replaceAll(']', '')}))');
    var data, farmId,data1;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var api_key = prefs.getString('api_key');
    var response = await http.post(
      // Uri.parse('https://testingnotion.ml/farm/register?api_key=$api_key'),
      Uri.parse('http://api.mapmycrop.com/farm/register?api_key=$api_key'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": fieldName,
        "geometry": "POLYGON((${points.toString()
            .replaceAll('[', '')
            .replaceAll(']', '')}))",
        "description": description!=null?description:'NA',
      }),
    );
    data = jsonDecode(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Uploaded!');

      //QuickAlert.show(context: context, type: QuickAlertType.success,text: 'Farm added successfully');
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text('Farm Created Successfully'),
      // ));
      print(data);
      farmId = data['features'][0]['properties']['id'];
      var body = {
        // "farm": farm,
        // "title": titleValue,
        // "description": description,
        // "start_date": fromDate.toString(),
        // "end_date": toDate.toString()
        "crop": cropValue,
        "sowing_date": newFromDate,
        //"harvesting_date": newToDate,
        "season": SeasonDropDownValue
      };

      var response = await http.post(
          Uri.parse('https://api.mapmycrop.com/farm/add-crop?api_key=$api_key&farm_id=$farmId'),
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(body));
      FirebaseAnalytics.instance.logEvent(
        name: "crop_added",
        parameters: {
          "content_type": "Activity_planned",
          "api_key": api_key,
          "farmid": farmId,
          "crop": cropValue
        },
      ).onError((error, stackTrace) => print('analytics error is $error'));

      data1 = jsonDecode(response.body);
      print(data1);
      if (response.statusCode == 201 || response.statusCode == 200) {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: await changeLanguage('Farm Created Successfully!'),
            confirmBtnText: await changeLanguage('Ok'),
            onConfirmBtnTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (Context) => DashboardActivity()));
            }
        );
      }
    }
    else {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text('Farm not created'),
      // ));
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: await changeLanguage('Sorry,Farm not created'),
      );
    }
  }
}