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
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/constants.dart';
import '../constant/Constant.dart';
import 'ScoutingDataSaveActivity.dart';

class ScoutingActivity extends StatefulWidget {
  const ScoutingActivity({Key key}) : super(key: key);

  @override
  State<ScoutingActivity> createState() => _ScoutingActivityState();
}

class _ScoutingActivityState extends State<ScoutingActivity> {

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
  var maptype = MapType.hybrid;
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
  var farm,farmId;

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
  final TextEditingController _textFieldController = TextEditingController();
  List<String> farmIdList = [], farmNameList = [];
  List eventList = [];
  List cords=[];
  Set<Polygon> _polygons = Set<Polygon>();

  @override
  void initState() {
    super.initState();
    getFarms();
    //fetchMarkersData();
    fetchLocation();
    //fetchCurrentLocation();
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
    var api_key= prefs.getString('api_key');

    var response = await http.get(Uri.parse(
        'https://api.mapmycrop.com/scouting/$farmId?api_key=$api_key'));
    print(response.body);
    data = await jsonDecode(response.body);
    // var point = jsonDecode(data[0]["geometry"]);
    // print(point['coordinates']);
    List<LatLng> pointList=[];
    List pointcord=[];
    for (int i = 0; i < data.length; i++) {
      var point = jsonDecode(data[i]["geometry"]);
      print(point['coordinates']);
      _setMarker(LatLng(point['coordinates'][1], point['coordinates'][0]));
      // print(p)
      setState(() {
        notetype=data[i]["note_type"];
      });
    }
    // var uri = Uri.parse("https://app.mapmycrop.com/handler/get_scout_data.php");
    //
    // var request = new http.MultipartRequest("POST", uri);
    // request.fields['uid'] = uid;
    // request.fields['type'] = "GET";
    // print(request);
    // var response = await request.send();
    // if (response.statusCode == 200) {
    //   response.stream.transform(utf8.decoder).listen((value) async {
    //     data = jsonDecode(value);
    //     print(data);
    //     var daval = data["DATA_VALUE"];
    //     for (var i = 0; i < daval.length; i++) {
    //       setState(() {
    //
    //       });
    //       _setMarker(LatLng(double.parse(lat), double.parse(lng)));
    //     }
    //   });
    // }
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

  void getFarms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    farmIdList.clear();
    farmNameList.clear();
    var api_key = prefs.getString('api_key');
    var response = await http
        .get(Uri.parse('https://api.mapmycrop.com/farm/?api_key=$api_key'));
    //print(response.body);
    var data = await jsonDecode(response.body);
    for (int i = 0; i < data.length; i++) {
      setState(() {
        farmIdList.add(data[i]['id']);
        farmNameList.add(data[i]['name']);
      });
    }
  }

  void getFarmDetails()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var api_key= prefs.getString('api_key');
    _polygons.clear();
    cords.clear();
    var response = await http.get(Uri.parse(
        'https://api.mapmycrop.com/farm/$farmId?api_key=$api_key'));
    //print(response.body);
      var data = jsonDecode(response.body);
      //eventList = data;
      for (int i = 0; i < data['features'].length; i++) {
        setState(() {
          cords.add(data['features'][i]['geometry']['coordinates']);
        });
      }
      var coordinates='[${cords.toString().replaceAll('[[[', '').replaceAll(']]]', '')}]';
      //[LatLng(37.423411271013045, -122.08410512655972)]
    //print(coordinates);
    List<LatLng> formattedList = [];
    formattedList.clear();
    var formattedlatlong;
    var LatLngArray = jsonDecode(coordinates);
    for(int i= 0;i<LatLngArray.length;i++) {
      LatLng coords = LatLng(LatLngArray[i][1],LatLngArray[i][0]);
      //print(coords);
      //formattedList
      setState(() {
        formattedList.add(coords);
      });
    }
    setState(() {
      _polygons.add(
        Polygon(
          points: formattedList,
          strokeWidth: 2,
          fillColor: Colors.transparent,
          polygonId: PolygonId('1'),
          strokeColor: Colors.green
        ),
      );
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(LatLngArray[0][1], LatLngArray[0][0]),
        zoom: 17,
      )));
      // _position = CameraPosition(
      //     zoom: 17, target: LatLng(LatLngArray[0][1], LatLngArray[0][0]));
      // _controller.animateCamera(CameraUpdate.newCameraPosition(_position));
      //print(_polygons);
    });
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
        title:notetype
    );
  }

  @override
  Widget build(BuildContext context) {

    final GoogleMap googleMap = GoogleMap(
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      padding: EdgeInsets.only(bottom: 60, top: 80),
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      onMapCreated: onMapCreated,
      initialCameraPosition: _position,
      mapType: maptype,
      markers: _markers,
      polygons: _polygons,
      onCameraMove: _updateCameraPosition,
      onTap: (point) {
        isMarkerOn=true;
        if (_isMarker) {
          setState(() {
            _setMarker(point);
            _isMarker=false;
            print(point);
            if(farmId!=null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ScoutingDataSaveActivity(
                              lat: point.latitude.toString(),
                              lng: point.longitude.toString(),
                              farmid: farmId)));
               } else{
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: 'Please select your farm first ',
              );
            }
            });
        }
      },
    );

    return Container(
      color: Color(0xffECB34F),
      child: SafeArea(
        child: Scaffold(
          //extendBodyBehindAppBar: true,
          // floatingActionButton: FloatingActionButton(
          //   highlightElevation: 25,
          //   onPressed: fetchLocation,
          //   child: Icon(
          //     Icons.my_location,
          //     color: Colors.white,
          //   ),
          //   backgroundColor: Color(0XFFF7941E),
          // ),
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
                    Flexible(
                      flex: 2,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal:20.0, vertical: 10.0),
                          height: 35.0,
                          decoration: ShapeDecoration(
                            color:Color(0xffECB34F),
                            shape: RoundedRectangleBorder(
                              //side: BorderSide(width: 1.0, style: BorderStyle.solid),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              //focusNode: emailIDFocusNode,
                              //dropdownColor:Color(0xffECB34F),
                              hint: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: FutureBuilder(future:changeLanguage('Select Farm'),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.white,child: Card(
                                  child: SizedBox(
                                    height: height(context)*0.014,
                                    width: width(context)*0.5,
                                  ),
                                )),)

                                //Text('Select Farm',style: TextStyle(color: Colors.black),),
                              ),
                              value: farm,
                              elevation:0,
                              isExpanded: true,
                              icon: Icon(Icons.keyboard_arrow_down,color: Colors.black,),
                              items: farmNameList.map((String value) {
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
                                  var index = farmNameList.indexOf(newvalue);
                                  // FocusScope.of(context).requestFocus(new FocusNode());
                                  farmId = farmIdList[index];
                                  farm = newvalue;
                                  getFarmDetails();
                                  fetchMarkersData();
                                  //_polygons.clear();
                                  // getVillageData(zoneDropDownValue);
                                });
                              },
                            ),
                          )),
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
                top: 50,
                left: 20.0,
                child: Visibility(
                  visible: isMarkerOn,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      setState(() {
                        _markers.clear();
                        isMarkerOn=false;
                      });
                    },
                    icon: Icon(Icons.undo),
                    label: Text('Undo Marker'),
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.52,
                left: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.green,
                    ),
                    child: IconButton(
                        icon:Icon(
                          Icons.my_location,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          fetchLocation();
                        } //_optionsDialogBox,
                    ),
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
                  width: width(context) * 0.90,
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

