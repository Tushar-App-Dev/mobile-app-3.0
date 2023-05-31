import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

import '../Widgets/Loading.dart';
import '../main.dart';
import 'constant/Constant.dart';

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp>  with SingleTickerProviderStateMixin{
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
    queryForecast(position);//queryWeather(position);
    GetAddressFromLatLong(position);
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


  Future<void> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
     Placemark place = placemarks[0];
     //Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    Address = '${place.subAdministrativeArea}';
     //print(Address);
    setState(()  {
    });
  }

  void queryForecast(Position position) async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _state = AppState.DOWNLOADING;
    });

    List<Weather> forecasts = await ws.fiveDayForecastByLocation(position.latitude, position.longitude);
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

    Weather weather = await ws.currentWeatherByLocation(position.latitude, position.longitude);
    setState(() {
      _data = [weather];
      _state = AppState.FINISHED_DOWNLOADING;
      print(_data);
    });
  }


  Widget contentFinishedDownload() {
    return  ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          children: [
            Container(
                height: height(context)*0.80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                width: double.infinity,
                child: TabBarView(
                    controller: _tabController,
                    children: [
                      ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    Address,style: TextStyle(fontFamily: 'Quicksand',fontSize: 17.0)
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    _data[0].date.toString().substring(0,10),style: TextStyle(fontFamily: 'Quicksand',fontSize: 15.0)
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(FontAwesomeIcons.cloudSun,color: Colors.orange,size: 40.0,),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(_data[0].weatherDescription.toString(),style: TextStyle(fontFamily: 'Quicksand',letterSpacing: 0.5)),
                            ),
                          ),
                          SizedBox(height: height(context)*0.02),
                          Container(
                              padding: EdgeInsets.only(right: 15.0,left: 15.0),
                              width: width(context) - 25.0,
                              height: height(context)*0.30,//height(context) - 50.0
                              child: GridView.count(
                                crossAxisCount: 2,
                                primary: false,
                                crossAxisSpacing: 0.0,
                                mainAxisSpacing: 1.0,
                                childAspectRatio: 2.0,
                                children: <Widget>[
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    shadowColor:Colors.grey,
                                    elevation: 10.0,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius:25.0,
                                        child: Icon(FontAwesomeIcons.thermometerEmpty,size: 30.0,),
                                        backgroundColor:Colors.orange,
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(children:[
                                          Flexible( flex: 1,child: Text(_data[0].temperature.toString().substring(0,4)+'\u2103',style: TextStyle(fontSize: 15.0),))
                                        ]),
                                      ),
                                      subtitle: Row(children:[ Flexible(flex: 1,child: Text('Temperature',style: TextStyle(fontSize: 13.0),))]),//style: TextStyle(fontSize: 13.0),
                                      onTap:(){
                                      },
                                    ),
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    shadowColor:Colors.grey,
                                    elevation: 10.0,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius:25.0,
                                        child: Icon(FontAwesomeIcons.thermometerEmpty,size: 30.0,),
                                        backgroundColor:Colors.orange,
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(_data[0].humidity !=null ? _data[0].humidity.toString()+' %':'0 %',style: TextStyle(fontSize: 15.0),),
                                      ),
                                      subtitle:Text('Humidity',style: TextStyle(fontSize: 13.0),),
                                      onTap:(){
                                      },
                                    ),
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    shadowColor:Colors.grey,
                                    elevation: 10.0,
                                    child: ListTile(
                                      leading:CircleAvatar(
                                        radius:25.0,
                                        child: Icon(FontAwesomeIcons.wind,size: 30.0,),
                                        backgroundColor:Colors.orange,
                                      ),
                                      title: Row(children: [
                                        Flexible( flex: 1,child: Text(_data[0].windSpeed.toString()+' km/h',style: TextStyle(fontSize: 15.0),))
                                      ]),
                                      subtitle:Text('Wind',style: TextStyle(fontSize: 13.0),),
                                      onTap:(){
                                      },
                                    ),
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    shadowColor:Colors.grey,
                                    elevation: 10.0,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius:25.0,
                                        child: Icon(FontAwesomeIcons.cloud,size: 30.0,),
                                        backgroundColor:Colors.orange,
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text( _data[0].cloudiness != null ? _data[0].cloudiness.toString()+' %':'0 %',style: TextStyle(fontSize: 15.0),),
                                      ),
                                      subtitle:Text('Cloudy',style: TextStyle(fontSize: 13.0),),
                                      onTap:(){
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          //SizedBox(height: height(context)*0.02),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 5.0,bottom: 2.0),
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.green,),
                                SizedBox(width: 10,),
                                Container(width: 2,height: 20,color: Colors.green,),
                                SizedBox(width: 10,),
                                Flexible(
                                  flex:1,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        Text('Good Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
                                        Text('Potatos, Tomatos, Beans, Cauliflower, Cabbage, Pumpkin, Lettuce'),
                                      ]
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 10.0,bottom: 2.0),
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.yellow,),
                                SizedBox(width: 10,),
                                Container(width: 2,height: 20,color: Colors.green,),
                                SizedBox(width: 10,),
                                Flexible(
                                  flex:1,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        Text('Normal Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
                                        Text('Rice. Wheat, Miller, Dats, Corn, Soy Bean, Mushrooms, Kale'),
                                      ]
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 10.0,bottom: 2.0),
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.red,),
                                SizedBox(width: 10,),
                                Container(width: 2,height: 20,color: Colors.green,),
                                SizedBox(width: 10,),
                                Flexible(
                                  flex:1,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        Text('Bad Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
                                        Text('Tea, Coffee Cilantro'),
                                      ]
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Address,style: TextStyle(fontFamily: 'Quicksand',fontSize: 17.0)
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _data[5].date.toString().substring(0,10),style: TextStyle(fontFamily: 'Quicksand',fontSize: 15.0)
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(FontAwesomeIcons.cloudSun,color: Colors.orange,size: 40.0,),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(_data[5].weatherDescription.toString(),style: TextStyle(fontFamily: 'Quicksand',letterSpacing: 0.5)),
                            ),
                          ),
                          SizedBox(height: height(context)*0.02),
                          Container(
                              padding: EdgeInsets.only(right: 15.0,left: 15.0),
                              width: width(context) - 30.0,
                              height: height(context)*0.30,//height(context) - 50.0
                              child: GridView.count(
                                crossAxisCount: 2,
                                primary: false,
                                crossAxisSpacing: 0.0,
                                mainAxisSpacing: 1.0,
                                childAspectRatio: 2.0,
                                children: <Widget>[
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    shadowColor:Colors.grey,
                                    elevation: 10.0,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius:25.0,
                                        child: Icon(FontAwesomeIcons.thermometerEmpty,size: 30.0,),
                                        backgroundColor:Colors.orange,
                                      ),
                                      // CircleAvatar(
                                      //   backgroundColor: Colors.orange,
                                      //   child:Icon(FontAwesomeIcons.thermometerEmpty,size: 40.0,),
                                      // ),
                                      title: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(_data[5].temperature.toString().substring(0,4)+'\u2103',style: TextStyle(fontSize: 14.0),),
                                      ),
                                      subtitle:Text('Temperature',style: TextStyle(fontSize: 13.0),),
                                      onTap:(){
                                      },
                                    ),
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    shadowColor:Colors.grey,
                                    elevation: 10.0,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius:25.0,
                                        child: Icon(FontAwesomeIcons.thermometerEmpty,size: 30.0,),
                                        backgroundColor:Colors.orange,
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(_data[5].humidity != null ? _data[5].humidity.toString()+' %':'0 %',style: TextStyle(fontSize: 14.0),),
                                      ),
                                      subtitle:Text('Humidity',style: TextStyle(fontSize: 13.0),),
                                      onTap:(){
                                      },
                                    ),
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    shadowColor:Colors.grey,
                                    elevation: 10.0,
                                    child: ListTile(
                                      leading:CircleAvatar(
                                        radius:25.0,
                                        child: Icon(FontAwesomeIcons.wind,size: 30.0,),
                                        backgroundColor:Colors.orange,
                                      ),
                                      title: Text(_data[5].windSpeed.toString()+' km/h',style: TextStyle(fontSize: 14.0),),
                                      subtitle:Text('Wind',style: TextStyle(fontSize: 13.0),),
                                      onTap:(){
                                      },
                                    ),
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    shadowColor:Colors.grey,
                                    elevation: 10.0,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius:25.0,
                                        child: Icon(FontAwesomeIcons.cloud,size: 30.0,),
                                        backgroundColor:Colors.orange,
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text( _data[0].cloudiness != null ? _data[0].cloudiness.toString()+' %':'0 %',style: TextStyle(fontSize: 14.0),),
                                      ),
                                      subtitle:Text('Cloudy',style: TextStyle(fontSize: 13.0),),
                                      onTap:(){
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 5.0,bottom: 2.0),
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.green,),
                                SizedBox(width: 10,),
                                Container(width: 2,height: 20,color: Colors.green,),
                                SizedBox(width: 10,),
                                Flexible(
                                  flex:1,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        Text('Good Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
                                        Text('Potatos, Tomatos, Beans, Cauliflower, Cabbage, Pumpkin, Lettuce'),
                                      ]
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 10.0,bottom: 2.0),
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.yellow,),
                                SizedBox(width: 10,),
                                Container(width: 2,height: 20,color: Colors.green,),
                                SizedBox(width: 10,),
                                Flexible(
                                  flex:1,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        Text('Normal Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
                                        Text('Rice. Wheat, Miller, Dats, Corn, Soy Bean,\n Mushrooms, Kale'),
                                      ]
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 10.0,bottom: 2.0),
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.red,),
                                SizedBox(width: 10,),
                                Container(width: 2,height: 20,color: Colors.green,),
                                SizedBox(width: 10,),
                                Flexible(
                                  flex:1,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        Text('Bad Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
                                        Text('Tea, Coffee Cilantro'),
                                      ]
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    Address,style: TextStyle(fontFamily: 'Quicksand',fontSize: 17.0)
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(FontAwesomeIcons.cloudSun,color: Colors.orange,size: 40.0,),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(_data[12].weatherDescription.toString(),style: TextStyle(fontFamily: 'Quicksand',letterSpacing: 0.5)),
                            ),
                          ),
                          SizedBox(height: height(context)*0.02),
                          Container(
                              padding: EdgeInsets.only(right: 15.0,left: 15.0),
                              width: width(context) - 30.0,
                              height: height(context)*0.30,//height(context) - 50.0
                              child: GridView.count(
                                crossAxisCount: 2,
                                primary: false,
                                crossAxisSpacing: 0.0,
                                mainAxisSpacing: 1.0,
                                childAspectRatio: 2.0,
                                children: <Widget>[
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    shadowColor:Colors.grey,
                                    elevation: 10.0,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius:25.0,
                                        child: Icon(FontAwesomeIcons.thermometerEmpty,size: 30.0,),
                                        backgroundColor:Colors.orange,
                                      ),
                                      // CircleAvatar(
                                      //   backgroundColor: Colors.orange,
                                      //   child:Icon(FontAwesomeIcons.thermometerEmpty,size: 40.0,),
                                      // ),
                                      title: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(_data[12].temperature.toString().substring(0,4)+'\u2103',style: TextStyle(fontSize: 14.0),),
                                      ),
                                      subtitle:Text('Temperature',style: TextStyle(fontSize: 13.0),),
                                      onTap:(){
                                      },
                                    ),
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    shadowColor:Colors.grey,
                                    elevation: 10.0,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius:25.0,
                                        child: Icon(FontAwesomeIcons.thermometerEmpty,size: 30.0,),
                                        backgroundColor:Colors.orange,
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(_data[12].humidity != null ?_data[12].humidity.toString()+' %':'0 %',style: TextStyle(fontSize: 14.0),),
                                      ),
                                      subtitle:Text('Humidity',style: TextStyle(fontSize: 13.0)),
                                      onTap:(){
                                      },
                                    ),
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    shadowColor:Colors.grey,
                                    elevation: 10.0,
                                    child: ListTile(
                                      leading:CircleAvatar(
                                        radius:25.0,
                                        child: Icon(FontAwesomeIcons.wind,size: 30.0,),
                                        backgroundColor:Colors.orange,
                                      ),
                                      title: Text(_data[12].windSpeed.toString()+' km/h',style: TextStyle(fontSize: 14.0)),
                                      subtitle:Text('Wind',style: TextStyle(fontSize: 13.0)),
                                      onTap:(){
                                      },
                                    ),
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    shadowColor:Colors.grey,
                                    elevation: 10.0,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius:25.0,
                                        child: Icon(FontAwesomeIcons.cloud,size: 30.0,),
                                        backgroundColor:Colors.orange,
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(_data[12].cloudiness != null ? _data[12].cloudiness.toString()+' %':'0 %',style: TextStyle(fontSize: 14.0)),
                                      ),
                                      subtitle:Text('Cloudy',style: TextStyle(fontSize: 13.0)),
                                      onTap:(){
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 5.0,bottom: 2.0),
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.green,),
                                SizedBox(width: 10,),
                                Container(width: 2,height: 20,color: Colors.green,),
                                SizedBox(width: 10,),
                                Flexible(
                                  flex:1,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        Text('Good Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
                                        Text('Potatos, Tomatos, Beans, Cauliflower, Cabbage, Pumpkin, Lettuce'),
                                      ]
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 10.0,bottom: 2.0),
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.yellow,),
                                SizedBox(width: 10,),
                                Container(width: 2,height: 20,color: Colors.green,),
                                SizedBox(width: 10,),
                                Flexible(
                                  flex:1,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        Text('Normal Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
                                        Text('Rice. Wheat, Miller, Dats, Corn, Soy Bean, Mushrooms, Kale'),
                                      ]
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0,right: 8.0,top: 10.0,bottom: 2.0),
                            child: Row(
                              children: [
                                Icon(FontAwesomeIcons.checkCircle,size: 30.0,color: Colors.red,),
                                SizedBox(width: 10,),
                                Container(width: 2,height: 20,color: Colors.green,),
                                SizedBox(width: 10,),
                                Flexible(
                                  flex:1,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        Text('Bad Condition for',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
                                        Text('Tea, Coffee Cilantro'),
                                      ]
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]
                )
            )
          ],
        ),
      ],
    );
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
            child: Center(child: Loading()))//CircularProgressIndicator(strokeWidth: 10)
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
        body: Column(
          children: <Widget>[
            Container(
              height:height(context)*0.13,
              // decoration: BoxDecoration(
                   color: Colors.green,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                        margin: EdgeInsets.only(left: 20,top:35),
                        child:IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          }, icon:Icon(Icons.arrow_back, color: Colors.white),

                        )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20,top:35),
                    child: Center(
                      child: Text(
                        'Weather Condition',
                          style: TextStyle(
                            fontFamily: 'Varela',
                            fontSize: 21.0,color: Colors.white,fontWeight: FontWeight.bold
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height:height(context)*0.07,
              width: width(context),
              color: Colors.white,
              child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.transparent,
                  labelColor: Colors.green,//Color(0xFFC88D67),
                  isScrollable: true,
                  labelPadding: EdgeInsets.only(right: 25.0,left:25.0),
                  unselectedLabelColor:Colors.orange, //Color(0xFFCDCDCD),
                  tabs: [
                    GestureDetector(
                      onTap: () async {
                        Position position = await _getGeoLocationPosition();
                        queryForecast(position);//queryWeather(position);
                        GetAddressFromLatLong(position);
                      },
                      child: Tab(
                        child: Text('Today',
                            style: TextStyle(
                              fontFamily: 'Varela',
                              fontSize: 21.0,
                            )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Position position = await _getGeoLocationPosition();
                        queryForecast(position);//queryWeather(position);
                        GetAddressFromLatLong(position);
                      },
                      child: Tab(
                        child: Text('Tomorrow',
                            style: TextStyle(
                              fontFamily: 'Varela',
                              fontSize: 21.0,
                            )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Position position = await _getGeoLocationPosition();
                        queryForecast(position);//queryWeather(position);
                        GetAddressFromLatLong(position);
                      },
                      child: Tab(
                        child: Text('After 1 Day',
                            style: TextStyle(
                              fontFamily: 'Varela',
                              fontSize: 21.0,
                            )),
                      ),
                    )
                  ]
              ),
            ),
            Expanded(
                child: _resultView())
          ],
        ),
      //bottomNavigationBar: _buttons(),
    );
  }
}