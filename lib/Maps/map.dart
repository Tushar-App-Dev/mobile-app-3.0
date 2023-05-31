import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:search_map_location/search_map_location.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/constant/Constant.dart';

class MapUiBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapUiBodyState();
}

class MapUiBodyState extends State<MapUiBody> {
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
  Set<Marker> _markers = Set<Marker>();
  int _radioSelected1;
  bool isMarkerOn = false;
  var maptype = MapType.satellite;
  String occupierName, Desc, uid;
  String idValue, notetype, comment, lat, lng,img,siteplanimageName;
  //double lat,lng;
  bool isOccupierSwitched = false;
  bool isSaveMarker = false;
  //bool isDeleteMarker = false;
  final FocusNode occupierNameFocusNode = FocusNode();
  BitmapDescriptor customicon;
  bool _isPolygon = true; //Default
  bool _isMarker = false;
  bool _isCircle = false;

  List<String> emailList = [
    'Disease',
    'Weeds',
    'Lodging',
    'Waterlogging',
    'Other',
    'Pests'
  ];
  String searchAdd;
  String EmailDropDownValue;
  File noticeProofImage;
  bool isImageSelected = true;
  bool isLoading = true;
  final FocusNode emailIDFocusNode = FocusNode();
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMarkersData();
    fetchLocation();
    //fetchCurrentLocation();
  }

  // fetchCurrentLocation() async {
  //   print("STARTING LOCATION SERVICE");
  //   var location = Location();
  //   location.changeSettings(
  //     accuracy: LocationAccuracy.HIGH,
  //   );
  //
  //   try {
  //     location.getLocation().then((LocationData currentLocation) {
  //       // location.onLocationChanged().listen((currentLocation) {
  //       print(currentLocation.latitude);
  //       print(currentLocation.longitude);
  //       setState(() {
  //         _position = CameraPosition(
  //             zoom: 17,
  //             target:
  //                 LatLng(currentLocation.latitude, currentLocation.longitude));
  //         _controller.animateCamera(CameraUpdate.newCameraPosition(_position));
  //       });
  //     });
  //   } catch (PlatformException) {
  //     location = null;
  //   }
  // }

  Future<void> fetchLocation() async {
    Position position = await _getGeoLocationPosition();
    GetAddressFromLatLong(position);
  }

  Future<Position> _getGeoLocationPosition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    //print(placemarks);
    Placemark place = placemarks[0];
    String Address = '${place.locality}';
    print(Address);
    setState(() {
      _position = CameraPosition(
          zoom: 17, target: LatLng(position.latitude, position.longitude));
      _controller.animateCamera(CameraUpdate.newCameraPosition(_position));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchMarkersData() async {
    var data;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('userID');

    var uri = Uri.parse("https://app.mapmycrop.com/handler/get_scout_data.php");

    var request = new http.MultipartRequest("POST", uri);
    request.fields['uid'] = uid;
    request.fields['type'] = "GET";
    print(request);
    var response = await request.send();

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) async {
        data = jsonDecode(value);
        print(data);
        var daval = data["DATA_VALUE"];
        for (var i = 0; i < daval.length; i++) {
          setState(() {
            notetype = data["DATA_VALUE"][i]['NOTE_TYPE'];
            comment = data["DATA_VALUE"][i]['COMMENT'];
            lat = data["DATA_VALUE"][i]['LATITUDE'];
            lng = data["DATA_VALUE"][i]['LONGITUDE'];
            img = data["DATA_VALUE"][i]['PATH'];
            print(notetype);
            print(comment);
            print(lat);
            print(lng);
          });
          _setMarker(LatLng(double.parse(lat), double.parse(lng)));
        }
      });
    }
  }

  void _setMarker(LatLng point) {
    final String markerIdVal = 'marker_$_markerIdCounter';
    _markerIdCounter++;

    if (_markerIdCounter % 2 == 0) {
      customicon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    } else if (_markerIdCounter % 3 == 0) {
      customicon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    }else if (_markerIdCounter % 4 == 0) {
      customicon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
    } else {
      customicon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          icon: customicon,
          infoWindow: _buildInfoWindow(point,notetype)
          // InfoWindow(
          //     title: notetype,
          //     snippet:
          //         'Lat: ${point.latitude.toString().substring(0, 10)}  Long: ${point.longitude.toString().substring(0, 10)}'),
          //   //   onTap:(){
          //   //     // showDialog(
          //   //     //   context: context,
          //   //     //   builder: (context) {
          //   //     //     //String contentText = "Content of Dialog";
          //   //     //     return StatefulBuilder(
          //   //     //       builder: (context, setState) {
          //   //     //         return AlertDialog(
          //   //     //           //title: Text("Title of Dialog"),
          //   //     //           //content: Text(contentText),
          //   //     //           actions: <Widget>[
          //   //     //             MaterialButton(
          //   //     //               onPressed: (){
          //   //     //                 setState(() {
          //   //     //                   _markers.remove(_markers.firstWhere((Marker marker) => marker.markerId == MarkerId(point.toString())));
          //   //     //                   Navigator.pop(context);
          //   //     //                 });
          //   //     //               },
          //   //     //               child: Text("Delete"),
          //   //     //             ),
          //   //     //             MaterialButton(
          //   //     //               onPressed: () {
          //   //     //                 _optionsDialogBox();
          //   //     //                 // setState(() {
          //   //     //                 //   contentText = "Changed Content of Dialog";
          //   //     //                 // });
          //   //     //               },
          //   //     //               child: Text("Save"),
          //   //     //             ),
          //   //     //           ],
          //   //     //         );
          //   //     //       },
          //   //     //     );
          //   //     //   },
          //   //     // );
          //   //   //     setState(() {
          //   //   //       _markers.remove(_markers.firstWhere((Marker marker) => marker.markerId == MarkerId(point.toString())));
          //   //   //       //isSaveMarker=true;
          //   //   //       //isDeleteMarker=true;
          //   //   //     });
          //   //    }
          //   // ),
          // ),
          // onTap: ()  {
          //   return showDialog(
          //       context: context,
          //       barrierDismissible: true,
          //       builder: (BuildContext context) {
          //         return StatefulBuilder(
          //             builder: (BuildContext context, StateSetter setState) {
          //               return Align(
          //                 alignment: Alignment.topCenter,
          //                 child: Container(
          //                   margin: EdgeInsets.all(30),
          //                   height: 60,
          //                   decoration: BoxDecoration(
          //                       color: Colors.white,
          //                       borderRadius: BorderRadius.all(Radius.circular(10)),
          //                   ),
          //                   child: Row(
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: <Widget>[
          //                       _buildAvatar(),
          //                       _buildLocationInfo(point,notetype),
          //                       //_buildMarkerType()
          //                     ],
          //                   ),
          //                 ),
          //               );
          //             }
          //         );
          //       });
          // }
        ),
      );
    });
  }

  Widget _buildAvatar() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      width: 50,
      height: 50,
      child: ClipOval(
        child: Image.asset(
          'assets/images/success.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLocationInfo(LatLng point, String notetype) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              notetype,
              style: CustomAppTheme().data.textTheme.bodyText1,
            ),
            Text(
              'Latitude : ${point.latitude}',
              style: CustomAppTheme().data.textTheme.headline4,
            ),
            Text(
              'Longitude : ${point.longitude}',
              style: CustomAppTheme().data.textTheme.headline4,
            )
          ],
        ),
      ),
    );
  }

  InfoWindow _buildInfoWindow(LatLng point, String notetype) {
    return InfoWindow(
      title:'Click here',
      onTap:(){
        // print(notetype);
        // print(point.toString());
        if(notetype !=null && point != null){
          return showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.all(30),
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _buildAvatar(),
                              _buildLocationInfo(point,notetype),
                              //_buildMarkerType()
                            ],
                          ),
                        ),
                      );
                    }
                );
              });
        }
        else{
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
                              Text('You have not saved this marker data.Save the data and then Continue...',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18.0),),
                              SizedBox(
                                height: 15.0,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Ok'),
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                );
              });
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = height(context) * 0.80;
    double screenWidth = width(context);
    // _markers.add(Marker(
    //   //draggable: true,
    //   markerId: MarkerId("MAP"),
    //   position: _position.target,
    //   infoWindow: InfoWindow(),
    // ));

    final GoogleMap googleMap = GoogleMap(
      padding: EdgeInsets.only(bottom: 60, top: 80),
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      onMapCreated: onMapCreated,
      initialCameraPosition: _position,
      mapType: maptype,
      markers: _markers,
      onCameraMove: _updateCameraPosition,
      onTap: (point) {
        isMarkerOn=true;
        if (_isMarker) {
          setState(() {
            _setMarker(point);
            print(point); // LatLng(37.42119564694096, -122.08418693393469)
            return showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return AlertDialog(
                      content: new SingleChildScrollView(
                        child: new ListBody(
                          children: <Widget>[
                            Text('Save Field Data'),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text("Note Type :"),
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
                              child: emailList.length > 0
                                  ? DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        focusNode: emailIDFocusNode,
                                        hint: Center(child: Text(emailList[0])),
                                        value: EmailDropDownValue,
                                        elevation: 25,
                                        isExpanded: true,
                                        icon:
                                            Icon(Icons.arrow_drop_down_circle),
                                        items: emailList.map((String value) {
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
                                  : Center(child: CircularProgressIndicator()),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text("Comment:"),
                            SizedBox(
                              height: 5.0,
                            ),
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  Desc = value;
                                });
                              },
                              controller: _textFieldController,
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
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  child: Icon(
                                    Icons.camera,
                                    size: 30.0,
                                  ),
                                  //new Text('Take Photo'),
                                  onTap: (){}//imageSelectorCamera,
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                GestureDetector(
                                  child: Icon(Icons.image, size: 30.0),
                                  //new Text('Select Image From Gallery'),
                                  onTap: (){}//ImageSelectorGallery,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      _markers.remove(_markers.firstWhere(
                                          (Marker marker) =>
                                              marker.markerId ==
                                              MarkerId(point.toString())));
                                      isMarkerOn=false;
                                      Navigator.pop(context);
                                      //  Navigator.pushReplacement(
                                      //      context,
                                      //      MaterialPageRoute(
                                      //          builder: (BuildContext context) => super.widget));
                                    });
                                  },
                                  child: Text('Delete'),
                                  color: Colors.blue,
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    if (Desc != null &&
                                        point != null &&
                                        EmailDropDownValue != null) {
                                      _datareciver(
                                          Desc, point, EmailDropDownValue);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Description and Type Should not be empty",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 11.0);
                                    }
                                  },
                                  child: Text('Save Data'),
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                });
          });
        }
      },
    );

    return Container(
      color: Colors.green[800],
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            highlightElevation: 25,
            onPressed: fetchLocation,
            child: Icon(
              Icons.my_location,
              color: Colors.black,
            ),
            backgroundColor: Colors.white70,
          ),
          body: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: googleMap,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
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
                        activeColor: Colors.green,
                        value: isOccupierSwitched,
                        onChanged: (bool value) {
                          setState(() {
                            isOccupierSwitched = value;
                          });
                        },
                      ),
                    ),
                  ]),
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
                top: 50,
                left: 20.0,
                child: Visibility(
                  visible: isMarkerOn,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      setState(() {
                        _markers.clear();
                      });
                    },
                    icon: Icon(Icons.undo),
                    label: Text('Undo Marker'),
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.green,
                    ),
                    child: _isMarker != true
                        ? IconButton(
                            icon: Icon(
                              Icons.add_location,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isMarker = true;
                              });
                              //Navigator.push(context,MaterialPageRoute(builder:(context)=>GooMap()));
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.add_location,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _isMarker = false;
                                isMarkerOn=false;
                              });
                              //Navigator.push(context,MaterialPageRoute(builder:(context)=>GooMap()));
                            },
                          ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  width: width(context) * 0.70,
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

  _datareciver(String desc, LatLng point, String type) async {
    print(desc);
    print(type);
    print(point.latitude.toString());
    print(point.longitude.toString());

    var data, datavalue;
    String base64SitePlanImage = noticeProofImage == null
        ? 'NA'
        : base64Encode(noticeProofImage.readAsBytesSync());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('userID');
    print(uid);
    var uri = Uri.parse(
        'https://app.mapmycrop.com/handler/data_manager_notes.php'); //data_manager.php
    var request = new http.MultipartRequest("POST", uri);
    request.fields['TYPE'] = 'INSERT';
    request.fields['USER_ID'] = uid;
    request.fields['CROP_TYPE'] = type;
    request.fields['DESC'] = desc;
    request.fields['LAT'] = point.latitude.toString();
    request.fields['LNG'] = point.longitude.toString();
    //request.fields['name'] =siteplanimageName;
    request.fields['file0'] = base64SitePlanImage;

    print(request);

    var response = await request.send();
    if (response.statusCode == 200) {
      // FirebaseAnalytics.instance.logEvent(
      //   name: "Scouting",
      //   parameters: {
      //     "pagename":"Add_markers",
      //     "userID":uid,
      //   },
      // );
      print('Uploaded!');
      Fluttertoast.showToast(
          msg: "Data Uploaded Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 11.0);
      isMarkerOn=false;
      Navigator.pop(context);
      fetchMarkersData();
    }
  }
}

