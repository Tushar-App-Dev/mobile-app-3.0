/*
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_map/plugin_api.dart';
import '../constant/Constant.dart';

class OverlayImagePage extends StatefulWidget {
  static const String route = 'overlay_image';

  const OverlayImagePage({Key key}) : super(key: key);

  @override
  State<OverlayImagePage> createState() => _OverlayImagePageState();
}

class _OverlayImagePageState extends State<OverlayImagePage> {
  var showCoords = false;
  var loadingTime = false;
  var grid = false;
  List<Map> PolyIdList = [];
  String farmValue1,farm;
  var data1;

  double currentZoom = 12.0;
  MapController mapController = MapController();
  LatLng currentCenter = LatLng(18.106976125,75.198790468);
  List<String> farmIdList = [], farmNameList = [];
  var filledPoints = <LatLng>[];
  var bounds;
  var farmarea,cropname,standardYield;
  @override
  void initState() {
    getFarms();
    super.initState();
  }

  void getFarms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    farmIdList.clear();
    farmNameList.clear();
    var api_key = prefs.getString('api_key');
    var response = await http
        .get(Uri.parse('http://api.mapmycrop.store/farm/?api_key=$api_key'));
    //print(response.body);
    var data = await jsonDecode(response.body);
    for (int i = 0; i < data['features'].length; i++) {
      setState(() {
        farmIdList.add(data['features'][i]['properties']['id']);
        farmNameList.add(data['features'][i]['properties']['name']);
      });
    }
    setState(() {
      farmValue1=farmNameList[0];
    });
    getFarmDetails(farmIdList[0]);
  }

  void getFarmDetails(String farmid) async {
    filledPoints.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var api_key = prefs.getString('api_key');
    var response = await http.get(Uri.parse('https://api.mapmycrop.com/farm/$farmid?api_key=$api_key'));
    //print(response.body);
    var data = await jsonDecode(response.body);
    print(data);
    setState((){
      for(int i = 0;i<data['features'][0]["geometry"]['coordinates'][0].length;i++){
        // print(data['features'][0]["geometry"]['coordinates'][0][i][0]);
        // print(data['features'][0]["geometry"]['coordinates'][0][0]);
        filledPoints.add(LatLng(data['features'][0]["geometry"]['coordinates'][0][i][1],data['features'][0]["geometry"]['coordinates'][0][i][0]),);
      }
      currentCenter = filledPoints.first;
      currentZoom = 15;
      mapController.move(currentCenter, currentZoom);
      var bbox = data['features'][0]["properties"]['bbox'];
      farmarea=data['features'][0]['properties']['area'];
      cropname=data['features'][0]['properties']['crops'].isNotEmpty?data['features'][0]['properties']['crops'][0]['name']:'';
      bounds = LatLngBounds(LatLng(bbox[1], bbox[0]),LatLng(bbox[3], bbox[2]));
    });
     getStandardYield(cropname);
  }
  getStandardYield(String cropname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var api_key = prefs.getString('api_key');
    var response = await http.get(Uri.parse('https://api.mapmycrop.com/crop/$cropname?api_key=$api_key'));
    var data = jsonDecode(response.body);
    setState((){
      standardYield =  data['yield_value']??'';
    });
  }

  @override
  Widget build(BuildContext context) {
    var overlayImages = <OverlayImage>[
      OverlayImage(
          bounds:bounds,
          opacity: 0.8,
        imageProvider: Image.asset(
          'assets/amsr2.png',
        ).image,),
    ];

    // var filledPoints = <LatLng>[
    //   LatLng(18.107341323,75.197543912),
    //   LatLng(18.106774086,75.197840296),
    //   LatLng(18.106976125,75.198790468),
    //   LatLng(18.107524878,75.198449157),
    //   LatLng(18.107341323,75.197543912),
    //   // LatLng(49.29, -2.57),
    //   // LatLng(51.46, -6.43),
    //   // LatLng(49.86, -8.17),
    //   // LatLng(48.39, -3.49),
    // ];
    double screenHeight = height(context) * 0.80;
    double screenWidth = width(context);

    Widget tileBuilder(BuildContext context, Widget tileWidget, Tile tile) {
      final coords = tile.coords;

      return Container(
        decoration: BoxDecoration(
          border: grid ? Border.all() : null,
        ),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            tileWidget,
            if (loadingTime || showCoords)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showCoords)
                    Text(
                      '${coords.x.floor()} : ${coords.y.floor()} : ${coords.z.floor()}',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  if (loadingTime)
                    Text(
                      tile.loaded == null
                          ? 'Loading'
                          // sometimes result is negative which shouldn't happen, abs() corrects it
                          : '${(tile.loaded.millisecond - tile.loadStarted.millisecond).abs()} ms',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                ],
              ),
          ],
        ),
      );
    }

    final markers = <Marker>[
      Marker(
        width: 80,
        height: 80,
        point: LatLng(17.7105448560672, 74.00568086653949),
        builder: (ctx) => Icon(
          Icons.location_pin,
          size: 40,
          color: Colors.redAccent,
        ),
      ),
    ];

    void _zoomPlus() {
      currentZoom = currentZoom + 1;
      mapController.move(currentCenter, currentZoom);
    }

    void _zoomMinus() {
      currentZoom = currentZoom - 1;
      mapController.move(currentCenter, currentZoom);
    }

    return Container(
      color: Color(0xffECB34F),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          // appBar: AppBar(
          //   title: const Text('Dashboard'),
          //   backgroundColor: Color(0xffECB34F),
          //   elevation: 0.0,
          //   leading: InkWell(
          //       onTap: () {
          //         Navigator.pop(context);
          //       },
          //       child: Image.asset('assets/new_images/back.png')),
          // ),
          // floatingActionButton: FloatingActionButton.extended(
          //   heroTag: 'coords',
          //   label: Text(
          //     showCoords ? 'Hide coords' : 'Show coords',
          //     textAlign: TextAlign.center,
          //   ),
          //   icon: Icon(showCoords ? Icons.unarchive : Icons.bug_report),
          //   onPressed: () => setState(() => showCoords = !showCoords),
          // ),
          // drawer: buildDrawer(context, OverlayImagePage.route),
          body: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Container(
                  //   height: height(context)*0.40,
                  //   child: FlutterMap(
                  //     options: MapOptions(
                  //       center: LatLng(17.710256769766964, 74.00564163923262),
                  //       zoom: 12.0,
                  //     ),
                  //     layers: [
                  //       TileLayerOptions(
                  //         urlTemplate:
                  //         "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  //         subdomains: ['a', 'b', 'c'],
                  //         tileProvider: const NonCachingNetworkTileProvider(),
                  //         tileBuilder: tileBuilder,
                  //       ),
                  //       PolygonLayerOptions(polygons: [
                  //         Polygon(
                  //           points: filledPoints,
                  //           // isFilled: true,
                  //           // isDotted: true,
                  //           borderColor: Colors.green,
                  //           borderStrokeWidth: 4.0,
                  //         ),
                  //       ]),
                  //       OverlayImageLayerOptions(overlayImages: overlayImages)
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 450,
                    child: Stack(fit: StackFit.passthrough, children: [
                      FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          center: currentCenter,
                          zoom: currentZoom,
                        ),
                        layers: [
                          TileLayerOptions(
                            urlTemplate:
                                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            //subdomains: ['a', 'b', 'c'],
                            //tileProvider: const NonCachingNetworkTileProvider(),
                            //tileBuilder: tileBuilder,
                            tileProvider: NetworkTileProvider(),
                            tileBuilder: tileBuilder,
                          ),
                          // MarkerLayerOptions(
                          //   markers: markers
                          // ),
                          PolygonLayerOptions(
                            polygons: [
                              Polygon(
                                points: filledPoints,
                                isDotted: false, // By default it's false
                                borderColor: Colors.red,
                                color: Colors.transparent,
                                borderStrokeWidth: 1,
                              ),
                            ],
                          ),
                          // OverlayImageLayerOptions(
                          //     overlayImages: overlayImages,
                          //     // [OverlayImage(
                          //     //     bounds: LatLngBounds(LatLng(18.10677408640053,75.19754391163588),
                          //     //         LatLng(18.107524878181348,75.19879046827555)),
                          //     //     opacity: 0.8,
                          //     //     imageProvider: const NetworkImage(
                          //     //         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcST76fI2nH14Q_Y2-Jx2Bq-ONPjeACsGB3g5g&usqp=CAU')),]
                          // ),
                        ],
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 30,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal:4),
                                  padding: const EdgeInsets.only(
                                      left: 3, right: 5, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new_outlined,
                                    size: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  flex: 1,
                                  child: Container(
                                    height: 35,
                                    decoration: ShapeDecoration(
                                      color: Colors.green.shade200,
                                      shape: RoundedRectangleBorder(
                                        //side: BorderSide(width: 1.0, style: BorderStyle.solid),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        //focusNode: emailIDFocusNode,
                                        //dropdownColor:Color(0xffECB34F),
                                        hint: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            farmValue1??'Select Farm',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        value: farmValue1,
                                        elevation: 0,
                                        //isExpanded: true,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.black,
                                        ),
                                        items: farmNameList.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String newvalue) {
                                          setState(() {
                                            int index = farmNameList.indexOf(newvalue);
                                            farmValue1 = newvalue;
                                            farm = farmIdList[index];
                                            print(farm);
                                          });
                                          getFarmDetails(farm);
                                        },
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  flex: 1,
                                  child: Container(
                                    height: 35,
                                    decoration: ShapeDecoration(
                                      color: Colors.green.shade200,
                                      shape: RoundedRectangleBorder(
                                        //side: BorderSide(width: 1.0, style: BorderStyle.solid),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        //focusNode: emailIDFocusNode,
                                        //dropdownColor:Color(0xffECB34F),
                                        hint: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            'Select Indices',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        // value: farm,
                                        elevation: 0,
                                        //isExpanded: true,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.black,
                                        ),
                                        items: farmNameList.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String newvalue) {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ))
                            ],
                          )),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.green.shade300,
                              ),
                              child: MaterialButton(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                onPressed: () {
                                  _zoomPlus();
                                },
                                child:
                                    Text('+', style: TextStyle(fontSize: 20)),
                                //color: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.green.shade300,
                              ),
                              child: MaterialButton(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                onPressed: () {
                                  _zoomMinus();
                                },
                                child: Text(
                                  '-',
                                  style: TextStyle(fontSize: 20),
                                ),
                                //color: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          tileColor: Colors.white,
                          horizontalTitleGap: 8.0,
                          contentPadding: EdgeInsets.symmetric(horizontal: 3.0),
                          leading: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/illustrations/generic-farm-rating.png'),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          title: Text(
                            'Generic Farm Rating',
                            style: TextStyle(fontSize: 11),
                          ),
                          subtitle: Text(''),
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
                          },
                        ),
                      ),
                      5.width,
                      Flexible(
                        flex: 1,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          tileColor: Colors.white,
                          horizontalTitleGap: 8.0,
                          contentPadding: EdgeInsets.symmetric(horizontal: 3.0),
                          leading: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.grey[200],
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/illustrations/generic-farm-score.png'),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          title: Text(
                            'Generic Farm Score',
                            style: TextStyle(fontSize: 11),
                          ),
                          subtitle: Text(''),
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
                          },
                        ),
                      ),
                    ],
                  ),
                  5.height,
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          tileColor: Colors.white,
                          horizontalTitleGap: 8.0,
                          contentPadding: EdgeInsets.symmetric(horizontal: 3.0),
                          leading: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.grey[200],
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/illustrations/ai-farm-rating.png'),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          title: Text(
                            'AI Farm Rating',
                            style: TextStyle(fontSize: 11),
                          ),
                          subtitle: Text(''),
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
                          },
                        ),
                      ),
                      5.width,
                      Flexible(
                        flex: 1,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          tileColor: Colors.white,
                          horizontalTitleGap: 8.0,
                          contentPadding: EdgeInsets.symmetric(horizontal: 3.0),
                          leading: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.grey[200],
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/illustrations/ai-farm-score.png'),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          title: Text(
                            'AI Farm Score',
                            style: TextStyle(fontSize: 11),
                          ),
                          subtitle: Text(''),
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
                          },
                        ),
                      ),
                    ],
                  ),
                  5.height,
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          tileColor: Colors.white,
                          horizontalTitleGap: 8.0,
                          contentPadding: EdgeInsets.symmetric(horizontal: 3.0),
                          leading: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.grey[200],
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/illustrations/total-area.png'),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          title: Text(
                            'Total Area',
                            style: TextStyle(fontSize: 11),
                          ),
                          subtitle: Text(farmarea.toString().substring(0,4)),
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
                          },
                        ),
                      ),
                      5.width,
                      Flexible(
                        flex: 1,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          tileColor: Colors.white,
                          horizontalTitleGap: 8.0,
                          contentPadding: EdgeInsets.symmetric(horizontal: 3.0),
                          leading: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.grey[200],
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/illustrations/crop-name.png'),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          title: Text(
                            'Crop Name',
                            style: TextStyle(fontSize: 11),
                          ),
                          subtitle: Text(cropname.toString()),
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
                          },
                        ),
                      ),
                    ],
                  ),
                  5.height,
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          tileColor: Colors.white,
                          horizontalTitleGap: 8.0,
                          contentPadding: EdgeInsets.symmetric(horizontal: 3.0),
                          leading: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.grey[200],
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/illustrations/standard-yield-data.png'),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          title: Text(
                            'Standard Yield Data',
                            style: TextStyle(fontSize: 11),
                          ),
                          subtitle: Text(standardYield.toString()??''),
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
                          },
                        ),
                      ),
                      5.width,
                      Flexible(
                        flex: 1,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          tileColor: Colors.white,
                          horizontalTitleGap: 8.0,
                          contentPadding: EdgeInsets.symmetric(horizontal: 3.0),
                          leading: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.grey[200],
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/illustrations/ai-yield-data.png'),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          title: Text(
                            'AI Yield Data',
                            style: TextStyle(fontSize: 11),
                          ),
                          subtitle: Text(''),
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
                          },
                        ),
                      ),
                    ],
                  ),
                  5.height,
                  Container(
                    //height: height(context) * 0.14,
                    width: width(context),
                    padding: const EdgeInsets.all(4.0),
                    constraints:
                        BoxConstraints(minHeight: height(context) * 0.14),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffd68060),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 2.0),
                          child: Text(
                            'Ideal temperature for planting warm season plants',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                              '- Warm season plants, such as cotton, rice and sugarcane, germinate best in temperatures between 21 to 30°C.(70 to 86F)'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //height: height(context) * 0.14,
                    width: width(context),
                    //padding: const EdgeInsets.all(4.0),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                    constraints:
                        BoxConstraints(minHeight: height(context) * 0.14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.orange.shade100,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2),
                            child: Text('Do not spray: No winds',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14)),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                                '- Still air may lead to vapor drift where finer droplets remain suspended in the air, prone to evaporation and drift long after spraying is completed.'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    //height: height(context) * 0.14,
                    width: width(context),
                    padding: const EdgeInsets.all(4.0),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                    constraints:
                        BoxConstraints(minHeight: height(context) * 0.14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffa6b1e1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 4),
                          child: Text('Irrigate now',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child:
                              Text('- Hot and dry conditons. Water all crops.'),
                        ),
                      ],
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Flexible(
                  //       flex: 1,
                  //       child: ListTile(
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12.0),
                  //         ),
                  //         tileColor: Colors.white,
                  //         horizontalTitleGap: 8.0,
                  //         contentPadding: EdgeInsets.symmetric(horizontal: 3.0),
                  //         leading: Container(
                  //           height: 40.0,
                  //           width: 40.0,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(30.0),
                  //             color: Colors.grey[200],
                  //             image: DecorationImage(
                  //               image: AssetImage(
                  //                   'assets/illustrations/soil-quality-index.png'),
                  //               fit: BoxFit.fitHeight,
                  //             ),
                  //           ),
                  //         ),
                  //         title: Text(
                  //           'Soil Moisture At 0-1 cm',
                  //           style: TextStyle(fontSize: 11),
                  //         ),
                  //         subtitle: Text(''),
                  //         onTap: () {
                  //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
                  //         },
                  //       ),
                  //     ),
                  //     5.width,
                  //     Flexible(
                  //       flex: 1,
                  //       child: ListTile(
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12.0),
                  //         ),
                  //         tileColor: Colors.white,
                  //         horizontalTitleGap: 8.0,
                  //         contentPadding: EdgeInsets.symmetric(horizontal: 3.0),
                  //         leading: Container(
                  //           height: 40.0,
                  //           width: 40.0,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(30.0),
                  //             color: Colors.grey[200],
                  //             image: DecorationImage(
                  //               image: AssetImage(
                  //                   'assets/illustrations/soil-quality-index.png'),
                  //               fit: BoxFit.fitHeight,
                  //             ),
                  //           ),
                  //         ),
                  //         title: Text(
                  //           'Soil Moisture At 1-3 cm',
                  //           style: TextStyle(fontSize: 11),
                  //         ),
                  //         subtitle: Text(''),
                  //         onTap: () {
                  //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // 5.height,
                  // Row(
                  //   children: [
                  //     Flexible(
                  //       flex: 1,
                  //       child: ListTile(
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12.0),
                  //         ),
                  //         tileColor: Colors.white,
                  //         horizontalTitleGap: 8.0,
                  //         contentPadding: EdgeInsets.symmetric(horizontal: 3.0),
                  //         leading: Container(
                  //           height: 40.0,
                  //           width: 40.0,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(30.0),
                  //             color: Colors.grey[200],
                  //             image: DecorationImage(
                  //               image: AssetImage(
                  //                   'assets/illustrations/soil-quality-index.png'),
                  //               fit: BoxFit.fitHeight,
                  //             ),
                  //           ),
                  //         ),
                  //         title: Text(
                  //           'Soil Moisture At 27-81 cm',
                  //           style: TextStyle(fontSize: 11),
                  //         ),
                  //         subtitle: Text(''),
                  //         onTap: () {
                  //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
                  //         },
                  //       ),
                  //     ),
                  //     5.width,
                  //     Flexible(
                  //       flex: 1,
                  //       child: ListTile(
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12.0),
                  //         ),
                  //         tileColor: Colors.white,
                  //         horizontalTitleGap: 8.0,
                  //         contentPadding: EdgeInsets.symmetric(horizontal: 3.0),
                  //         leading: Container(
                  //           height: 40.0,
                  //           width: 40.0,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(30.0),
                  //             color: Colors.grey[200],
                  //             image: DecorationImage(
                  //               image: AssetImage(
                  //                   'assets/illustrations/soil-quality-index.png'),
                  //               fit: BoxFit.fitHeight,
                  //             ),
                  //           ),
                  //         ),
                  //         title: Text(
                  //           'Soil Temperature At 0 cm',
                  //           style: TextStyle(fontSize: 11),
                  //         ),
                  //         subtitle: Text(''),
                  //         onTap: () {
                  //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // 5.height,
                  // Row(
                  //   children: [
                  //     Flexible(
                  //       flex: 1,
                  //       child: ListTile(
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12.0),
                  //         ),
                  //         tileColor: Colors.white,
                  //         horizontalTitleGap: 8.0,
                  //         contentPadding: EdgeInsets.symmetric(horizontal: 3.0),
                  //         leading: Container(
                  //           height: 40.0,
                  //           width: 40.0,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(30.0),
                  //             color: Colors.grey[200],
                  //             image: DecorationImage(
                  //               image: AssetImage(
                  //                   'assets/illustrations/soil-quality-index.png'),
                  //               fit: BoxFit.fitHeight,
                  //             ),
                  //           ),
                  //         ),
                  //         title: Text(
                  //           'Soil Temperature At 6 cm',
                  //           style: TextStyle(fontSize: 11),
                  //         ),
                  //         subtitle: Text(''),
                  //         onTap: () {
                  //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
                  //         },
                  //       ),
                  //     ),
                  //     5.width,
                  //     Flexible(
                  //       flex: 1,
                  //       child: ListTile(
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12.0),
                  //         ),
                  //         tileColor: Colors.white,
                  //         horizontalTitleGap: 8.0,
                  //         contentPadding: EdgeInsets.symmetric(horizontal: 3.0),
                  //         leading: Container(
                  //           height: 40.0,
                  //           width: 40.0,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(30.0),
                  //             color: Colors.grey[200],
                  //             image: DecorationImage(
                  //               image: AssetImage(
                  //                   'assets/illustrations/soil-quality-index.png'),
                  //               fit: BoxFit.fitHeight,
                  //             ),
                  //           ),
                  //         ),
                  //         title: Text('Soil Temperature At 54 cm',
                  //             style: TextStyle(fontSize: 11),
                  //             overflow: TextOverflow.clip),
                  //         subtitle: Text(''),
                  //         onTap: () {
                  //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // 5.height,
                  // Row(
                  //   children: [
                  //     Flexible(
                  //       flex: 1,
                  //       child: ListTile(
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12.0),
                  //         ),
                  //         tileColor: Colors.white,
                  //         horizontalTitleGap: 8.0,
                  //         contentPadding: EdgeInsets.symmetric(horizontal: 3.0),
                  //         leading: Container(
                  //           height: 40.0,
                  //           width: 40.0,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(30.0),
                  //             color: Colors.grey[200],
                  //             image: DecorationImage(
                  //               image: AssetImage(
                  //                   'assets/illustrations/soil-quality-index.png'),
                  //               fit: BoxFit.fitHeight,
                  //             ),
                  //           ),
                  //         ),
                  //         title: Text('Temperature At 2m',
                  //             style: TextStyle(fontSize: 11)),
                  //         subtitle: Text(''),
                  //         onTap: () {
                  //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
                  //         },
                  //       ),
                  //     ),
                  //     5.width,
                  //     Flexible(
                  //       flex: 1,
                  //       child: ListTile(
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12.0),
                  //         ),
                  //         tileColor: Colors.white,
                  //         horizontalTitleGap: 8.0,
                  //         contentPadding: EdgeInsets.symmetric(horizontal: 3.0),
                  //         leading: Container(
                  //           height: 40.0,
                  //           width: 40.0,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(30.0),
                  //             color: Colors.grey[200],
                  //             image: DecorationImage(
                  //               image: AssetImage(
                  //                   'assets/illustrations/soil-quality-index.png'),
                  //               fit: BoxFit.fitHeight,
                  //             ),
                  //           ),
                  //         ),
                  //         title: Text(
                  //           'UV Index',
                  //           style: TextStyle(fontSize: 11),
                  //           maxLines: 1,
                  //         ),
                  //         subtitle: Text(''),
                  //         onTap: () {
                  //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyWebView(poly_Id: idValue[index]['ACTION'],uid:uid)));
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // 5.height,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/
// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

abstract class GoogleMapExampleAppPage extends StatelessWidget {
  const GoogleMapExampleAppPage(this.leading, this.title);

  final Widget leading;
  final String title;
}

class TileOverlayPage extends GoogleMapExampleAppPage {
  const TileOverlayPage() : super(const Icon(Icons.map), 'Tile overlay');

  @override
  Widget build(BuildContext context) {
    return const TileOverlayBody();
  }
}

class TileOverlayBody extends StatefulWidget {
  const TileOverlayBody();

  @override
  State<StatefulWidget> createState() => TileOverlayBodyState();
}

class TileOverlayBodyState extends State<TileOverlayBody> {
  TileOverlayBodyState();

  GoogleMapController controller;
  TileOverlay _tileOverlay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addTileOverlay();
  }

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addTileOverlay() {
    final TileOverlay tileOverlay = TileOverlay(
      tileOverlayId: const TileOverlayId('tile_overlay_1'),
      tileProvider: _DebugTileProvider(),
    );
    setState(() {
      _tileOverlay = tileOverlay;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Set<TileOverlay> overlays = <TileOverlay>{
      if (_tileOverlay != null) _tileOverlay,
    };
    _addTileOverlay();
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(25.138948, 121.502828),
          zoom: 2.0,
        ),
        tileOverlays: overlays,
        onMapCreated: _onMapCreated,
      ),
    );
  }
}

class _DebugTileProvider implements TileProvider {
  _DebugTileProvider() {
    boxPaint.isAntiAlias = true;
    boxPaint.color = Colors.transparent;
    boxPaint.style = PaintingStyle.stroke;
  }

  static const int width = 256;
  static const int height = 256;
  static final Paint boxPaint = Paint();
  static const TextStyle textStyle = TextStyle(
    color: Colors.red,
    fontSize: 20,
  );

  @override
  Future<Tile> getTile(int x, int y, int zoom) async {
    print("getTile currentZoom $zoom");
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final paint = Paint()..color = Colors.red.withOpacity(0.3);
    //ui.Image images = await getAssetImage('assets/test.png');
    ui.Image images = await getAssetImage('assets/tiles/$zoom/$x/$y.png');
    paint.color = Color.fromRGBO(0, 0, 0, 0.8);
    canvas.drawImage(images, Offset(0, 0), paint);

    // String path = 'assets/tiles/$zoom/$x/$y.png';
    // bool directoryExists = await Directory(path).exists();
    // bool fileExists = await File(path).exists();
    // if (directoryExists || fileExists) {
    //   // do stuff
    // } else {
    //
    // }

    final ui.Picture picture = recorder.endRecording();
    final Uint8List byteData = await picture
        .toImage(width, height)
        .then((ui.Image image) =>
        image.toByteData(format: ui.ImageByteFormat.png))
        .then((ByteData byteData) => byteData.buffer.asUint8List());
    return Tile(width, height, byteData);
  }
}

Future<ui.Image> getAssetImage(String asset, {width, height}) async {
  var response =  await http.get(Uri.parse('https://images.pexels.com/photos/235615/pexels-photo-235615.jpeg?auto=compress&cs=tinysrgb&w=256&h=256&dpr=1'));
 // ByteData data = await rootBundle.load(asset);
  ui.Codec codec = await ui.instantiateImageCodec(response.bodyBytes,allowUpscaling: false,
      targetWidth: width, targetHeight: height);
  ui.FrameInfo fi = await codec.getNextFrame();
  return fi.image;
}