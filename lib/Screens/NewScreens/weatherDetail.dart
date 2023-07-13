/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

import '../../Widgets/Loading.dart';
import '../../main.dart';
import '../constant/Constant.dart';

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp>
    with SingleTickerProviderStateMixin {
  String key = 'da6224bdf8c5bb0b0ce5ea9838d86c54';
  WeatherFactory ws;
  List<Weather> _data = [];
  AppState _state = AppState.NOT_DOWNLOADED;
  double lat, lon;
  Position position;
  String Address;
  String bgImg;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(key);
    _tabController = TabController(length: 3, vsync: this);
    fetchweather();
  }

  Future<void> fetchweather() async {
    Position position = await _getGeoLocationPosition();
    queryForecast(position); //queryWeather(position);
    GetAddressFromLatLong(position);
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
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
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    //Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    Address = '${place.subAdministrativeArea}';
    //print(Address);
    setState(() {});
  }

  void queryForecast(Position position) async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _state = AppState.DOWNLOADING;
    });

    List<Weather> forecasts = await ws.fiveDayForecastByLocation(
        position.latitude, position.longitude);
    setState(() {
      _data = forecasts;
      _state = AppState.FINISHED_DOWNLOADING;
      print(_data);
    });
  }

  void queryWeather(Position position) async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _state = AppState.DOWNLOADING;
    });

    Weather weather = await ws.currentWeatherByLocation(
        position.latitude, position.longitude);
    setState(() {
      _data = [weather];
      _state = AppState.FINISHED_DOWNLOADING;
      print(_data);
    });
  }

  Widget contentFinishedDownload() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            //height: height(context)*0.30,

            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    //mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_off_rounded,size: height(context) * 0.018,),
                          Text("Mahalunge",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: height(context) * 0.023))
                        ],
                      ),
                    ],
                  ),
                  Text("Thu, 6 April 9:10 am",
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.grey,fontSize: height(context)*0.013)),
                  Row(
                    children: [
                      Image.network(
                        'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                        height: height(context) * 0.08,
                      ),
                      Text(
                        "27",
                        style: TextStyle(fontSize: height(context) * 0.06),
                      ),
                      Expanded(child: Text('')),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Party Cloudy',
                            textAlign: TextAlign.end,
                          ),
                          Text(
                            '36 / 24',
                            textAlign: TextAlign.end,
                          ),
                          Text(
                            'Feels like 28',
                            textAlign: TextAlign.end,
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("9:30 am", style: TextStyle(color: Colors.grey)),
                          Image.network(
                            'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                            height: height(context) * 0.035,
                          ),
                          Text("29",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          Row(
                            children: [
                              Icon(Icons.water_drop_outlined,
                                  size: 15, color: Colors.lightBlueAccent),
                              Text(
                                "0%",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text("10:30 am",
                              style: TextStyle(color: Colors.grey)),
                          Image.network(
                            'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                            height: height(context) * 0.035,
                          ),
                          Text("29",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          Row(
                            children: [
                              Icon(Icons.water_drop_outlined,
                                  size: 15, color: Colors.lightBlueAccent),
                              Text(
                                "0%",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text("11:30 am",
                              style: TextStyle(color: Colors.grey)),
                          Image.network(
                            'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                            height: height(context) * 0.035,
                          ),
                          Text("29",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          Row(
                            children: [
                              Icon(Icons.water_drop_outlined,
                                  size: 15, color: Colors.lightBlueAccent),
                              Text(
                                "0%",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text("12:30 pm",
                              style: TextStyle(color: Colors.grey)),
                          Image.network(
                            'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                            height: height(context) * 0.035,
                          ),
                          Text("29",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          Row(
                            children: [
                              Icon(Icons.water_drop_outlined,
                                  size: 15, color: Colors.lightBlueAccent),
                              Text(
                                "0%",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Card(
            elevation: 1,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Yesterday",style: TextStyle(color: Colors.grey)),
                        Text("36/22",style: TextStyle(color: Colors.grey)),


                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(context)*0.21,
                          child: Text("Today",style: TextStyle(fontWeight: FontWeight.w900)),

                        ),                        Row(children: [
                          Icon(Icons.water_drop_outlined,size: 13,color: Colors.lightBlueAccent.shade700,),
                          Text('1%',style: TextStyle(color: Colors.grey))
                        ],),
                        Row(
                          children: [
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                          ],
                        ),

                        Text("36/22",style: TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(context)*0.21,
                          child: Text("Friday",style: TextStyle(fontWeight: FontWeight.w900)),

                        ),                        Row(children: [
                          Icon(Icons.water_drop_outlined,size: 13,color: Colors.lightBlueAccent.shade700,),
                          Text('1%',style: TextStyle(color: Colors.grey))
                        ],),
                        Row(
                          children: [
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                          ],
                        ),

                        Text("36/22",style: TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(context)*0.21,
                          child: Text("Saturday",style: TextStyle(fontWeight: FontWeight.w900)),

                        ),                        Row(children: [
                          Icon(Icons.water_drop_outlined,size: 13,color: Colors.lightBlueAccent.shade700,),
                          Text('1%',style: TextStyle(color: Colors.grey))
                        ],),
                        Row(
                          children: [
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                          ],
                        ),

                        Text("36/22",style: TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(context)*0.21,
                          child: Text("Sunday",style: TextStyle(fontWeight: FontWeight.w900)),

                        ),                        Row(children: [
                          Icon(Icons.water_drop_outlined,size: 13,color: Colors.lightBlueAccent.shade700,),
                          Text('1%',style: TextStyle(color: Colors.grey))
                        ],),
                        Row(
                          children: [
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                          ],
                        ),

                        Text("36/22",style: TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(context)*0.21,
                          child: Text("Monday",style: TextStyle(fontWeight: FontWeight.w900)),

                        ),                        Row(children: [
                          Icon(Icons.water_drop_outlined,size: 13,color: Colors.lightBlueAccent.shade700,),
                          Text('1%',style: TextStyle(color: Colors.grey))
                        ],),
                        Row(
                          children: [
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                          ],
                        ),

                        Text("36/22",style: TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(context)*0.21,
                          child: Text("Tuesday",style: TextStyle(fontWeight: FontWeight.w900)),

                        ),                        Row(children: [
                          Icon(Icons.water_drop_outlined,size: 13,color: Colors.lightBlueAccent.shade700,),
                          Text('1%',style: TextStyle(color: Colors.grey))
                        ],),
                        Row(
                          children: [
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                          ],
                        ),

                        Text("36/22",style: TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(context)*0.21,
                            child: Text("Wednesday",style: TextStyle(fontWeight: FontWeight.w900)),

                        ),
                        Row(children: [
                          Icon(Icons.water_drop_outlined,size: 13,color: Colors.lightBlueAccent.shade700,),
                          Text('1%',style: TextStyle(color: Colors.grey))
                        ],),
                        Row(
                          children: [
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                          ],
                        ),

                        Text("36/22",style: TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ],
                ),
              ),
          ),
          Card(
            elevation: 1,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                        height: height(context) * 0.06,
                      ),
                      Text('UV Index'),
                      Expanded(child: Text('')),
                      Text('Moderate',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: width(context)*0.2,),
                      Divider(color: Colors.black,height: 2,),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                        height: height(context) * 0.06,
                      ),
                      Text('Sunrise'),
                      Expanded(child: Text('')),
                      Text('6.24 am',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                    ],
                  ),

                  Row(
                    children: [
                      SizedBox(width: width(context)*0.2,),
                      Divider(color: Colors.black,height: 2,),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                        height: height(context) * 0.06,
                      ),
                      Text('Sunset'),
                      Expanded(child: Text('')),
                      Text('6.49 pm',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: width(context)*0.2,),
                      Divider(color: Colors.black,height: 2,thickness: 2,),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                        height: height(context) * 0.06,
                      ),
                      Text('Wind'),
                      Expanded(child: Text('')),
                      Text('3 km/hr',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                        height: height(context) * 0.06,
                      ),
                      Text('AQI'),
                      Expanded(child: Text('')),
                      Text('Moderate(5)',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                        height: height(context) * 0.06,
                      ),
                      Text('Humidity'),
                      Expanded(child: Text('')),
                      Text('42%',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 1,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                        height: height(context) * 0.06,
                      ),
                      Text('Driving Dificulty'),
                      Expanded(child: Text('')),
                      Text('None',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: width(context)*0.2,),
                      Divider(color: Colors.black,height: 2,),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                        height: height(context) * 0.06,
                      ),
                      Text('Pollen'),
                      Expanded(child: Text('')),
                      Text('Low',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                    ],
                  ),

                  Row(
                    children: [
                      SizedBox(width: width(context)*0.2,),
                      Divider(color: Colors.black,height: 2,),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                        height: height(context) * 0.06,
                      ),
                      Text('Running'),
                      Expanded(child: Text('')),
                      Text('Fair',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
    //   ListView(
    //   shrinkWrap: true,
    //   children: <Widget>[
    //     Column(
    //       children: [
    //         Container(
    //             height: height(context)*0.80,
    //             decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.only(
    //                   topLeft: Radius.circular(30),
    //                   topRight: Radius.circular(30),
    //                   // bottomLeft: Radius.circular(30),
    //                   // bottomRight: Radius.circular(30),
    //                 )),
    //             width: double.infinity,
    //             child: TabBarView(
    //                 controller: _tabController,
    //                 children: [
    //                   ListView(
    //                     scrollDirection: Axis.vertical,
    //                     shrinkWrap: true,
    //                     physics: ScrollPhysics(),
    //                     children: <Widget>[
    //                       //SizedBox(height: height(context)*0.01),
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                         children: [
    //                           Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Text(
    //                                 Address,style: TextStyle(fontFamily: 'Quicksand',fontSize: 17.0)
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             width: 10,
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Text(
    //                                 _data[0].date.toString().substring(0,10),style: TextStyle(fontFamily: 'Quicksand',fontSize: 15.0)
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       Padding(
    //                         padding: const EdgeInsets.all(8.0),
    //                         child: Icon(FontAwesomeIcons.cloudSun,color: Colors.orange,size: 40.0,),
    //                       ),
    //                       Center(
    //                         child: Padding(
    //                           padding: const EdgeInsets.all(12.0),
    //                           child: Text(_data[0].weatherDescription.toString(),style: TextStyle(fontFamily: 'Quicksand',letterSpacing: 0.5)),
    //                         ),
    //                       ),
    //                       SizedBox(height: height(context)*0.02),
    //                       Container(
    //                           padding: EdgeInsets.only(right: 15.0,left: 15.0),
    //                           width: width(context) - 25.0,
    //                           height: height(context)*0.30,//height(context) - 50.0
    //                           child: GridView.count(
    //                             crossAxisCount: 2,
    //                             primary: false,
    //                             crossAxisSpacing: 0.0,
    //                             mainAxisSpacing: 1.0,
    //                             childAspectRatio: 2.0,
    //                             children: <Widget>[
    //                               Card(
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(15.0),
    //                                 ),
    //                                 shadowColor:Colors.grey,
    //                                 elevation: 3.0,
    //                                 child: ListTile(
    //                                   leading: CircleAvatar(
    //                                     radius:25.0,
    //                                     child: Icon(FontAwesomeIcons.thermometerEmpty,size: 30.0,),
    //                                     backgroundColor:Colors.orange,
    //                                   ),
    //                                   title: Padding(
    //                                     padding: const EdgeInsets.all(8.0),
    //                                     child: Row(children:[
    //                                       Flexible( flex: 1,child: Text(_data[0].temperature.toString().substring(0,4)+'\u2103',style: TextStyle(fontSize: 15.0),))
    //                                     ]),
    //                                   ),
    //                                   subtitle: Row(children:[ Flexible(flex: 1,child: Text('Temperature',maxLines: 1,))]) ,//style: TextStyle(fontSize: 13.0),
    //                                   onTap:(){
    //                                   },
    //                                 ),
    //                               ),
    //                               Card(
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(15.0),
    //                                 ),
    //                                 shadowColor:Colors.grey,
    //                                 elevation: 3.0,
    //                                 child: ListTile(
    //                                   leading: CircleAvatar(
    //                                     radius:25.0,
    //                                     child: Icon(FontAwesomeIcons.thermometerEmpty,size: 30.0,),
    //                                     backgroundColor:Colors.orange,
    //                                   ),
    //                                   title: Padding(
    //                                     padding: const EdgeInsets.all(8.0),
    //                                     child: Text(_data[0].humidity !=null ? _data[0].humidity.toString()+' %':'0 %',style: TextStyle(fontSize: 15.0),),
    //                                   ),
    //                                   subtitle:Text('Humidity',style: TextStyle(fontSize: 13.0),),
    //                                   onTap:(){
    //                                   },
    //                                 ), 
    //                               ),
    //                               Card(
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(15.0),
    //                                 ),
    //                                 shadowColor:Colors.grey,
    //                                 elevation: 3.0,
    //                                 child: ListTile(
    //                                   leading:CircleAvatar(
    //                                     radius:25.0,
    //                                     child: Icon(FontAwesomeIcons.wind,size: 30.0,),
    //                                     backgroundColor:Colors.orange,
    //                                   ),
    //                                   title: Row(children: [
    //                                     Flexible( flex: 1,child: Text(_data[0].windSpeed.toString()+' km/h',style: TextStyle(fontSize: 15.0),))
    //                                   ]),
    //                                   subtitle:Text('Wind',style: TextStyle(fontSize: 13.0),),
    //                                   onTap:(){
    //                                   },
    //                                 ),
    //                               ),
    //                               Card(
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(15.0),
    //                                 ),
    //                                 shadowColor:Colors.grey,
    //                                 elevation: 3.0,
    //                                 child: ListTile(
    //                                   leading: CircleAvatar(
    //                                     radius:25.0,
    //                                     child: Icon(FontAwesomeIcons.cloud,size: 30.0,),
    //                                     backgroundColor:Colors.orange,
    //                                   ),
    //                                   title: Padding(
    //                                     padding: const EdgeInsets.all(8.0),
    //                                     child: Text( _data[0].cloudiness != null ? _data[0].cloudiness.toString()+' %':'0 %',style: TextStyle(fontSize: 15.0),),
    //                                   ),
    //                                   subtitle:Text('Cloudy',style: TextStyle(fontSize: 13.0),),
    //                                   onTap:(){
    //                                   },
    //                                 ),
    //                               ),
    //                             ],
    //                           )),
    //                       //SizedBox(height: height(context)*0.02),
    //                       Padding(
    //                         padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 5.0,bottom: 2.0),
    //                         child: Row(
    //                           children: [
    //                             Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.green,),
    //                             SizedBox(width: 10,),
    //                             Container(width: 2,height: 20,color: Colors.green,),
    //                             SizedBox(width: 10,),
    //                             Flexible(
    //                               flex:1,
    //                               child: Column(
    //                                   mainAxisAlignment: MainAxisAlignment.start,
    //                                   crossAxisAlignment: CrossAxisAlignment.start,
    //                                   children:[
    //                                     Text('Good Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
    //                                     Text('Potatos, Tomatos, Beans, Cauliflower, Cabbage, Pumpkin, Lettuce'),
    //                                   ]
    //                               ),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                       Padding(
    //                         padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 10.0,bottom: 2.0),
    //                         child: Row(
    //                           children: [
    //                             Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.yellow,),
    //                             SizedBox(width: 10,),
    //                             Container(width: 2,height: 20,color: Colors.green,),
    //                             SizedBox(width: 10,),
    //                             Flexible(
    //                               flex:1,
    //                               child: Column(
    //                                   mainAxisAlignment: MainAxisAlignment.start,
    //                                   crossAxisAlignment: CrossAxisAlignment.start,
    //                                   children:[
    //                                     Text('Normal Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
    //                                     Text('Rice. Wheat, Miller, Dats, Corn, Soy Bean, Mushrooms, Kale'),
    //                                   ]
    //                               ),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                       Padding(
    //                         padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 10.0,bottom: 2.0),
    //                         child: Row(
    //                           children: [
    //                             Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.red,),
    //                             SizedBox(width: 10,),
    //                             Container(width: 2,height: 20,color: Colors.green,),
    //                             SizedBox(width: 10,),
    //                             Flexible(
    //                               flex:1,
    //                               child: Column(
    //                                   mainAxisAlignment: MainAxisAlignment.start,
    //                                   crossAxisAlignment: CrossAxisAlignment.start,
    //                                   children:[
    //                                     Text('Bad Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
    //                                     Text('Tea, Coffee Cilantro'),
    //                                   ]
    //                               ),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   ListView(
    //                     scrollDirection: Axis.vertical,
    //                     shrinkWrap: true,
    //                     physics: ScrollPhysics(),
    //                     children: <Widget>[
    //                       //SizedBox(height: height(context)*0.01),
    //                       // Padding(
    //                       //   padding: const EdgeInsets.only(left: 30.0),
    //                       //   child: Text(
    //                       //       Address,style: TextStyle(fontFamily: 'Quicksand',fontSize: 17.0)
    //                       //   ),
    //                       // ),
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                         children: [
    //                           Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Text(
    //                                 Address,style: TextStyle(fontFamily: 'Quicksand',fontSize: 17.0)
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             width: 10,
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Text(
    //                                 _data[5].date.toString().substring(0,10),style: TextStyle(fontFamily: 'Quicksand',fontSize: 15.0)
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       Padding(
    //                         padding: const EdgeInsets.all(8.0),
    //                         child: Icon(FontAwesomeIcons.cloudSun,color: Colors.orange,size: 40.0,),
    //                       ),
    //                       Center(
    //                         child: Padding(
    //                           padding: const EdgeInsets.all(12.0),
    //                           child: Text(_data[5].weatherDescription.toString(),style: TextStyle(fontFamily: 'Quicksand',letterSpacing: 0.5)),
    //                         ),
    //                       ),
    //                       SizedBox(height: height(context)*0.02),
    //                       Container(
    //                           padding: EdgeInsets.only(right: 15.0,left: 15.0),
    //                           width: width(context) - 30.0,
    //                           height: height(context)*0.30,//height(context) - 50.0
    //                           child: GridView.count(
    //                             crossAxisCount: 2,
    //                             primary: false,
    //                             crossAxisSpacing: 0.0,
    //                             mainAxisSpacing: 1.0,
    //                             childAspectRatio: 2.0,
    //                             children: <Widget>[
    //                               Card(
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(15.0),
    //                                 ),
    //                                 shadowColor:Colors.grey,
    //                                 elevation: 3.0,
    //                                 child: ListTile(
    //                                   leading: CircleAvatar(
    //                                     radius:25.0,
    //                                     child: Icon(FontAwesomeIcons.thermometerEmpty,size: 30.0,),
    //                                     backgroundColor:Colors.orange,
    //                                   ),
    //                                   // CircleAvatar(
    //                                   //   backgroundColor: Colors.orange,
    //                                   //   child:Icon(FontAwesomeIcons.thermometerEmpty,size: 40.0,),
    //                                   // ),
    //                                   title: Padding(
    //                                     padding: const EdgeInsets.all(8.0),
    //                                     child: Text(_data[5].temperature.toString().substring(0,4)+'\u2103',style: TextStyle(fontSize: 14.0),),
    //                                   ),
    //                                   subtitle:Row(children:[ Flexible(flex: 1,child: Text('Temperature',))]),
    //                                   onTap:(){
    //                                   },
    //                                 ),
    //                               ),
    //                               Card(
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(15.0),
    //                                 ),
    //                                 shadowColor:Colors.grey,
    //                                 elevation: 3.0,
    //                                 child: ListTile(
    //                                   leading: CircleAvatar(
    //                                     radius:25.0,
    //                                     child: Icon(FontAwesomeIcons.thermometerEmpty,size: 30.0,),
    //                                     backgroundColor:Colors.orange,
    //                                   ),
    //                                   title: Padding(
    //                                     padding: const EdgeInsets.all(8.0),
    //                                     child: Text(_data[5].humidity != null ? _data[5].humidity.toString()+' %':'0 %',style: TextStyle(fontSize: 14.0),),
    //                                   ),
    //                                   subtitle:Text('Humidity',style: TextStyle(fontSize: 13.0),),
    //                                   onTap:(){
    //                                   },
    //                                 ),
    //                               ),
    //                               Card(
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(15.0),
    //                                 ),
    //                                 shadowColor:Colors.grey,
    //                                 elevation: 3.0,
    //                                 child: ListTile(
    //                                   leading:CircleAvatar(
    //                                     radius:25.0,
    //                                     child: Icon(FontAwesomeIcons.wind,size: 30.0,),
    //                                     backgroundColor:Colors.orange,
    //                                   ),
    //                                   title: Text(_data[5].windSpeed.toString()+' km/h',style: TextStyle(fontSize: 14.0),),
    //                                   subtitle:Text('Wind',style: TextStyle(fontSize: 13.0),),
    //                                   onTap:(){
    //                                   },
    //                                 ),
    //                               ),
    //                               Card(
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(15.0),
    //                                 ),
    //                                 shadowColor:Colors.grey,
    //                                 elevation: 3.0,
    //                                 child: ListTile(
    //                                   leading: CircleAvatar(
    //                                     radius:25.0,
    //                                     child: Icon(FontAwesomeIcons.cloud,size: 30.0,),
    //                                     backgroundColor:Colors.orange,
    //                                   ),
    //                                   title: Padding(
    //                                     padding: const EdgeInsets.all(8.0),
    //                                     child: Text( _data[0].cloudiness != null ? _data[0].cloudiness.toString()+' %':'0 %',style: TextStyle(fontSize: 14.0),),
    //                                   ),
    //                                   subtitle:Text('Cloudy',style: TextStyle(fontSize: 13.0),),
    //                                   onTap:(){
    //                                   },
    //                                 ),
    //                               ),
    //                             ],
    //                           )),
    //                       Padding(
    //                         padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 5.0,bottom: 2.0),
    //                         child: Row(
    //                           children: [
    //                             Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.green,),
    //                             SizedBox(width: 10,),
    //                             Container(width: 2,height: 20,color: Colors.green,),
    //                             SizedBox(width: 10,),
    //                             Flexible(
    //                               flex:1,
    //                               child: Column(
    //                                   mainAxisAlignment: MainAxisAlignment.start,
    //                                   crossAxisAlignment: CrossAxisAlignment.start,
    //                                   children:[
    //                                     Text('Good Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
    //                                     Text('Potatos, Tomatos, Beans, Cauliflower, Cabbage, Pumpkin, Lettuce'),
    //                                   ]
    //                               ),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                       Padding(
    //                         padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 10.0,bottom: 2.0),
    //                         child: Row(
    //                           children: [
    //                             Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.yellow,),
    //                             SizedBox(width: 10,),
    //                             Container(width: 2,height: 20,color: Colors.green,),
    //                             SizedBox(width: 10,),
    //                             Flexible(
    //                               flex:1,
    //                               child: Column(
    //                                   mainAxisAlignment: MainAxisAlignment.start,
    //                                   crossAxisAlignment: CrossAxisAlignment.start,
    //                                   children:[
    //                                     Text('Normal Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
    //                                     Text('Rice. Wheat, Miller, Dats, Corn, Soy Bean,\n Mushrooms, Kale'),
    //                                   ]
    //                               ),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                       Padding(
    //                         padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 10.0,bottom: 2.0),
    //                         child: Row(
    //                           children: [
    //                             Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.red,),
    //                             SizedBox(width: 10,),
    //                             Container(width: 2,height: 20,color: Colors.green,),
    //                             SizedBox(width: 10,),
    //                             Flexible(
    //                               flex:1,
    //                               child: Column(
    //                                   mainAxisAlignment: MainAxisAlignment.start,
    //                                   crossAxisAlignment: CrossAxisAlignment.start,
    //                                   children:[
    //                                     Text('Bad Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
    //                                     Text('Tea, Coffee Cilantro'),
    //                                   ]
    //                               ),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   ListView(
    //                     scrollDirection: Axis.vertical,
    //                     shrinkWrap: true,
    //                     physics: ScrollPhysics(),
    //                     children: <Widget>[
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                         children: [
    //                           Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Text(
    //                                 Address,style: TextStyle(fontFamily: 'Quicksand',fontSize: 17.0)
    //                             ),
    //                           ),
    //                           // SizedBox(
    //                           //   width: 10,
    //                           // ),
    //                           // Padding(
    //                           //   padding: const EdgeInsets.all(8.0),
    //                           //   child: Text(
    //                           //       _data[12].date.toString().substring(0,10),style: TextStyle(fontFamily: 'Quicksand',fontSize: 15.0)
    //                           //   ),
    //                           // ),
    //                         ],
    //                       ),
    //                       Padding(
    //                         padding: const EdgeInsets.all(8.0),
    //                         child: Icon(FontAwesomeIcons.cloudSun,color: Colors.orange,size: 40.0,),
    //                       ),
    //                       Center(
    //                         child: Padding(
    //                           padding: const EdgeInsets.all(12.0),
    //                           child: Text(_data[12].weatherDescription.toString(),style: TextStyle(fontFamily: 'Quicksand',letterSpacing: 0.5)),
    //                         ),
    //                       ),
    //                       SizedBox(height: height(context)*0.02),
    //                       Container(
    //                           padding: EdgeInsets.only(right: 15.0,left: 15.0),
    //                           width: width(context) - 30.0,
    //                           height: height(context)*0.30,//height(context) - 50.0
    //                           child: GridView.count(
    //                             crossAxisCount: 2,
    //                             primary: false,
    //                             crossAxisSpacing: 0.0,
    //                             mainAxisSpacing: 1.0,
    //                             childAspectRatio: 2.0,
    //                             children: <Widget>[
    //                               Card(
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(15.0),
    //                                 ),
    //                                 shadowColor:Colors.grey,
    //                                 elevation: 3.0,
    //                                 child: ListTile(
    //                                   leading: CircleAvatar(
    //                                     radius:25.0,
    //                                     child: Icon(FontAwesomeIcons.thermometerEmpty,size: 30.0,),
    //                                     backgroundColor:Colors.orange,
    //                                   ),
    //                                   // CircleAvatar(
    //                                   //   backgroundColor: Colors.orange,
    //                                   //   child:Icon(FontAwesomeIcons.thermometerEmpty,size: 40.0,),
    //                                   // ),
    //                                   title: Padding(
    //                                     padding: const EdgeInsets.all(8.0),
    //                                     child: Text(_data[12].temperature.toString().substring(0,4)+'\u2103',style: TextStyle(fontSize: 14.0),),
    //                                   ),
    //                                   subtitle:Row(children:[ Flexible(flex: 1,child: Text('Temperature',))]),
    //                                   onTap:(){
    //                                   },
    //                                 ),
    //                               ),
    //                               Card(
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(15.0),
    //                                 ),
    //                                 shadowColor:Colors.grey,
    //                                 elevation: 3.0,
    //                                 child: ListTile(
    //                                   leading: CircleAvatar(
    //                                     radius:25.0,
    //                                     child: Icon(FontAwesomeIcons.thermometerEmpty,size: 30.0,),
    //                                     backgroundColor:Colors.orange,
    //                                   ),
    //                                   title: Padding(
    //                                     padding: const EdgeInsets.all(8.0),
    //                                     child: Text(_data[12].humidity != null ?_data[12].humidity.toString()+' %':'0 %',style: TextStyle(fontSize: 14.0),),
    //                                   ),
    //                                   subtitle:Text('Humidity',style: TextStyle(fontSize: 13.0)),
    //                                   onTap:(){
    //                                   },
    //                                 ),
    //                               ),
    //                               Card(
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(15.0),
    //                                 ),
    //                                 shadowColor:Colors.grey,
    //                                 elevation: 3.0,
    //                                 child: ListTile(
    //                                   leading:CircleAvatar(
    //                                     radius:25.0,
    //                                     child: Icon(FontAwesomeIcons.wind,size: 30.0,),
    //                                     backgroundColor:Colors.orange,
    //                                   ),
    //                                   title: Text(_data[12].windSpeed.toString()+' km/h',style: TextStyle(fontSize: 14.0)),
    //                                   subtitle:Text('Wind',style: TextStyle(fontSize: 13.0)),
    //                                   onTap:(){
    //                                   },
    //                                 ),
    //                               ),
    //                               Card(
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(15.0),
    //                                 ),
    //                                 shadowColor:Colors.grey,
    //                                 elevation: 3.0,
    //                                 child: ListTile(
    //                                   leading: CircleAvatar(
    //                                     radius:25.0,
    //                                     child: Icon(FontAwesomeIcons.cloud,size: 30.0,),
    //                                     backgroundColor:Colors.orange,
    //                                   ),
    //                                   title: Padding(
    //                                     padding: const EdgeInsets.all(8.0),
    //                                     child: Text(_data[12].cloudiness != null ? _data[12].cloudiness.toString()+' %':'0 %',style: TextStyle(fontSize: 14.0)),
    //                                   ),
    //                                   subtitle:Text('Cloudy',style: TextStyle(fontSize: 13.0)),
    //                                   onTap:(){
    //                                   },
    //                                 ),
    //                               ),
    //                             ],
    //                           )),
    //                       Padding(
    //                         padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 5.0,bottom: 2.0),
    //                         child: Row(
    //                           children: [
    //                             Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.green,),
    //                             SizedBox(width: 10,),
    //                             Container(width: 2,height: 20,color: Colors.green,),
    //                             SizedBox(width: 10,),
    //                             Flexible(
    //                               flex:1,
    //                               child: Column(
    //                                   mainAxisAlignment: MainAxisAlignment.start,
    //                                   crossAxisAlignment: CrossAxisAlignment.start,
    //                                   children:[
    //                                     Text('Good Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
    //                                     Text('Potatos, Tomatos, Beans, Cauliflower, Cabbage, Pumpkin, Lettuce'),
    //                                   ]
    //                               ),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                       Padding(
    //                         padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 10.0,bottom: 2.0),
    //                         child: Row(
    //                           children: [
    //                             Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.yellow,),
    //                             SizedBox(width: 10,),
    //                             Container(width: 2,height: 20,color: Colors.green,),
    //                             SizedBox(width: 10,),
    //                             Flexible(
    //                               flex:1,
    //                               child: Column(
    //                                   mainAxisAlignment: MainAxisAlignment.start,
    //                                   crossAxisAlignment: CrossAxisAlignment.start,
    //                                   children:[
    //                                     Text('Normal Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
    //                                     Text('Rice. Wheat, Miller, Dats, Corn, Soy Bean, Mushrooms, Kale'),
    //                                   ]
    //                               ),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                       Padding(
    //                         padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 10.0,bottom: 2.0),
    //                         child: Row(
    //                           children: [
    //                             Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.red,),
    //                             SizedBox(width: 10,),
    //                             Container(width: 2,height: 20,color: Colors.green,),
    //                             SizedBox(width: 10,),
    //                             Flexible(
    //                               flex:1,
    //                               child: Column(
    //                                   mainAxisAlignment: MainAxisAlignment.start,
    //                                   crossAxisAlignment: CrossAxisAlignment.start,
    //                                   children:[
    //                                     Text('Bad Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
    //                                     Text('Tea, Coffee Cilantro'),
    //                                   ]
    //                               ),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   // CookiePage(
    //                   //     Temp:_data[index].temperature.toString().substring(0,4),
    //                   //     Humidity:_data[index].humidity.toString(),
    //                   //     wind:_data[index].windSpeed.toString(),
    //                   //     Description: _data[index].weatherDescription.toString(),
    //                   //   date:_data[index].date.toString().substring(0,16),
    //                   // ),
    //                   //
    //                   // CookiePage(Temp:_data[index].temperature.toString().substring(0,4),
    //                   //     Humidity:_data[index].humidity.toString(),
    //                   //     wind:_data[index].windSpeed.toString(),
    //                   //     Description: _data[index].weatherDescription.toString(),
    //                   //   date:_data[index].date.toString().substring(0,16),
    //                   // ),
    //                   // //
    //                   // CookiePage(Temp:_data[index].temperature.toString().substring(0,4),
    //                   //     Humidity:_data[index].humidity.toString()
    //                   //     ,wind:_data[index].windSpeed.toString(),
    //                   //     Description: _data[index].weatherDescription.toString(),
    //                   //     date:_data[index].date.toString().substring(0,16),
    //                   // ),
    //                 ]
    //             )
    //         )
    //       ],
    //     ),
    //     // Padding(
    //     //   padding: const EdgeInsets.all(8.0),
    //     //   child: Icon(FontAwesomeIcons.cloudSun,color: Colors.orange,size: 40.0,),
    //     // ),
    //     // Padding(
    //     //   padding: const EdgeInsets.all(8.0),
    //     //   child: Text( _data[index].weatherDescription.toString(),),
    //     // ),
    //     //       SizedBox(height: 20.0),
    //     //       GridView.count(
    //     //   crossAxisCount: 2,
    //     //   shrinkWrap: true,
    //     //   children: <Widget>[
    //     //     Padding(
    //     //       padding: const EdgeInsets.all(12.0),
    //     //       child: Card(
    //     //         shape: RoundedRectangleBorder(
    //     //           borderRadius: BorderRadius.circular(15.0),
    //     //         ),
    //     //         shadowColor:Colors.grey,
    //     //         elevation: 10.0,
    //     //         child: ListTile(
    //     //           leading: CircleAvatar(
    //     //             backgroundColor: Colors.orange,
    //     //             child: Text('T'),
    //     //           ),
    //     //           title: Text(_data[index].temperature.toString().substring(0,4)+'\u2103',),
    //     //           subtitle:Text('Temperature'),
    //     //           onTap:(){
    //     //           },
    //     //         ),
    //     //       ),
    //     //     ),
    //     //     Padding(
    //     //       padding: const EdgeInsets.all(12.0),
    //     //       child: Card(
    //     //         shape: RoundedRectangleBorder(
    //     //           borderRadius: BorderRadius.circular(15.0),
    //     //         ),
    //     //         shadowColor:Colors.grey,
    //     //         elevation: 10.0,
    //     //         child: ListTile(
    //     //           leading: CircleAvatar(
    //     //             backgroundColor: Colors.orange,
    //     //             child: Text('H'),
    //     //           ),
    //     //           title: Text( _data[index].humidity.toString()+' %',),
    //     //           subtitle:Text('Humidity'),
    //     //           onTap:(){
    //     //           },
    //     //         ),
    //     //       ),
    //     //     ),
    //     //     Padding(
    //     //       padding: const EdgeInsets.all(12.0),
    //     //       child: Card(
    //     //         shape: RoundedRectangleBorder(
    //     //           borderRadius: BorderRadius.circular(15.0),
    //     //         ),
    //     //         shadowColor:Colors.grey,
    //     //         elevation: 10.0,
    //     //         child: ListTile(
    //     //           leading: CircleAvatar(
    //     //             backgroundColor: Colors.orange,
    //     //             child: Text('A'),
    //     //           ),
    //     //           title: Text(_data[index].windSpeed.toString()+' km/h',),
    //     //           subtitle:Text('Wind'),
    //     //           onTap:(){
    //     //           },
    //     //         ),
    //     //       ),
    //     //     ),
    //     //     Padding(
    //     //       padding: const EdgeInsets.all(12.0),
    //     //       child: Card(
    //     //         shape: RoundedRectangleBorder(
    //     //           borderRadius: BorderRadius.circular(15.0),
    //     //         ),
    //     //         shadowColor:Colors.grey,
    //     //         elevation: 10.0,
    //     //         child: ListTile(
    //     //           leading: CircleAvatar(
    //     //             backgroundColor: Colors.orange,
    //     //             child: Text('A'),
    //     //           ),
    //     //           title: Text(_data[index].temperature.toString().substring(0,4)+'\u2103',),
    //     //           subtitle:Text('Temperature'),
    //     //           onTap:(){
    //     //           },
    //     //         ),
    //     //       ),
    //     //     ),
    //     //   ],
    //     // )
    //   ],
    // );
  }

  Widget contentDownloading() {
    return Container(
      margin: EdgeInsets.all(25),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Fetching Weather...',
              style: TextStyle(fontSize: 20),
            ),
            Container(
                margin: EdgeInsets.only(top: 50),
                child: Center(
                    child:
                        Loading())) //CircularProgressIndicator(strokeWidth: 10)
          ]),
    );
  }

  Widget contentNotDownloaded() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Press the button to download the Weather forecast',
          ),
        ],
      ),
    );
  }

  Widget _resultView() => _state == AppState.FINISHED_DOWNLOADING
      ? contentFinishedDownload()
      : _state == AppState.DOWNLOADING
          ? contentDownloading()
          : contentNotDownloaded();

  void _saveLat(String input) {
    lat = double.tryParse(input);
    print(lat);
  }

  void _saveLon(String input) {
    lon = double.tryParse(input);
    print(lon);
  }

  Widget _coordinateInputs() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              margin: EdgeInsets.all(5),
              child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter latitude'),
                  keyboardType: TextInputType.number,
                  onChanged: _saveLat,
                  onSubmitted: _saveLat)),
        ),
        Expanded(
            child: Container(
                margin: EdgeInsets.all(5),
                child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter longitude'),
                    keyboardType: TextInputType.number,
                    onChanged: _saveLon,
                    onSubmitted: _saveLon)))
      ],
    );
  }

  Widget _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        // Container(
        //   margin: EdgeInsets.all(5),
        //   child: TextButton(
        //     child: Text(
        //       'Fetch weather',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //     onPressed: (){},//queryWeather,
        //     style: ButtonStyle(
        //         backgroundColor: MaterialStateProperty.all(Colors.blue)),
        //   ),
        // ),
        // Container(
        //   margin: EdgeInsets.all(5),
        //   child: TextButton(
        //     child: Text(
        //       'Fetch forecast',
        //       style: TextStyle(color: Colors.black),
        //     ),
        //     onPressed:() async {
        //        Position position = await _getGeoLocationPosition();
        //           queryForecast(position);
        //        GetAddressFromLatLong(position);
        //           },
        //     style: ButtonStyle(
        //         backgroundColor: MaterialStateProperty.all(Colors.transparent)),
        //   ),
        // ),
        // Container(
        //   margin: EdgeInsets.all(5),
        //   child: TextButton(
        //     child: Text(
        //       'Fetch Weather',
        //       style: TextStyle(color: Colors.black),
        //     ),
        //     onPressed:() async {
        //       Position position = await _getGeoLocationPosition();
        //       queryWeather(position);
        //       GetAddressFromLatLong(position);
        //     },
        //     style: ButtonStyle(
        //         backgroundColor: MaterialStateProperty.all(Colors.blue)),
        //   ),
        // )
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              child: OutlinedButton(
                child: Text('Tomorrow'),
                onPressed: () async {
                  Position position = await _getGeoLocationPosition();
                  queryForecast(position);
                  GetAddressFromLatLong(position);
                },
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              child: OutlinedButton(
                child: Text('Today'),
                onPressed: () async {
                  Position position = await _getGeoLocationPosition();
                  queryWeather(position);
                  GetAddressFromLatLong(position);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //extendBodyBehindAppBar:true,
        //backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: false,
          //backgroundColor: Colors.transparent,
          backgroundColor: Color(0xffECB34F),
          title: const Text(
            "User Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              /*fontFamily: "Inter"*/
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset('assets/new_images/back.png')),
        ),
        body: _resultView()
        //bottomNavigationBar: _buttons(),
        );
  }
}
*/
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Widgets/Loading.dart';
import '../constant/Constant.dart';
import 'DashboardActivity.dart';
/*

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green, Colors.blue],
          ),
        ),
        child: Center(
          child: SpinKitRipple(
            color: Colors.white,
            size: 150.0,
            duration: Duration(milliseconds: 200),
          ),
        ),
      ),
    );
  }
}
*/

class WeatherApp extends StatefulWidget {
  //WeatherApp({@required this.weatherData});
  // final WeatherData weatherData;
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  int temperature;
  Icon weatherDisplayIcon;
  String locationName;
  AssetImage backgroundImage;
  var locdata;
  var humidity;
  int date;
  var dt;
  String wind;
  String bgImg;
  int city;
  WeatherData weatherData;

  void updateDisplayInfo(WeatherData weatherData) {
//    print(weatherData.currentTemperature);
    setState(() {
      temperature = weatherData.currentTemperature.round();
      WeatherDisplayData weatherDisplayData = weatherData.getWeatherDisplayData();
      backgroundImage = weatherDisplayData.weatherImage;
      weatherDisplayIcon = weatherDisplayData.weatherIcon;
      locationName=weatherData.currentLocation;
      locdata=weatherData.currentDescription;
      humidity=weatherData.currentHumidity;
      date=weatherData.currentDate;
      city=weatherData.weatherCity;
      dt = DateTime.fromMillisecondsSinceEpoch(date*1000);
      wind=weatherData.currentWind;

      if(weatherData.weatherType == 'Mist') {
        bgImg = 'assets/images/sunny.jpg';
      } else if(weatherData.weatherType == 'Night') {
        bgImg = 'assets/images/night.jpg';
      } else if(weatherData.weatherType == 'Rainy') {
        bgImg = 'assets/images/rainy.jpg';
      } else if(weatherData.weatherType == 'Clouds') {
        bgImg = 'assets/images/cloudy.jpeg';
      }
      else {
        bgImg = 'assets/images/sunny.jpg';
      }
    });
  }
  LocationHelper _locationHelper;

  Future<void> getLocationData() async {
    _locationHelper = LocationHelper();
    await _locationHelper.getCurrentLocation();
    if (_locationHelper.longitude == null || _locationHelper.latitude == null) {
      print("data not fetched!");
    } else {
      print(_locationHelper.latitude);
    }
  }

  void getWeatherData() async {
    // Fetch the location
    await getLocationData();
    // Fetch the current weather
     weatherData = WeatherData(locationData: _locationHelper);
    await weatherData.getCurrentTemperature();

    if (weatherData.currentTemperature == null ||
        weatherData.currentCondition == null) {
      // todo: Handle no weather
    }
    //Get.to(()=>MainScreen(weatherData: weatherData,));
    updateDisplayInfo(weatherData);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      extendBodyBehindAppBar: true,
      appBar:AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        //brightness: Brightness.light,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              //height: height(context)*0.30,

              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      //mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_off_rounded,size: height(context) * 0.018,),
                            Text(weatherData.currentLocation,
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: height(context) * 0.023))
                          ],
                        ),
                      ],
                    ),
                    Text(weatherData.currentDate.toString(),
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.grey,fontSize: height(context)*0.013)),
                    Row(
                      children: [
                        Image.network(
                          'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                          height: height(context) * 0.08,
                        ),
                        Text(
                          weatherData.currentTemperature.toString(),
                          style: TextStyle(fontSize: height(context) * 0.06),
                        ),
                        Expanded(child: Text('')),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              weatherData.weatherType,
                              textAlign: TextAlign.end,
                            ),
                            Text(
                              weatherData.getWeatherDisplayData().toString(),
                              textAlign: TextAlign.end,
                            ),
                            Text(
                              'Feels like 28',
                              textAlign: TextAlign.end,
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("9:30 am", style: TextStyle(color: Colors.grey)),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.035,
                            ),
                            Text("29",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            Row(
                              children: [
                                Icon(Icons.water_drop_outlined,
                                    size: 15, color: Colors.lightBlueAccent),
                                Text(
                                  "0%",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text("10:30 am",
                                style: TextStyle(color: Colors.grey)),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.035,
                            ),
                            Text("29",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            Row(
                              children: [
                                Icon(Icons.water_drop_outlined,
                                    size: 15, color: Colors.lightBlueAccent),
                                Text(
                                  "0%",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text("11:30 am",
                                style: TextStyle(color: Colors.grey)),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.035,
                            ),
                            Text("29",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            Row(
                              children: [
                                Icon(Icons.water_drop_outlined,
                                    size: 15, color: Colors.lightBlueAccent),
                                Text(
                                  "0%",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text("12:30 pm",
                                style: TextStyle(color: Colors.grey)),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.035,
                            ),
                            Text("29",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            Row(
                              children: [
                                Icon(Icons.water_drop_outlined,
                                    size: 15, color: Colors.lightBlueAccent),
                                Text(
                                  "0%",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Card(
              elevation: 1,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Yesterday",style: TextStyle(color: Colors.grey)),
                        Text("36/22",style: TextStyle(color: Colors.grey)),


                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(context)*0.21,
                          child: Text("Today",style: TextStyle(fontWeight: FontWeight.w900)),

                        ),                        Row(children: [
                          Icon(Icons.water_drop_outlined,size: 13,color: Colors.lightBlueAccent.shade700,),
                          Text('1%',style: TextStyle(color: Colors.grey))
                        ],),
                        Row(
                          children: [
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                          ],
                        ),

                        Text("36/22",style: TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(context)*0.21,
                          child: Text("Friday",style: TextStyle(fontWeight: FontWeight.w900)),

                        ),                        Row(children: [
                          Icon(Icons.water_drop_outlined,size: 13,color: Colors.lightBlueAccent.shade700,),
                          Text('1%',style: TextStyle(color: Colors.grey))
                        ],),
                        Row(
                          children: [
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                          ],
                        ),

                        Text("36/22",style: TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(context)*0.21,
                          child: Text("Saturday",style: TextStyle(fontWeight: FontWeight.w900)),

                        ),                        Row(children: [
                          Icon(Icons.water_drop_outlined,size: 13,color: Colors.lightBlueAccent.shade700,),
                          Text('1%',style: TextStyle(color: Colors.grey))
                        ],),
                        Row(
                          children: [
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                          ],
                        ),

                        Text("36/22",style: TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(context)*0.21,
                          child: Text("Sunday",style: TextStyle(fontWeight: FontWeight.w900)),

                        ),                        Row(children: [
                          Icon(Icons.water_drop_outlined,size: 13,color: Colors.lightBlueAccent.shade700,),
                          Text('1%',style: TextStyle(color: Colors.grey))
                        ],),
                        Row(
                          children: [
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                          ],
                        ),

                        Text("36/22",style: TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(context)*0.21,
                          child: Text("Monday",style: TextStyle(fontWeight: FontWeight.w900)),

                        ),                        Row(children: [
                          Icon(Icons.water_drop_outlined,size: 13,color: Colors.lightBlueAccent.shade700,),
                          Text('1%',style: TextStyle(color: Colors.grey))
                        ],),
                        Row(
                          children: [
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                          ],
                        ),

                        Text("36/22",style: TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(context)*0.21,
                          child: Text("Tuesday",style: TextStyle(fontWeight: FontWeight.w900)),

                        ),                        Row(children: [
                          Icon(Icons.water_drop_outlined,size: 13,color: Colors.lightBlueAccent.shade700,),
                          Text('1%',style: TextStyle(color: Colors.grey))
                        ],),
                        Row(
                          children: [
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                          ],
                        ),

                        Text("36/22",style: TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(context)*0.21,
                          child: Text("Wednesday",style: TextStyle(fontWeight: FontWeight.w900)),

                        ),
                        Row(children: [
                          Icon(Icons.water_drop_outlined,size: 13,color: Colors.lightBlueAccent.shade700,),
                          Text('1%',style: TextStyle(color: Colors.grey))
                        ],),
                        Row(
                          children: [
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                            Image.network(
                              'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                              height: height(context) * 0.045,
                            ),
                          ],
                        ),

                        Text("36/22",style: TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 1,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                          height: height(context) * 0.06,
                        ),
                        Text('UV Index'),
                        Expanded(child: Text('')),
                        Text('Moderate',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: width(context)*0.2,),
                        Divider(color: Colors.black,height: 2,),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                          height: height(context) * 0.06,
                        ),
                        Text('Sunrise'),
                        Expanded(child: Text('')),
                        Text('6.24 am',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                      ],
                    ),

                    Row(
                      children: [
                        SizedBox(width: width(context)*0.2,),
                        Divider(color: Colors.black,height: 2,),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                          height: height(context) * 0.06,
                        ),
                        Text('Sunset'),
                        Expanded(child: Text('')),
                        Text('6.49 pm',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: width(context)*0.2,),
                        Divider(color: Colors.black,height: 2,thickness: 2,),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                          height: height(context) * 0.06,
                        ),
                        Text('Wind'),
                        Expanded(child: Text('')),
                        Text('3 km/hr',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                          height: height(context) * 0.06,
                        ),
                        Text('AQI'),
                        Expanded(child: Text('')),
                        Text('Moderate(5)',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                          height: height(context) * 0.06,
                        ),
                        Text('Humidity'),
                        Expanded(child: Text('')),
                        Text('42%',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 1,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                          height: height(context) * 0.06,
                        ),
                        Text('Driving Dificulty'),
                        Expanded(child: Text('')),
                        Text('None',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: width(context)*0.2,),
                        Divider(color: Colors.black,height: 2,),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                          height: height(context) * 0.06,
                        ),
                        Text('Pollen'),
                        Expanded(child: Text('')),
                        Text('Low',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                      ],
                    ),

                    Row(
                      children: [
                        SizedBox(width: width(context)*0.2,),
                        Divider(color: Colors.black,height: 2,),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://www.pngall.com/wp-content/uploads/11/Weather-PNG-Photos.png',
                          height: height(context) * 0.06,
                        ),
                        Text('Running'),
                        Expanded(child: Text('')),
                        Text('Fair',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.end,),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

List<dynamic> farmlatlong = [];
const apiKey = 'da6224bdf8c5bb0b0ce5ea9838d86c54';

class WeatherData {
  WeatherData({@required this.locationData});

  LocationHelper locationData;
  double currentTemperature;
  int currentHumidity;
  int currentCondition;
  String currentLocation;
  String currentDescription;
  double currentLong;
  double currentLat;
  int currentDate;
  String currentWind;
  String currentIcon;
  String weatherType;
  int weatherCity;
  int currentPressure;

  Future<void> getCurrentTemperature() async {

    var latitude,longitude;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var api_key = prefs.getString('api_key');
    var response1 = await http.get(Uri.parse('https://api.mapmycrop.com/farm/?api_key=$api_key'));
    var data = jsonDecode(response1.body);
   // print(data);
    if(data.length>0){
    for (int i = 0; i < data.length; i++) {
      data[i]['id'];
      var singleFarmResponse = await http.get(Uri.parse('https://api.mapmycrop.com/farm/${data[i]['id']}?api_key=$api_key'));
      var singleFarmData = jsonDecode(singleFarmResponse.body);

      farmlatlong.add(singleFarmData['features'][0]['properties']['center']['coordinates']);


      //farmlatlong.add(data['features'][0]['geometry']['coordinates'][0][0][1]);
      //print(farmlatlong[i]);
    }
    print(farmlatlong);

    currentTemperatures.clear();
    currentHumiditys.clear();
    currentPressures.clear();
    currentConditions.clear();
    currentIcons.clear();
    currentDescriptions.clear();
    currentLocations.clear();
    //currentDates.clear();
    currentWinds.clear();
    currentLongs.clear();
    currentLats.clear();
    weatherTypes.clear();
    weatherCitys.clear();
    if(farmlatlong.isNotEmpty){
      for(int i = 0;i< farmlatlong.length;i++){
        longitude=farmlatlong[i][0];
        latitude=farmlatlong[i][1];
        //print('latitude = $latitude \n longitude = $longitude');
        final response = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=${apiKey}&units=metric'));
         // print(response.body);
        if (response.statusCode == 200) {
          String data = response.body;
          //print(data);
          var currentWeather = jsonDecode(data);
          /*print('''
            ${currentWeather['main']['temp']}
            ${currentWeather['main']['humidity']}
            ${currentWeather['main']['pressure']}
            ${currentWeather['weather'][0]['id']}
            ${currentWeather['weather'][0]['icon']}
            ${currentWeather['weather'][0]['description']}
            ${currentWeather['name']}
            ${currentWeather['dt']}
            ${currentWeather['wind']['speed'].toString()}
            ${currentWeather['coord']['lon']}
            ${currentWeather['coord']['lat']}
            ${currentWeather['weather'][0]['main']}
            ${currentWeather['sys']['id']}
        ''');*/
          try {
            //print(currentWeather['dt']);
            currentTemperatures.add(currentWeather['main']['temp']);
            currentHumiditys.add(currentWeather['main']['humidity']);
            currentPressures.add(currentWeather['main']['pressure']);
            currentConditions.add(currentWeather['weather'][0]['id']);
            currentIcons.add(currentWeather['weather'][0]['icon']);
            currentDescriptions.add(currentWeather['weather'][0]['description']);
            currentLocations.add(currentWeather['name']);
            //currentDates.add(currentWeather['dt']);
            currentWinds.add(currentWeather['wind']['speed'].toString());
            currentLongs.add(currentWeather['coord']['lon']);
            currentLats.add(currentWeather['coord']['lat']);
            weatherTypes.add(currentWeather['weather'][0]['main']);
            weatherCitys.add(currentWeather['sys']['id']);

          } catch (e) {
            print(e);
          }
        } else {
          // print('Could not fetch temperature!');
        }
      }
      print(currentIcons);
     }else{
      print('were in else now');
      LocationHelper locationHelper = LocationHelper();
     await locationHelper.getCurrentLocation();
      longitude= locationHelper.longitude;
      latitude= locationHelper.latitude;
      print('latitude = $latitude \n longitude = $longitude');
      final response = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=${apiKey}&units=metric'));
      // print(response.body);
      if (response.statusCode == 200) {
        String data = response.body;
        //print(data);
        var currentWeather = jsonDecode(data);
        /*print('''
            ${currentWeather['main']['temp']}
            ${currentWeather['main']['humidity']}
            ${currentWeather['main']['pressure']}
            ${currentWeather['weather'][0]['id']}
            ${currentWeather['weather'][0]['icon']}
            ${currentWeather['weather'][0]['description']}
            ${currentWeather['name']}
            ${currentWeather['dt']}
            ${currentWeather['wind']['speed'].toString()}
            ${currentWeather['coord']['lon']}
            ${currentWeather['coord']['lat']}
            ${currentWeather['weather'][0]['main']}
            ${currentWeather['sys']['id']}
        ''');*/
        try {
          //print(currentWeather['dt']);
          currentTemperature=currentWeather['main']['temp'];
          currentHumidity=currentWeather['main']['humidity'];
          currentPressures=currentWeather['main']['pressure'];
          currentCondition=currentWeather['weather'][0]['id'];
          currentIcon=currentWeather['weather'][0]['icon'];
          currentDescription=currentWeather['weather'][0]['description'];
          currentLocation=currentWeather['name'];
          //currentDates.add(currentWeather['dt'];
          currentWind=currentWeather['wind']['speed'].toString();
          currentLong=currentWeather['coord']['lon'];
          currentLat=currentWeather['coord']['lat'];
          weatherType=currentWeather['weather'][0]['main'];
          weatherCity=currentWeather['sys']['id'];

        } catch (e) {
          print(e);
        }
      } else {
        // print('Could not fetch temperature!');
      }
    }

    /*print("""
    $currentTemperatures\n
    $currentHumiditys\n
    $currentPressures\n
    $currentConditions\n
    $currentIcons\n
    $currentDescriptions\n
    $currentLocations\n

    $currentWinds\n
    $currentLongs\n
    $currentLats\n
    $weatherTypes\n
    $weatherCitys\n
    
    
    """);*/

    /*longitude=farmlatlong[0][0];
    latitude=farmlatlong[0][1];
    //print('latitude = $latitude \n longitude = $longitude');
      final response = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=${apiKey}&units=metric'));
      print(response.body);
      if (response.statusCode == 200) {
        String data = response.body;
        //print(data);
        var currentWeather = jsonDecode(data);
        // print('''
        //     ${currentWeather['main']['temp']}
        //     ${currentWeather['main']['humidity']}
        //     ${currentWeather['main']['pressure']}
        //     ${currentWeather['weather'][0]['id']}
        //     ${currentWeather['weather'][0]['icon']}
        //     ${currentWeather['weather'][0]['description']}
        //     ${currentWeather['name']}
        //     ${currentWeather['dt']}
        //     ${currentWeather['wind']['speed'].toString()}
        //     ${currentWeather['coord']['lon']}
        //     ${currentWeather['coord']['lat']}
        //     ${currentWeather['weather'][0]['main']}
        //     ${currentWeather['sys']['id']}
        // ''');
        try {
          currentTemperature =  currentWeather['main']['temp'];
          currentHumidity =     currentWeather['main']['humidity'];
          currentPressure =     currentWeather['main']['pressure'];
          currentCondition =    currentWeather['weather'][0]['id'];
          currentIcon =         currentWeather['weather'][0]['icon'];
          currentDescription =  currentWeather['weather'][0]['description'];
          currentLocation=      currentWeather['name'];
          currentDate=          currentWeather['dt'];
          currentWind=          currentWeather['wind']['speed'].toString();
          currentLong =         currentWeather['coord']['lon'];
          currentLat =          currentWeather['coord']['lat'];
          weatherType=          currentWeather['weather'][0]['main'];
          weatherCity=          currentWeather['sys']['id'];

        } catch (e) {
          print(e);
        }
      } else {
        print('Could not fetch temperature!');
      }*/
    }else{
      final response = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=${apiKey}&units=metric'
      ));
      if (response.statusCode == 200) {
        String data = response.body;
        //print(data);
        var currentWeather = jsonDecode(data);
        try {
          currentTemperature = currentWeather['main']['temp'];
          currentHumidity = currentWeather['main']['humidity'];
          currentPressure = currentWeather['main']['pressure'];
          currentCondition = currentWeather['weather'][0]['id'];
          currentIcon = currentWeather['weather'][0]['icon'];
          currentDescription = currentWeather['weather'][0]['description'];
          currentLocation=currentWeather['name'];
          //currentDate=currentWeather['dt'];
          currentWind=currentWeather['wind']['speed'].toString();
          currentLong = currentWeather['coord']['lon'];
          currentLat = currentWeather['coord']['lat'];
          weatherType=currentWeather['weather'][0]['main'];
          weatherCity=currentWeather['sys']['id'];

        } catch (e) {
          print(e);
        }
      } else {
        // print('Could not fetch temperature!');
      }
    }
    //http://api.openweathermap.org/data/2.5/weather?id=${weatherCity}&appid=${apiKey}&units=metric'
  }

  WeatherDisplayData getWeatherDisplayData() {
    if(currentCondition!=null) {
      if (currentCondition < 600) {
        var bgimage = '';
        return WeatherDisplayData(
          weatherIcon: Icon(
            FontAwesomeIcons.cloud, size: 40, color: Colors.orange[300],),
          weatherImage: AssetImage('assets/images/farm_image-4.png'),
        );
      } else {
        var now = new DateTime.now();

        if (now.hour >= 15) {
          return WeatherDisplayData(
            weatherImage: AssetImage('assets/images/farm_image-3.png'),
            weatherIcon: Icon(
              FontAwesomeIcons.cloudMoon, size: 40, color: Colors.orange[300],),
          );
        } else {
          return WeatherDisplayData(
            weatherIcon: Icon(
              FontAwesomeIcons.cloudSun, size: 40, color: Colors.orange[300],),
            weatherImage: AssetImage('assets/images/farm_image-1.png'),
          );
        }
      }
    }
  }
}

class WeatherDisplayData {
  Icon weatherIcon;
  AssetImage weatherImage;

  WeatherDisplayData({@required this.weatherIcon, @required this.weatherImage});
}

class LocationHelper {
  double latitude;
  double longitude;

  Future<void> getCurrentLocation() async {
    await Geolocator.getCurrentPosition().then((Position position) {
      latitude=position.latitude;
      longitude=position.longitude;
      // print(latitude);
      // print(longitude);
    }).catchError((e) {
      print(e);
    });
  }
}