class CustomAppTheme {
  ThemeData _themeData;

  CustomAppTheme() {
    this._themeData = _buildFormAppTheme();
  }

  ThemeData get data {
    return _themeData;
  }

  ThemeData _buildFormAppTheme() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      accentColor: mRegistrationBlack,
      primaryColor: mRegistrationBlack,
      scaffoldBackgroundColor: mFormWhite,
      cardColor: mFormWhite,
      errorColor: mFormErrorRed,
      textTheme: _buildFormAppTextTheme(base.textTheme),
      primaryTextTheme: _buildFormAppTextTheme(base.textTheme),
      accentTextTheme: _buildFormAppTextTheme(base.textTheme),
      primaryIconTheme: base.iconTheme.copyWith(color: mRegistrationBlack),
      unselectedWidgetColor: mRegistrationBlack,
    );
  }

  TextTheme _buildFormAppTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1.copyWith(
        fontFamily: 'Cookie',
        fontSize: 36.0,
        color: Colors.black,
      ),
      bodyText1: base.bodyText1.copyWith(
        fontFamily: 'DINOT',
        fontSize: 15.0,
        color: Colors.black,
      ),
      subtitle1: base.subtitle1.copyWith(
        fontFamily: 'DINOT',
        fontSize: 14.0,
        color: Colors.black,
      ),
      caption: base.caption.copyWith(
        fontFamily: 'DancingsScript',
        fontSize: 50.0,
        color: Colors.black,
      ),
      headline4: base.headline4.copyWith(
        fontFamily: 'DancingsScript',
        fontSize: 13.0,
        color: Colors.black,
      ),
      button: base.button.copyWith(
        fontFamily: 'DancingsScript',
        fontSize: 14.0,
        color: mFormWhite,
      ),
    );
  }
}

const mRegistrationBlack = Color(0xFF000000);
const mFormWhite = Color(0xFFFFFFFF);
const mFormErrorRed = Color(0xFFC5032B);
const mYankeeBlue = Color(0xFF14213D);
