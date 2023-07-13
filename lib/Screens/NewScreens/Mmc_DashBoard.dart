import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constant/Constant.dart';

class MmcCard extends StatefulWidget {
  const MmcCard({Key key}) : super(key: key);

  @override
  State<MmcCard> createState() => _MmcCardState();
}

class _MmcCardState extends State<MmcCard> with TickerProviderStateMixin {
  var height1 = 100.0;
  var height2 = 100.0;
  bool isVisible = false;
  int turns = 0;
  var showCoords = false;
  var loadingTime = false;
  TabController _tabController;
  var grid = false;
  double currentZoom = 12.0;
  MapController mapController = MapController();
  LatLng currentCenter = LatLng(18.106976125,75.198790468);
  var filledPoints = <LatLng>[];
  String farmValue,farmId;
  FocusNode farmFocusMode = FocusNode();
  var bounds;
  List<String> farmIdList = [], farmNameList = [];
  var farmarea,cropname,standardYield;
  @override
  void initState() {
    // TODO: implement initState
    getFarms();
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  void _zoomPlus() {
    currentZoom = currentZoom + 1;
    mapController.move(currentCenter, currentZoom);
   // _tabController.animateTo(0);
  }

  void _zoomMinus() {
    currentZoom = currentZoom - 1;
    mapController.move(currentCenter, currentZoom);
    //_tabController.animateTo(1);
  }
  getFarms()async{
    farmIdList.clear();
    farmNameList.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var api_key = prefs.getString('api_key');
    //getCrops(api_key);
    var url = 'https://api.mapmycrop.com/farm/?api_key=$api_key';
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    //print(response.statusCode);
    //print(data[0]['name']);

    for(int i=0;i<data['features'].length;i++){
      setState(() {
        farmNameList.add(data[i]['name']);
        farmIdList.add(data[i]['id']);
        //farmIdList
      });
    }
    //print(response.body);
    print(farmNameList);

  }
  getTemperature() async{
    var response = await http.get(Uri.parse(''));
  }
  expandContainer(){
    if(height1==50.0){
      setState(() {
        height1 = 150;
        turns = 2;
      });
    }else{
      setState(() {
        height1 = 100;
        turns = 0;
      });
    }
  }
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
 // TabController _tabController = TabController(length: 3, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey,
     // appBar: AppBar(),
      body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40,),
                Container(
                  padding: EdgeInsets.all(8),
                  height: 450,
                  child: Stack(fit: StackFit.passthrough,
                      alignment: Alignment.topCenter,
                      children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: FlutterMap(
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
                    ),
                    Column(
                      children: [
                        SizedBox(height: 15,),
                        Container(
                          padding: EdgeInsets.only(left:30),
                          width: width(context)*0.6,
                          height: height(context)*0.05,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              // side: BorderSide(
                              //     width: 1.0, style: BorderStyle.solid),
                              borderRadius:
                              BorderRadius.all(Radius.circular(12.0)),
                            ),
                          ),
                          child: farmNameList.isNotEmpty?DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              focusNode: farmFocusMode,
                              alignment: Alignment.center,
                              menuMaxHeight:400,
                              hint: Center(child: Text('Select Farm',style: TextStyle(color: Colors.black),)),
                              value: farmValue,
                              elevation: 25,
                              //isExpanded: true,
                              icon: Container(
                                height:45,
                                width:35,

                                  decoration: BoxDecoration(
                                border: Border.all(color:Color(0xffECB34F),width:1),
                                borderRadius: BorderRadius.circular(12)
                              ),child: Icon(Icons.keyboard_arrow_down_outlined,color:Color(0xffECB34F))),
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
                                  farmValue = newvalue;
                                  farmId = farmIdList[index];
                                });
                                print(farmIdList);
                                //print(farm);
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
                        SizedBox(height: 15,),
                        // Container(
                        //   height: height(context)*0.035,
                        //   width: width(context)*0.6,
                        //   decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       border: Border.all(color: Color(0xffF6D9A7),width:1),
                        //       // color: Color(0xffF6D9A7),
                        //       borderRadius: BorderRadius.circular(10)
                        //   ),
                        // )
                      ],
                    ),
                    Positioned(
                         // alignment: Alignment.topLeft,
                      top: 15,
                          left: 20,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Colors.white,
                                ),
                                child: MaterialButton(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  onPressed: () {
                                    _zoomPlus();
                                  },
                                  child:
                                  Icon(Icons.add,color: Colors.orange,),
                                  //color: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Colors.white,
                                ),
                                child: MaterialButton(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  onPressed: () {
                                    _zoomMinus();
                                  },
                                  child: Icon(Icons.remove,color: Colors.orange,),
                                  //color: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Colors.white,
                                ),
                                child: MaterialButton(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  onPressed: () {
                                    _zoomMinus();
                                  },
                                  child: Icon(Icons.push_pin_outlined,color: Colors.orange,),
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
                Container(
                  height: height(context)*0.2,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context,index)=>Container(
                      margin:EdgeInsets.symmetric(horizontal: 10),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            children: [//F6D9A7
                              SizedBox(
                                height: MediaQuery.of(context).size.height*0.035,
                              ),
                              Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Color(0xffF6D9A7), Color(0xffF6D9A7).withOpacity(0.1)]
                                  ),
                                ),
                                child: Container(
                                  height:MediaQuery.of(context).size.height*0.15,
                                  width: MediaQuery.of(context).size.width*0.25,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Color(0xffF6D9A7),
                                        //width: 2
                                      ),
                                      boxShadow: [
                                        BoxShadow(spreadRadius: 6,blurRadius: 12,color: Color(0xff7C7C7C).withAlpha(30))
                                      ]
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.cloud_queue,color: Colors.orange,),
                                          SizedBox(width: 5,),
                                          Text('64.73',style: TextStyle(
                                              fontSize: 16,color: Colors.orange
                                          ),)
                                        ],
                                      ),
                                      Expanded(child: SizedBox(),),
                                      Container(
                                        height: MediaQuery.of(context).size.height*0.06,
                                        decoration: BoxDecoration(
                                            color: Color(0xffF6D9A7),
                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                                        ),
                                        child: Center(
                                          child: Text(
                                            "May 25\n 2023",
                                            style: TextStyle(
                                                color: Color(0xff0D0D0D),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                          Positioned(
                              top: 0,
                              child: Container(
                                height: MediaQuery.of(context).size.height*0.075,
                                width: MediaQuery.of(context).size.height*0.075,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*0.05),
                                    boxShadow: [
                                      BoxShadow(spreadRadius: 5,blurRadius: 12,color: Color(0xff7C7C7C).withAlpha(25))
                                    ]
                                ),
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.satellite_alt_outlined,color: Color(0xff7C7C7C),size: 18,),
                                    SizedBox(height: 5,),
                                    Text('S3',style: TextStyle(fontSize: 12,color: Color(0xff7C7C7C)),)

                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  width: width(context)*0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15) ,
                    color: Colors.white,
                  ),

                 height: height1,
                  duration: Duration(seconds: 1),
                  child:Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: (){

                              setState((){
                                isVisible = false;
                              });

                            },
                              child: ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.asset('assets/images/soilMoisture.jpg',height: 100,width: 100,fit: BoxFit.fill))),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 25,),
                                Text('Farm Analysis Data',style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff0d0d0d),
                                    fontWeight: FontWeight.w600
                                ),),
                                RotatedBox(quarterTurns: turns,
                                  child: IconButton(
                                    onPressed: (){
                                      setState((){
                                        isVisible = !isVisible;
                                      });
                                      if(height1==100.0){
                                        setState(() {
                                          height1 = (height(context)*0.24*(12/3));
                                          turns = 2;
                                        });
                                      }else{
                                        setState(() {
                                          height1 = 100;
                                          turns = 0;
                                        });
                                      }
                                    },
                                    icon: Icon(Icons.keyboard_double_arrow_down_outlined,color: Color(0xffF6D9A7),),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),height1==(height(context)*0.24*(12/3))?Container(
                          height: height1-100,
                          child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: 0.75),
                              physics: NeverScrollableScrollPhysics(),

                              // scrollDirection: Axis.horizontal,
                              itemCount: 12,
                              itemBuilder: (context,index)=>Container(
                                  margin:EdgeInsets.symmetric(horizontal: 10),
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Column(
                                          children: [//F6D9A7
                                            SizedBox(
                                              height: MediaQuery.of(context).size.height*0.035,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(1),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [Color(0xffF6D9A7), Color(0xffF6D9A7).withOpacity(0.1)]
                                                ),
                                              ),
                                              child: Container(
                                                height:MediaQuery.of(context).size.height*0.16,
                                                width: MediaQuery.of(context).size.width*0.3,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(15),
                                                    border: Border.all(
                                                      color: Color(0xffF6D9A7),
                                                      //width: 2
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(spreadRadius: 6,blurRadius: 12,color: Color(0xff7C7C7C).withAlpha(30))
                                                    ]
                                                ),
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                                                    Text('Generic Farm\nScore',style: TextStyle(fontSize: 12,fontWeight:FontWeight.w600),textAlign: TextAlign.center,),
                                                    Expanded(child: SizedBox(),),
                                                    Container(
                                                      height: MediaQuery.of(context).size.height*0.06,
                                                      decoration: BoxDecoration(
                                                          color: Color(0xffF6D9A7),
                                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "09/10",
                                                          style: TextStyle(
                                                              color: Color(0xff0D0D0D),
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                        Positioned(
                                            top: 0,
                                            child: Container(
                                                height: MediaQuery.of(context).size.height*0.075,
                                                width: MediaQuery.of(context).size.height*0.075,
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*0.05),
                                                    boxShadow: [
                                                      BoxShadow(spreadRadius: 5,blurRadius: 12,color: Color(0xff7C7C7C).withAlpha(45))
                                                    ]
                                                ),
                                                child: SvgPicture.asset('assets/svgImages/${index+1}.svg',
                                                  // height: MediaQuery.of(context).size.height*0.04,
                                                  // width: MediaQuery.of(context).size.height*0.04,
                                                  // fit: BoxFit.fill,
                                                )
                                            ))
                                      ]
                                  )
                              )
                          )
                      ):Container(),
                                         ],
                  ),
                ),

                /*Container(
                  height: height(context)*0.5,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: 0.75),

                   // scrollDirection: Axis.horizontal,
                    itemCount: 12,
                    itemBuilder: (context,index)=>Container(
                      margin:EdgeInsets.symmetric(horizontal: 10),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            children: [//F6D9A7
                              SizedBox(
                                height: MediaQuery.of(context).size.height*0.035,
                              ),
                              Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Color(0xffF6D9A7), Color(0xffF6D9A7).withOpacity(0.1)]
                                  ),
                                ),
                                child: Container(
                                  height:MediaQuery.of(context).size.height*0.16,
                                  width: MediaQuery.of(context).size.width*0.3,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Color(0xffF6D9A7),
                                        //width: 2
                                      ),
                                      boxShadow: [
                                        BoxShadow(spreadRadius: 6,blurRadius: 12,color: Color(0xff7C7C7C).withAlpha(30))
                                      ]
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                                      Text('Generic Farm\nScore',style: TextStyle(fontSize: 12,fontWeight:FontWeight.w600),textAlign: TextAlign.center,),
                                      Expanded(child: SizedBox(),),
                                      Container(
                                        height: MediaQuery.of(context).size.height*0.06,
                                        decoration: BoxDecoration(
                                            color: Color(0xffF6D9A7),
                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                                        ),
                                        child: Center(
                                          child: Text(
                                            "09/10",
                                            style: TextStyle(
                                                color: Color(0xff0D0D0D),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                          Positioned(
                              top: 0,
                              child: Container(
                                height: MediaQuery.of(context).size.height*0.075,
                                width: MediaQuery.of(context).size.height*0.075,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*0.05),
                                    boxShadow: [
                                      BoxShadow(spreadRadius: 5,blurRadius: 12,color: Color(0xff7C7C7C).withAlpha(45))
                                    ]
                                ),
                                child: SvgPicture.asset('assets/svgImages/${index+1}.svg',
                                  // height: MediaQuery.of(context).size.height*0.04,
                                  // width: MediaQuery.of(context).size.height*0.04,
                                  // fit: BoxFit.fill,
                                )
                              ))
                        ]
                      )
                    )
                  )
                ),*/

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: (){
                      if(_tabController.index==1){
                        _tabController.animateTo(0);
                      }
                    }, icon: Icon(Icons.arrow_back_ios_new,size : 30,color:Color(0xffECB34F)),),
                   // Icon(Icons.arrow_back_ios_new,size : 15),
                    Container(
                      width: width(context)*0.7,
                      child: TabBar(
                        controller: _tabController,
                       //indicator: Indicator
                       indicatorColor: Color(0xffF6D9A7),
                       // dividerColor: Colors.transparent,
                        tabs: <Widget>[
                          Tab(
                            child: Text('Soil Moisture',style: TextStyle(fontSize: 14,color:Color(0xff482919),fontWeight:FontWeight.w600),textAlign: TextAlign.center,),
                            //text: 'Soil Moisture',
                            //icon: Icon(Icons.flight),
                          ),
                          Tab(
                            child: Text('Temperature',style: TextStyle(fontSize: 14,color:Color(0xff482919),fontWeight:FontWeight.w600),textAlign: TextAlign.center,),
                           // icon: Icon(Icons.luggage),
                          ),

                        ],
                      ),

                    ),
                    IconButton(onPressed: (){
                      if(_tabController.index==0){
                        _tabController.animateTo(1);
                      }
                    }, icon: Icon(Icons.arrow_forward_ios,size : 30,color:Color(0xffECB34F)),),
                  ],
                ),
                Container(
                  width: width(context) * 0.9,
                  height: height(context)*0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12)
                  ),

                  child: TabBarView(
                    controller: _tabController,
                    children:  <Widget>[
                     Card(
                       shape: new RoundedRectangleBorder(
                         borderRadius: BorderRadius.all(Radius.circular(12.0)),
                         //side: BorderSide(color: Colors.white)
                       ),
                       child: Padding(
                         padding: const EdgeInsets.symmetric(vertical:12.0,horizontal : 25),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Text('Soil Moisture',style: TextStyle(fontSize: 18,color:Color(0xff482919),fontWeight:FontWeight.bold),textAlign: TextAlign.center,),
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Image.asset('assets/svgImages/Soil1.png',fit: BoxFit.fill,),
                                 Column(
                                   children: [
                                     SizedBox(height: height(context)*0.043),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Text('   00 cm > ',style: TextStyle(fontSize: 10,fontWeight:FontWeight.w600,color:Color(0xff0d0d0d))),
                                         Text('  0.462 m3m3',style: TextStyle(fontSize: 12,fontWeight:FontWeight.w600,color:Color(0xff684624)))
                                       ],
                                     ),
                                     SizedBox(height: height(context)*0.009),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Text('   00 cm > ',style: TextStyle(fontSize: 10,fontWeight:FontWeight.w600,color:Color(0xff0d0d0d))),
                                         Text('  0.462 m3m3',style: TextStyle(fontSize: 12,fontWeight:FontWeight.w600,color:Color(0xff684624)))
                                       ],
                                     ),
                                     SizedBox(height: height(context)*0.009),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Text('   00 cm > ',style: TextStyle(fontSize: 10,fontWeight:FontWeight.w600,color:Color(0xff0d0d0d))),
                                         Text('  0.462 m3m3',style: TextStyle(fontSize: 12,fontWeight:FontWeight.w600,color:Color(0xff684624)))
                                       ],
                                     ),
                                     SizedBox(height: height(context)*0.015),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Text('   00 cm > ',style: TextStyle(fontSize: 10,fontWeight:FontWeight.w600,color:Color(0xff0d0d0d))),
                                         Text('  0.462 m3m3',style: TextStyle(fontSize: 12,fontWeight:FontWeight.w600,color:Color(0xff684624)))
                                       ],
                                     ),
                                     SizedBox(height: height(context)*0.025),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Text('   00 cm > ',style: TextStyle(fontSize: 10,fontWeight:FontWeight.w600,color:Color(0xff0d0d0d))),
                                         Text('  0.462 m3m3',style: TextStyle(fontSize: 12,fontWeight:FontWeight.w600,color:Color(0xff684624)))
                                       ],
                                     ),
                                     SizedBox(height: height(context)*0.04),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Text('   00 cm > ',style: TextStyle(fontSize: 10,fontWeight:FontWeight.w600,color:Color(0xff0d0d0d))),
                                         Text('  0.462 m3m3',style: TextStyle(fontSize: 12,fontWeight:FontWeight.w600,color:Color(0xff684624)))
                                       ],
                                     ),
                                   ],
                                 )

                               ],
                             )
                           ],
                         ),
                       ),
                     ),
                      Card(
                        shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          //side: BorderSide(color: Colors.white)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical:12.0,horizontal : 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Soil Tempereture',style: TextStyle(fontSize: 18,color:Color(0xff482919), fontWeight:FontWeight.bold),textAlign: TextAlign.center,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset('assets/svgImages/Temperature.png',fit: BoxFit.fill,),
                                  Column(
                                    children: [
                                      SizedBox(height: height(context)*0.043),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('   00 cm > ',style: TextStyle(fontSize: 10,fontWeight:FontWeight.w600,color:Color(0xff0d0d0d))),
                                          Text('  0.462 m3m3',style: TextStyle(fontSize: 12,fontWeight:FontWeight.w600,color:Color(0xff684624)))
                                        ],
                                      ),
                                      SizedBox(height: height(context)*0.075),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('   00 cm > ',style: TextStyle(fontSize: 10,fontWeight:FontWeight.w600,color:Color(0xff0d0d0d))),
                                          Text('  0.462 m3m3',style: TextStyle(fontSize: 12,fontWeight:FontWeight.w600,color:Color(0xff684624)))
                                        ],
                                      ),
                                      SizedBox(height: height(context)*0.085),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('   00 cm > ',style: TextStyle(fontSize: 10,fontWeight:FontWeight.w600,color:Color(0xff0d0d0d))),
                                          Text('  0.462 m3m3',style: TextStyle(fontSize: 12,fontWeight:FontWeight.w600,color:Color(0xff684624)))
                                        ],
                                      ),

                                    ],
                                  )

                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  width: width(context)*0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15) ,
                    color: Colors.white,
                  ),

                  height: height2!=100?height2+100:height2,
                  duration: Duration(seconds: 1),
                  child:Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: (){



                              },
                              child: ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.asset('assets/images/soilMoisture.jpg',height: 100,width: 100,fit: BoxFit.fill))),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 25,),
                                Text('Farm Analysis Data',style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff0d0d0d),
                                    fontWeight: FontWeight.w600
                                ),),
                                RotatedBox(quarterTurns: turns,
                                  child: IconButton(
                                    onPressed: (){
                                      setState((){
                                        isVisible = !isVisible;
                                      });
                                      if(height2==100){
                                        setState(() {
                                          height2 = height(context)*0.33*12;
                                          turns = 2;
                                        });
                                      }else{
                                        setState(() {
                                          height2 = 100;
                                          turns = 0;
                                        });
                                      }
                                    },
                                    icon: Icon(Icons.keyboard_double_arrow_down_outlined,color: Color(0xffF6D9A7),),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),height2!=100?Container(
                        height:height2,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 12,
                            itemBuilder: (context,index)=>Container(
                          height: height(context)*0.33,
                          width: width(context)*0.9,
                          //padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            // color: Colors.white
                          ),
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top:10.0),
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: height(context)*0.08,

                                      decoration: BoxDecoration(
                                        color: Color(0xffF6D9A7),
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text('Ideal temperature for planting warm season plants',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration:BoxDecoration(
                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(15),bottomLeft: Radius.circular(15)),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Text('Warm season plants such as cotton, sugarcane and rice germinate best in temperature between 210c to 300c (70F to 86F)',style: TextStyle(fontWeight:FontWeight.w600),textAlign: TextAlign.justify,),
                                          ),
                                          Card(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(15),bottomLeft: Radius.circular(15))),
                                            //elevation: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 6,
                                                    width: 6,
                                                    margin: EdgeInsets.only(right: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(3),
                                                        color: Colors.green
                                                    ),

                                                  ),
                                                  Text('Last update\n09:50 AM',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
                                                  Expanded(
                                                    child: SizedBox(),
                                                  ),
                                                  Container(
                                                    height: height(context)*0.05,
                                                    width: width(context)*0.38,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(height(context)*0.04),
                                                      border: Border.all(color: Colors.green),
                                                      // color: Colors.green
                                                    ),
                                                    child: Center(child: Text('Refresh',style: TextStyle(color: Colors.green,fontSize: 12),),),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),

                                    )

                                  ],
                                ),
                              ),
                              Positioned(
                                right: width(context)*0.08,
                                top:0,
                                child: Container(
                                    padding: EdgeInsets.only(bottom: 4),
                                    height: 23,
                                    width: 23,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(color: Color(0xff0d0d0d),width: 2),
                                      // color: Color(0xff66cb65),
                                      color: Color(0xffff56f5f),
                                    ),
                                    child: Center(child: Text('!',style:TextStyle(color: Color(0xff0d0d0d),fontSize: 16,fontWeight: FontWeight.bold)))),
                              )

                            ],
                          ),
                        )
                        ),
                      ):Container(),
                    ],
                  ),
                ),

               /* Container(
                  height: height(context)*0.3,
                  width: width(context)*0.9,
                  //padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // color: Colors.white
                  ),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top:10.0),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: height(context)*0.08,

                              decoration: BoxDecoration(
                                color: Color(0xffF6D9A7),
                                borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text('Ideal temperature for planting warm season plants',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                                ),
                              ),
                            ),
                            Container(
                              decoration:BoxDecoration(
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(15),bottomLeft: Radius.circular(15)),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text('Warm season plants such as cotton, sugarcane and rice germinate best in temperature between 210c to 300c (70F to 86F)',style: TextStyle(fontWeight:FontWeight.w600),textAlign: TextAlign.justify,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 6,
                                          width: 6,
                                          margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(3),
                                              color: Colors.green
                                          ),

                                        ),
                                        Text('Last update\n09:50 AM',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),
                                        Expanded(
                                          child: SizedBox(),
                                        ),
                                        Container(
                                          height: height(context)*0.05,
                                          width: width(context)*0.38,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(height(context)*0.04),
                                            border: Border.all(color: Colors.green),
                                            // color: Colors.green
                                          ),
                                          child: Center(child: Text('Refresh',style: TextStyle(color: Colors.green,fontSize: 12),),),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),

                            )

                          ],
                        ),
                      ),
                      Positioned(
                        right: width(context)*0.08,
                        top:0,
                        child: Container(
                            padding: EdgeInsets.only(bottom: 4),
                            height: 23,
                            width: 23,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(color: Color(0xff0d0d0d),width: 2),
                              // color: Color(0xff66cb65),
                               color: Color(0xffff56f5f),
                            ),
                            child: Center(child: Text('!',style:TextStyle(color: Color(0xff0d0d0d),fontSize: 16,fontWeight: FontWeight.bold)))),
                      )

                    ],
                  ),
                ),*/

              ],
            ),
          )
      ),
    );
  }
}
