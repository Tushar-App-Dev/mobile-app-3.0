import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mmc_master/Screens/NewScreens/ExpertCall.dart';
import 'package:mmc_master/Screens/NewScreens/newDashBoard.dart';
import 'package:mmc_master/Screens/NewScreens/userProfileActivity.dart';
import 'package:mmc_master/Screens/NewScreens/weatherDetail.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:new_version/new_version.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Authentication/LoginPageActivity.dart';
import '../../Mandi/MandiPriceData.dart';
import '../../Mandi/MandiPriceData1.dart';
import '../../WebViews/CustomerSupport.dart';
import '../../WebViews/MyWebView.dart';
import '../../WebViews/WeatherIframe.dart';
import '../../constants/constants.dart';
import '../../main.dart';
import '../CropGuideDashboard.dart';
import '../NewDesigns/Mmc_HomePage.dart';
import '../VideoFiles.dart';
import '../constant/Constant.dart';
import 'AddNewFarmsActivity.dart';
import 'ContactUsActivity.dart';
import 'FeedbackActivity.dart';
import 'package:permission_handler/permission_handler.dart';
import 'FertilizerCalculaterActivity.dart';
import 'Instructions.dart';
import 'Mmc_DashBoard.dart';
import 'SelfProduceActivity.dart';
import 'autocompletePlaces.dart';

// int temperature,pressure;
// Icon weatherDisplayIcon;
// String locationName;
// AssetImage backgroundImage;
// var locdata;
// var humidity;
// int date;
// var dt;
// String wind,
var currentTemperatures = [];
var currentHumiditys = [];
var currentPressures = [];
var currentConditions = [];
var currentIcons = [];
var currentDescriptions = [];
var currentLocations = [];
//var currentDates = [];
var currentWinds = [];
var currentLongs = [];
var currentLats = [];
var weatherTypes = [];
var weatherCitys = [];

class DashboardActivity extends StatefulWidget {
  const DashboardActivity({Key key}) : super(key: key);

  @override
  State<DashboardActivity> createState() => _DashboardActivityState();
}

class _DashboardActivityState extends State<DashboardActivity> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String uid,
      user,
      email,
      phone,
      api_key,
      selectedLanguage,
      currentLanguage = '',
      imageUrl = '',
      urlPath =
          "https://play.google.com/store/apps/details?id=com.mapmycrop.mmc",
      text = '',
      subject = '';
  List<String> imagePaths = [];
  NewVersion newVersion = NewVersion();
  String noofFarms = '';
  var profileData;
  bool _isinstructions;
  //final plugin = FacebookLogin(debug: true);

  final _key = GlobalKey<ScaffoldState>();
  // CarouselController _carouselController = CarouselController();
  var imagesList = [
    'assets/illustrations/Carousel0.jpeg',
    'assets/illustrations/Carousel1.jpeg',
    'assets/illustrations/Carousel2.jpeg',
    'assets/illustrations/Carousel3.jpeg',
    /* 'assets/illustrations/1.png',
    'assets/illustrations/2.png',
    'assets/illustrations/3.png',
    'assets/illustrations/4.png',*/
    // 'https://media.istockphoto.com/photos/sunrise-strawberry-farm-landscape-agricultural-agriculture-picture-id1091940998?k=20&m=1091940998&s=612x612&w=0&h=cs6cFdycUbBph7bdpmr1bqrNaaoioETjXB_Np8MaMus=',
    /*'assets/Banners/Banner 2.png',
    'assets/Banners/Banner 1.png',
    'assets/Banners/Banner 3.png'*/
  ];
List<String> quoteList = [
  'Track your crops with the\nhelp of satellite in realtime,\ngain valuable insights',
  'maximize your yields with\nthe power of AI and machine learning',
  'Your route towards\nsustainable farming',
  'Sell your produce\naccording to market rates'
];
  int _currentIndex = 0;
  var title1, title2;
  SharedPreferences prefs;
  List<String> farmnames = [];
  static const List<String> LanguageCodes = [
    'en',
    'hi',
    'es',
    'fr',
    'mr',
    'bn',
    'gu',
    'ml',
    'pa',
    'ta',
    'te'
  ];
  static const List<String> Languages = [
    'English',
    'Hindi',
    'Spanish',
    'French',
    'Marathi',
    'Bengali',
    'Gujarati',
    'Malayalam',
    'Punjabi',
    'Tamil',
    'Telugu'
  ];
  CollectionReference userProfile =
      FirebaseFirestore.instance.collection('ProfileImages');
  List<HorizontalScroll> horizontalScroll = [
    HorizontalScroll(name: "Add farm", image: 'assets/images/Add_Farm.png'),
    HorizontalScroll(
        name: "Scouting", image: 'assets/illustrations/scouting.png'),
    HorizontalScroll(name: "Disease", image: 'assets/images/Detection.png'),
    HorizontalScroll(name: "Planner", image: 'assets/new_images/Planner.png'),
    HorizontalScroll(
        name: "Schedule a call", image: 'assets/images/Schedule.png'),
    HorizontalScroll(
        name: "Image Download", image: 'assets/images/Image_download.png'),
    HorizontalScroll(name: "Markets", image: 'assets/new_images/Markets.png')
  ];

  List<HorizontalScroll1> horizontalScroll1 = [
    HorizontalScroll1(
        name: "Disease Advisory", image: 'assets/svgImages/Advisory.svg'),
    HorizontalScroll1(
        name: "Crop Rotations", image: 'assets/svgImages/Add_Crop.svg'),
    HorizontalScroll1(name: "Scouting", image: 'assets/svgImages/Scouting.svg'),
    HorizontalScroll1(
        name: "Farm Planner", image: 'assets/svgImages/Farm_Planner.svg'),
    // HorizontalScroll1(
    //     name: "Schedule a call", image: 'assets/images/Schedule.png'),
    // HorizontalScroll1(
    //     name: "Image Download", image: 'assets/images/Image_download.png'),
    // HorizontalScroll1(name: "Markets", image: 'assets/new_images/Markets.png')
  ];

  @override
  void initState() {
    /// newVersion change ds4 to ds5
    ///

    permission();
    //getImageTitle();
    fetchFarmsData();
    // getGlobalCropList();
    showNotification();
    initPlatformState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      // IOSNotification ios = message.notification?.apple;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                ),
                iOS: const IOSNotificationDetails(
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true,
                )));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body)],
                  ),
                ),
              );
            });
      }
    });
    getWeatherData();
    _checkVersion();
    super.initState();
  }

  /*getGlobalCropList(String api_key) async {

    print(api_key);
    List<String> temp = prefs.getStringList('translatedCropList')??[];
    if(temp.isEmpty||temp.last!=prefs.getString('language')){
      print('entered if in getGlobalCropLIst');
      globalCropList.clear();
      globalCropListTranslated.clear();
      var response = await http
          .get(Uri.parse("https://api.mapmycrop.com/crop?api_key=$api_key"));
      var cropData = jsonDecode(response.body);
      print(cropData);
      for (int i = 0; i < cropData.length; i++) {
        //var translatedCrop = );

        globalCropList.add(cropData[i]['name']);

        //  });
        var temp = await changeLanguage(cropData[i]['name']);
        globalCropListTranslated.add(temp);
        print('temp is ${cropData[i]['name']} and translated is $temp');
        //print(await changeLanguage(cropData[i]['name']));
      }
      globalCropListTranslated.add(prefs.getString('language'));

      // prefs.setStringList('globaltranslatedCropList',globalCropListTranslated);
      prefs.setStringList('cropList', globalCropList);
      prefs.setStringList('translatedCropList', globalCropListTranslated);
      print('global croplist added');
    }else{
      print('entered else in getGlobalCropLIst');
      setState(() {
        globalCropList = prefs.getStringList('cropList');
        globalCropListTranslated = prefs.getStringList('translatedCropList');
      });
    }

    //globalCropList
  }*/


  Future<bool> internetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (farmnames.isNotEmpty &&
            currentPressures.isNotEmpty &&
            currentHumiditys.isNotEmpty &&
            currentWinds.isNotEmpty) {
        } else {
          // getWeatherData();
        }
        if (noofFarms == '' && noofFarms == 'null') {
          // fetchFarmsData();
        }

        // prefs?.setString('cropList', cropList.toString());
       // print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }

  permission() async {
    if (await Permission.location.isGranted != true) {
      Permission.location.request();
    } else {
      print('permission allowed');
    }
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  void showNotification() {
    flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        "New Images are available",
        "Check your dashboard to see the Respected Images...",
        RepeatInterval.daily,
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher'),
            iOS: const IOSNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            )));
  }

  void fetchFarmsData() async {
    var data;
    prefs = await SharedPreferences.getInstance();
    api_key = prefs.getString('api_key');
    //selectedLanguage=prefs.getString('language');
    _isinstructions = prefs.getBool("instructions");

    print('api key is   $api_key');
    FirebaseAnalytics.instance
        .logEvent(
          name: "app_visit",
          parameters: {
            "content_type": "Activity_planned",
            "api_key": api_key,
          },
        )
        .then((value) => print('succeeeed'))
        .onError((error, stackTrace) => print('analytics error is $error'));

    /*FirebaseAnalytics.instance.logEvent(
    name: 'test_event',
    parameters: <String, dynamic>{
    'string': 'string',
    'int': 42,
    'long': 12345678910,
    'double': 42.0,
    // Only strings and numbers (ints & doubles) are supported for GA custom event parameters:
    // https://developers.google.com/analytics/devguides/collection/analyticsjs/custom-dims-mets#overview
    'bool': true.toString(),
    },
    );*/
    var response = await http
        .get(Uri.parse('https://api.mapmycrop.com/farm/?api_key=$api_key'));
    data = jsonDecode(response.body);
    // print(response.body);

    setState(() {
      imageUrl = prefs.getString('profileImage') ?? '';

      currentLanguage =
          Languages[LanguageCodes.indexOf(prefs.getString('language'))];
      noofFarms = data.length.toString();
    });
    if (imageUrl.isEmpty) {
      if (imageUrl.isEmpty) {
        var result = await userProfile.doc(api_key).get();
        print(result.data());
        if (result.data() != null) {
          setState(() {
            imageUrl = result['profileImage'];
          });
        }
      }
    }
    farmnames.clear();

    for (int i = 0; i < data.length; i++) {
      setState(() {
        farmnames.add(data[i]['name']);
      });
    }
    //print(farmnames);

    var response1 = await http
        .get(Uri.parse('https://api.mapmycrop.com/profile/?api_key=$api_key'));
    profileData = jsonDecode(response1.body);
    setState(() {
      email = profileData['email'];
      phone = profileData['phone'];
    });

  }

  _checkVersion() async {
    final newVersion = NewVersion(
      /// Change plugin line 183 with this line (elm) => elm.text.contains('key: \'ds:5\''),
      androidId: 'com.mapmycrop.mmc',
      // iOSId: iOSAppId
    );

    final status = await newVersion.getVersionStatus();
    if (status != null) {
      if (status.canUpdate) {
        newVersion.showUpdateDialog(
            context: context,
            versionStatus: status,
            dialogTitle: "Update!!!",
            dismissButtonText: "Skip",
            dialogText: "Please update your app from " +
                "${status.localVersion}" +
                " to " +
                "${status.storeVersion}",
            allowDismissal: true,
            dismissAction: () {
              Navigator.pop(context);
              //SystemNavigator.pop();
            },
            updateButtonText: "Update");
      }
      // print("app version on Device " + "${status.localVersion}");
      // print("app version on store " + "${status.storeVersion}");
    }
  }

  var temperature, pressure;
  Icon weatherDisplayIcon;
  String locationName;
  AssetImage backgroundImage;
  var locdata;
  var humidity;
  int date;
  //var dt;
  String wind, _user, _usercred;
  String bgImg;
  GoogleTranslator translator = GoogleTranslator();
  var output;

  void updateDisplayInfo(WeatherData weatherData) {
//    print(weatherData.currentTemperature);
    print('updateDisplayInfo ');
    setState(() {
      temperature = weatherData.currentTemperature ?? 0.000000.round();
      WeatherDisplayData weatherDisplayData =
          weatherData.getWeatherDisplayData();

      backgroundImage = weatherDisplayData.weatherImage ??
          AssetImage('assets/new_images.back.png');
      weatherDisplayIcon = weatherDisplayData.weatherIcon ?? Icon(Icons.sunny);
      locationName = weatherData.currentLocation;
      locdata = weatherData.currentDescription;
      humidity = weatherData.currentHumidity;
      date = weatherData.currentDate;
      pressure = weatherData.currentPressure;
      //dt = DateTime.fromMicrosecondsSinceEpoch(date);
      wind = weatherData.currentWind;
      if (weatherData.weatherType == 'Clear') {
        bgImg = 'assets/images/sunny.jpg';
      } else if (weatherData.weatherType == 'Night') {
        bgImg = 'assets/images/night.jpg';
      } else if (weatherData.weatherType == 'Rainy') {
        bgImg = 'assets/images/rainy.jpg';
      } else if (weatherData.weatherType == 'Clouds') {
        bgImg = 'assets/images/cloudy.jpeg';
      } else {
        bgImg = 'assets/images/sunny.jpg';
      }
    });
    // print('here');
    print('''
    $temperature
    $backgroundImage
    $weatherDisplayIcon
    $locationName
    $locdata
    $humidity
    $date
    $pressure
    $wind
    ''');
  }

  LocationHelper _locationHelper;
  Future<void> getLocationData() async {
    _locationHelper = LocationHelper();
    await _locationHelper.getCurrentLocation();
    if (_locationHelper.longitude == null || _locationHelper.latitude == null) {
      print("data not fetched!");
    } else {
      //print(_locationHelper.latitude);
    }
  }

  void getWeatherData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _user = prefs.getString('username');
    _usercred = prefs.getString('usercred');
    // Fetch the location
    await getLocationData();
    // Fetch the current weather
    WeatherData weatherData = await WeatherData(locationData: _locationHelper);
    await weatherData.getCurrentTemperature();
    if (weatherData.currentTemperature != null &&
        weatherData.currentCondition != null) {
      updateDisplayInfo(weatherData);
      // todo: Handle no weather
    }

    //Get.to(()=>MainScreen(weatherData: weatherData,));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = height(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        key: _key,
        backgroundColor: Color(0xffECB34F),
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            const Expanded(
              child: Text(''),
            ),
            // IconButton(
            //     icon: const Icon(
            //       Icons.notifications_none,
            //       color: Colors.white,
            //       size: 30,
            //     ),
            //     onPressed: () {}),
            // const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                FirebaseAnalytics.instance.logEvent(
                  name: "user_profile",
                  parameters: {
                    "content_type": "Activity_planned",
                    "api_key": api_key,
                  },
                ).onError(
                    (error, stackTrace) => print('analytics error is $error'));
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        userProfileActivity())); //user:user,usercred:email
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                  // image: const DecorationImage(
                  //   image: AssetImage('assets/icon/profile.jpg'),
                  //   fit: BoxFit.fitHeight,
                  // ),
                ),
                child: /*imageUrl==null||imageUrl == ''?Icon(
                  Icons.account_circle_sharp,
                  color: Colors.black87,
                  size: 30,
                ):*/
                    Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.orange),
                    image: DecorationImage(
                        image: imageUrl == "" || imageUrl == null
                            ? AssetImage('assets/new_images/logo.png')
                            : NetworkImage(imageUrl),
                        fit: BoxFit
                            .fill), //CachedNetworkImageProvider('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTD8u1Nmrk78DSX0v2i_wTgS6tW5yvHSD7o6g&usqp=CAU')),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ListView(
            children: [

              CarouselSlider(
                options: CarouselOptions(
                  viewportFraction: 0.95,
                  height: height(context) * 0.22,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(
                      () {
                        _currentIndex = index;
                        //getImageTitle();
                      },
                    );
                  },
                ),
                items: imagesList
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Stack(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              margin: EdgeInsets.only(
                                top: 10.0,
                                bottom: 10.0,
                              ),
                              elevation: 1.0,
                              //   shadowColor: Colors.grey,
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(10.0),
                              // ),
                              child:
                                  Stack(alignment: Alignment.topCenter, children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  child: Image.asset(
                                    item,
                                    // cacheColorFilter:true,
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(vertical: 20.0),
                                //   child: Text(title1,style: TextStyle(fontWeight: FontWeight.w600),),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(vertical: 40.0),
                                //   child: Text(title2,style: TextStyle(fontWeight: FontWeight.w600),),
                                // )
                              ]),
                            ),
                            Positioned(
                                bottom: height(context)*0.02,
                                left:height(context)*0.02,
                                child: languageText(quoteList[imagesList.indexOf(item)], TextStyle(color: white,fontWeight: FontWeight.w600,),))
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              Center(
                child: Container(
                  width: width(context) * 0.2,
                  height: height(context) * 0.01,
                  child: ListView.builder(
                      physics: ScrollPhysics(),
                      itemCount: imagesList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          height: height(context) * 0.01,
                          width: i == _currentIndex ? 20 : 10,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Color(0xff4e6703)),
                              color: i == _currentIndex
                                  ? Color(0xff4e6703)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(
                                  height(context) * 0.005)),
                        );
                      }),
                ),
              ),
              farmnames.isNotEmpty &&
                      currentPressures.isNotEmpty &&
                      currentHumiditys.isNotEmpty &&
                      currentWinds.isNotEmpty
                  ? CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 21 / 11,
                        viewportFraction: 0.95,
                        //height: height(context) * 0.23,
                        autoPlay: false,
                        //enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) {
                          // setState(
                          //   () {
                          //     _currentIndex = index;
                          //     //getImageTitle();
                          //   },
                          // );
                        },
                      ),
                      items: farmnames.map(
                        (item) {
                          //  print(farmnames);
                          var index = farmnames.indexOf(item);
                          // print(index);
                          return Container(
                            padding: EdgeInsets.symmetric(vertical:8,horizontal: 12),
                            margin: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 20
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 12,
                                    spreadRadius: 0,
                                    color: Colors.grey.shade200)
                              ],
                              //borderRadius: BorderRadius.circular(10),
                              /*image: DecorationImage(
                            //opacity: 0.8,
                            //image: SvgPicture.asset('assets/illustrations/FertilizerRecommendation.jpg'),
                            fit: BoxFit.fill,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.82), BlendMode.dstATop),
                          )*/
                            ),

                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ChangedLanguage(
                                  text: 'Current Weather',
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,

                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          farmnames.isNotEmpty
                                              ? farmnames[index]
                                              : currentLocations[index],
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            //Image.asset(currentIcons.length>index?currentIcons[index]:"assets/new_images/back.png",height:50,width:70,fit: BoxFit.fill,),
                                            //Text('"\"${currentIcons.length>index?currentIcons[index]:''}'),
                                            //Icon(Icons.sunny,color: Colors.orangeAccent,size: 50,),
                                            // ?? Icon(Icons.sunny,color: Colors.orangeAccent,size: 50,),
                                            /*Image.network(
                                              'http://openweathermap.org/img/w/${currentIcons.length > index ? currentIcons[index] : ""}.png',*/
                                            SvgPicture.asset(
                                                        "assets/svgImages/${currentIcons.length > index ? currentIcons[index].toString().substring(0, 2) + "d.svg" : ""}",
                                                        height: 60,
                                                        width: 70,
                                                        fit: BoxFit.fill,
                                                      )
                                                ,
                                            /*SizedBox(width:10,),*/
                                            ChangedLanguage(
                                              text: currentTemperatures
                                                          .length >
                                                      index
                                                  ? '${currentTemperatures[index]}\u2103'
                                                  : '',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.blueGrey),
                                            )
                                          ],
                                        ),
                                        // SizedBox(height:10,),
                                        SizedBox(
                                            width: width(context) * 0.35,
                                            child: ChangedLanguage(
                                              text: currentDescriptions
                                                          .length >
                                                      index
                                                  ? currentDescriptions[
                                                          index] ??
                                                      ''
                                                  : '',
                                              style: TextStyle(
                                                  color: Colors.blueGrey),
                                            ))
                                      ],
                                    ),
                                    /*SizedBox(
                                      width: width(context) * 0.02,
                                    ),*/
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //Text('Feels Like 34\u2103',style: TextStyle(color: Colors.blueGrey),),
                                        // Row(
                                        //   children: [
                                        //     Icon(Icons.arrow_upward,color: Colors.blueGrey),
                                        //     Text('37\u2103',style: TextStyle(color: Colors.blue),),
                                        //     SizedBox(width: 20,),
                                        //     Icon(Icons.arrow_downward,color: Colors.blueGrey,),
                                        //     Text('34\u2103',style: TextStyle(color: Colors.blue),)
                                        //   ],
                                        // ),
                                        Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.water_drop,
                                                color: Colors.blueGrey,
                                                size: 15),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            ChangedLanguage(
                                              text: 'Humidity',
                                              style: TextStyle(
                                                  color: Colors.blueGrey),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${currentHumiditys.length > index ? currentHumiditys[index] ?? '' : ''}%',
                                              style: TextStyle(
                                                  color: Colors.blue),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.wind,
                                              color: Colors.blueGrey,
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            ChangedLanguage(
                                              text: 'Wind',
                                              style: TextStyle(
                                                  color: Colors.blueGrey),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${currentWinds.length > index ? currentWinds[index] ?? '' : ''}kph',
                                              style: TextStyle(
                                                  color: Colors.blue),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.compress,
                                                color: Colors.blueGrey,
                                                size: 17),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            ChangedLanguage(
                                              text: 'Pressure',
                                              style: TextStyle(
                                                  color: Colors.blueGrey),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${currentPressures.length > index ? currentPressures[index] ?? '' : ''}hPa',
                                              style: TextStyle(
                                                  color: Colors.blue),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    )
                  : noofFarms == 0
                      ? Card(
                          elevation: 1,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              // image: new DecorationImage(
                              //   image: new AssetImage(bgImg),
                              //   fit: BoxFit.fill,
                              //   colorFilter: ColorFilter.mode(
                              //       Colors.black.withOpacity(0.90), BlendMode.dstATop),
                              // ),s
                              // boxShadow: [
                              //   BoxShadow(
                              //     blurRadius: 4.0,
                              //     color: Colors.grey,
                              //   ) //spreadRadius: 2.0
                              // ]
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ChangedLanguage(
                                  text: 'Currrent Weather',
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          locationName ?? '',
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            //Image.asset('assets/images/temperature.png',height:50,width:70,fit: BoxFit.fill,),
                                            //Icon(Icons.sunny,color: Colors.orangeAccent,size: 50,),
                                            weatherDisplayIcon != null
                                                ? weatherDisplayIcon
                                                : Icon(
                                                    Icons.sunny,
                                                    color: Colors.orangeAccent,
                                                    size: 50,
                                                  ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              temperature != null
                                                  ? '${temperature}\u2103'
                                                  : '',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.blueGrey),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ChangedLanguage(
                                          text: locdata != null ? locdata : '',
                                          style:
                                              TextStyle(color: Colors.blueGrey),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: width(context) * 0.15,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //Text('Feels Like 34\u2103',style: TextStyle(color: Colors.blueGrey),),
                                          // Row(
                                          //   children: [
                                          //     Icon(Icons.arrow_upward,color: Colors.blueGrey),
                                          //     Text('37\u2103',style: TextStyle(color: Colors.blue),),
                                          //     SizedBox(width: 20,),
                                          //     Icon(Icons.arrow_downward,color: Colors.blueGrey,),
                                          //     Text('34\u2103',style: TextStyle(color: Colors.blue),)
                                          //   ],
                                          // ),
                                          Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.water_drop,
                                                  color: Colors.blueGrey),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              ChangedLanguage(
                                                text: 'Humidity',
                                                style: TextStyle(
                                                    color: Colors.blueGrey),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${humidity ?? ''}%',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(FontAwesomeIcons.wind,
                                                  color: Colors.blueGrey),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              ChangedLanguage(
                                                text: 'Wind',
                                                style: TextStyle(
                                                    color: Colors.blueGrey),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${wind ?? ''}kph',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.compress,
                                                  color: Colors.blueGrey),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              ChangedLanguage(
                                                text: 'Pressure',
                                                style: TextStyle(
                                                    color: Colors.blueGrey),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${pressure ?? ''}hPa',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ))
                      : SizedBox(),

              /*:Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.symmetric(horizontal:5,vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      // image: new DecorationImage(
                      //   image: new AssetImage(bgImg),
                      //   fit: BoxFit.fill,
                      //   colorFilter: ColorFilter.mode(
                      //       Colors.black.withOpacity(0.90), BlendMode.dstATop),
                      // ),s
                      // boxShadow: [
                      //   BoxShadow(
                      //     blurRadius: 4.0,
                      //     color: Colors.grey,
                      //   ) //spreadRadius: 2.0
                      // ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ChangedLanguage(text:'Currrent Weather',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w700,fontSize:17),),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    //Image.asset('assets/images/temperature.png',height:50,width:70,fit: BoxFit.fill,),
                                    //Icon(Icons.sunny,color: Colors.orangeAccent,size: 50,),
                                    Icon(Icons.sunny,color: Colors.orangeAccent,size: 50,),
                                    SizedBox(width:10,),
                                    Text('\u2103',style: TextStyle(fontSize:25,color: Colors.blueGrey),)
                                  ],
                                ),
                                SizedBox(height:10,),
                                Text('',style: TextStyle(color: Colors.blueGrey),)
                              ],
                            ),
                            SizedBox(width:width(context)*0.15,),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Text('Feels Like 34\u2103',style: TextStyle(color: Colors.blueGrey),),
                                  // Row(
                                  //   children: [
                                  //     Icon(Icons.arrow_upward,color: Colors.blueGrey),
                                  //     Text('37\u2103',style: TextStyle(color: Colors.blue),),
                                  //     SizedBox(width: 20,),
                                  //     Icon(Icons.arrow_downward,color: Colors.blueGrey,),
                                  //     Text('34\u2103',style: TextStyle(color: Colors.blue),)
                                  //   ],
                                  // ),
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.water_drop,color: Colors.blueGrey),
                                      SizedBox(width: 10,),
                                      ChangedLanguage(text:'Humidity',style: TextStyle(color: Colors.blueGrey),),
                                      SizedBox(width: 10,),
                                      Text(' %',style: TextStyle(color: Colors.blue),)
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(FontAwesomeIcons.wind,color: Colors.blueGrey),
                                      SizedBox(width: 10,),
                                      ChangedLanguage(text:'Wind',style: TextStyle(color: Colors.blueGrey),),
                                      SizedBox(width: 10,),
                                      Text(' kph',style: TextStyle(color: Colors.blue),)
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.compress,color: Colors.blueGrey),
                                      SizedBox(width: 10,),
                                      ChangedLanguage(text:'Pressure',style: TextStyle(color: Colors.blueGrey),),
                                      SizedBox(width: 10,),
                                      Text(' hPa',style: TextStyle(color: Colors.blue),)
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )*/
              /*
                      )*/ //SizedBox(),

              SizedBox(
                height: 10,
              ),

              Container(
                margin: const EdgeInsets.only(top: 15),
                padding:
                    EdgeInsets.symmetric(horizontal: width(context) * 0.05),
                child: Column(
                  children: [
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Agronomist's Advice",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExpertCall(
                                        user: user, email: email, phone: phone)));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Center(
                              child: Icon(
                                Icons.phone,
                                color: Color(0xffECB34F),
                                size: 18,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),*/
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              print(_isinstructions);
                              _isinstructions != true
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DrawGuideActivity()))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddNewFarmsActivity()));
                              FirebaseAnalytics.instance.logEvent(
                                name: "add_farm",
                                parameters: {
                                  "content_type": "Activity_planned",
                                  "api_key": api_key,
                                },
                              ).onError((error, stackTrace) =>
                                  print('analytics error is $error'));
                            },
                            child: Container(
                              height: height(context) * 0.18,
                              width: width(context) * 0.45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 12,
                                      spreadRadius: 0,
                                      color: Colors.grey.shade200)
                                ],
                                border: Border.all(
                                    color: Colors.grey.shade400, width: 1),
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          height: height(context) * 0.12,
                                          width: height(context) * 0.12,
                                          decoration: BoxDecoration(
                                              //border: Border.all(color: Colors.grey.shade300,width: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      height(context) * 0.07),
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 12,
                                                    spreadRadius: 0,
                                                    color: Colors.grey.shade200)
                                              ]
                                              //color: Colors.black,//Color(color),

                                              /*image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                              horizontalScroll1[index].image,
                                            ))*/
                                              ),
                                          /* child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: const EdgeInsets.all(6.0),
                                              child: Text(
                                                'My Farm Monitoring',
                                                // style: TextStyle(
                                                // color: Colors.black,
                                                // fontSize: 16,
                                                // fontWeight: FontWeight.w600)
                                              ),
                                            )),*/
                                          child: Center(
                                              child: SvgPicture.asset(
                                                  'assets/svgImages/Add_Farm.svg')),
                                        ),
                                        Positioned(
                                            right: 5,
                                            top: 5,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.white,
                                                ),
                                                child: Icon(
                                                    Icons.add_circle_outline,
                                                    color: Color(0xffeb3a0f))))
                                      ],
                                    ),
                                    // SizedBox(height: 10),
                                    FutureBuilder(
                                      future: changeLanguage("Add Farm"),
                                      builder: (context, i) => i.hasData
                                          ? Text(
                                              i.data,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: height(context)*0.016),textAlign: TextAlign.center,maxLines: 2,
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
                                    )
                                    /*ChangedLanguage(text:horizontalScroll1[index].name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                  )),*/
                                  ]),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () async {
                              noofFarms != '0'
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyWebView(
                                                api_key: api_key,
                                              )))
                                  : QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.info,
                                      title:
                                          await changeLanguage('Information'),
                                      text: await changeLanguage(
                                          'Please add your farm first...'),
                                    );
                              FirebaseAnalytics.instance.logEvent(
                                name: "farm_monitoring",
                                parameters: {
                                  "content_type": "Activity_planned",
                                  "api_key": api_key,
                                },
                              ).onError((error, stackTrace) =>
                                  print('analytics error is $error'));
                            },
                            child: Container(
                              height: height(context) * 0.18,
                              width: width(context) * 0.45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 12,
                                      spreadRadius: 0,
                                      color: Colors.grey.shade200)
                                ],
                                border: Border.all(
                                    color: Colors.grey.shade400, width: 1),
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(2),
                                      height: height(context) * 0.12,
                                      width: height(context) * 0.12,
                                      decoration: BoxDecoration(
                                          //border: Border.all(color: Colors.grey.shade300,width: 0.5),
                                          borderRadius: BorderRadius.circular(
                                              height(context) * 0.07),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 12,
                                                spreadRadius: 0,
                                                color: Colors.grey.shade200)
                                          ]
                                          //color: Colors.black,//Color(color),

                                          /*image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                              horizontalScroll1[index].image,
                                            ))*/
                                          ),
                                      /* child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: const EdgeInsets.all(6.0),
                                              child: Text(
                                                'My Farm Monitoring',
                                                // style: TextStyle(
                                                // color: Colors.black,
                                                // fontSize: 16,
                                                // fontWeight: FontWeight.w600)
                                              ),
                                            )),*/
                                      child: Center(
                                          child: SvgPicture.asset(
                                              'assets/svgImages/Monitoring.svg')),
                                    ),
                                    // SizedBox(height: 10),
                                    FutureBuilder(
                                      future:
                                          changeLanguage('My Farm Monitoring'),
                                      builder: (context, i) => i.hasData
                                          ? Text(
                                              i.data,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: height(context)*0.016),textAlign: TextAlign.center,maxLines: 2,
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
                                    // ChangedLanguage(text:'My Farm Monitoring',
                                    //     textAlign: TextAlign.center,
                                    //     style: TextStyle(
                                    //       // color: Colors.black,
                                    //       fontSize: 16,
                                    //     )),
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     noofFarms!=0?
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => MyWebView(
                    //                   api_key: api_key,
                    //                 ))):QuickAlert.show(
                    //       context: context,
                    //       type: QuickAlertType.info,
                    //       text: 'Please add your farm first ',
                    //     );
                    //     // showDialog(
                    //     //     context: context,
                    //     //     builder: (BuildContext context) {
                    //     //       return AlertDialog(
                    //     //         backgroundColor: Colors.red[100],
                    //     //         title: Text("Farm Required"),
                    //     //         content: Text("Please add your farm first"),
                    //     //         actions: <Widget>[
                    //     //           IconButton(
                    //     //               icon: Icon(Icons.check),
                    //     //               onPressed: () {
                    //     //                 Navigator.of(context).pop();
                    //     //               })
                    //     //         ],
                    //     //       );
                    //     //     });
                    //   },
                    //   child: Container(
                    //     width: width(context) * 0.9,
                    //     height: height(context) * 0.06,
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(10),
                    //       border: Border.all(color: Color(0xffECB34F), width: 1),
                    //     ),
                    //     padding: const EdgeInsets.symmetric(horizontal: 15),
                    //     child: Row(
                    //       children: [
                    //         Image.asset(
                    //           "assets/images/farm_image-3.png",
                    //           height: 40,
                    //           width: 40,
                    //         ),
                    //         const SizedBox(
                    //           width: 18,
                    //         ),
                    //         const Text('Disease Advisory'),
                    //         Expanded(
                    //           child: Container(),
                    //         ),
                    //         Icon(
                    //           Icons.arrow_forward_ios,
                    //           size: height(context) * 0.02,
                    //           color: Color(0xffECB34F),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 7,
                    // ),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => const AdvisoryActivity()));
                    //   },
                    //   child: Container(
                    //     width: width(context) * 0.9,
                    //     height: height(context) * 0.06,
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(10),
                    //       border: Border.all(color: Color(0xffECB34F), width: 1),
                    //     ),
                    //     padding: const EdgeInsets.symmetric(horizontal: 15),
                    //     child: Row(
                    //       children: [
                    //         Image.asset(
                    //           "assets/new_icons/Disease detection.png",
                    //           height: 55,
                    //           width: 55,
                    //         ),
                    //         const SizedBox(
                    //           width: 10,
                    //         ),
                    //         const Text('Disease Advisory'),
                    //         Expanded(
                    //           child: Container(),
                    //         ),
                    //         Icon(
                    //           Icons.arrow_forward_ios,
                    //           size: height(context) * 0.02,
                    //           color: Color(0xffECB34F),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ChangedLanguage(
                            text: "Total Mapped Farms", //My Crops
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 15, vertical: 5),
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(30),
                        //   ),
                        //   child: const Center(
                        //     child: Icon(
                        //       Icons.arrow_forward,
                        //       color: Color(0xffECB34F),
                        //       size: 20,
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // noofFarms != 0
                  //     ? Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => FarmIdScreen()))
                  //     : QuickAlert.show(
                  //         context: context,
                  //         type: QuickAlertType.info,
                  //         text: 'Please add your farm first ',
                  //       );
                },
                child: Stack(
                  children: [
                    Container(
                      height: height(context) * 0.18,
                      //width: width(context) * 0.9,
                      //margin: const EdgeInsets.symmetric(horizontal: 20),
                      foregroundDecoration: BoxDecoration(
                        color: Colors.black26,
                        //borderRadius: BorderRadius.circular(10),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          // borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                              image:
                                  AssetImage('assets/illustrations/farms.jpg'),
                              fit: BoxFit.fill)),
                    ),
                    Positioned(
                      left: width(context) * 0.08,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: noofFarms,
                                style: TextStyle(
                                    fontSize: 65,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            TextSpan(
                              text: '  FARMS MAPPED',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3),
                child: GridView.builder(
                  // itemCount: horizontalScroll1.length,
                  // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 2,
                  //     crossAxisSpacing: 6.0,
                  //     mainAxisSpacing:6.0,
                  //     //mainAxisSpacing: 4.0,
                  //   childAspectRatio:2/1.8,
                  // ),
                  itemCount: horizontalScroll1.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () async {
                        index == 0
                            ? Navigator.pushNamed(context, '/${index}')
                            : noofFarms != '0'
                                ? Navigator.pushNamed(context, '/${index}')
                                : QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.info,
                                    title: await changeLanguage('Information'),
                                    text: await changeLanguage(
                                        'Please add your farm first...'),
                                  );
                      },
                      child: Container(
                        height: height(context) * 0.18,
                        width: width(context) * 0.45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 12,
                                spreadRadius: 0,
                                color: Colors.grey.shade200)
                          ],
                          border:
                              Border.all(color: Colors.grey.shade400, width: 1),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                height: height(context) * 0.12,
                                width: height(context) * 0.12,
                                decoration: BoxDecoration(
                                    //border: Border.all(color: Colors.grey.shade300,width: 0.5),
                                    borderRadius: BorderRadius.circular(
                                        height(context) * 0.07),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 12,
                                          spreadRadius: 0,
                                          color: Colors.grey.shade200)
                                    ]
                                    //color: Colors.black,//Color(color),

                                    /*image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                          horizontalScroll1[index].image,
                                        ))*/
                                    ),
                                /* child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Text(
                                            'My Farm Monitoring',
                                            // style: TextStyle(
                                            // color: Colors.black,
                                            // fontSize: 16,
                                            // fontWeight: FontWeight.w600)
                                          ),
                                        )),*/
                                child: Center(
                                    child: SvgPicture.asset(
                                        horizontalScroll1[index].image)),
                              ),
                              // SizedBox(height: 10),
                              FutureBuilder(
                                future: changeLanguage(
                                    horizontalScroll1[index].name),
                                builder: (context, i) => i.hasData
                                    ? Text(
                                        i.data,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: height(context)*0.016),textAlign: TextAlign.center,maxLines: 2,
                                      )
                                    : Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.white,
                                        child: Card(
                                          child: SizedBox(
                                            height: height(context) * 0.014,
                                            width: width(context) * 0.25,
                                          ),
                                        )),
                              )
                              /*ChangedLanguage(text:horizontalScroll1[index].name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                  )),*/
                            ]),
                      ),
                    );
                  },
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         Navigator.pushNamed(context, '/0');
              //       },
              //       child: Container(
              //         height: height(context) * 0.18,
              //         width: width(context) * 0.45,
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(10),
              //           border: Border.all(color: Colors.black38, width: 1),
              //         ),
              //         child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Container(
              //                 height: height(context) * 0.07,
              //                 width: width(context) * 0.170,
              //                 decoration: BoxDecoration(
              //                   //color: Colors.black,//Color(color),
              //
              //                     image: DecorationImage(
              //                         fit: BoxFit.fill,
              //                         image: AssetImage(
              //                           'assets/illustrations/disease_detection.png',
              //                         ))),
              //                 /* child: Align(
              //                         alignment: Alignment.bottomCenter,
              //                         child: Padding(
              //                           padding: const EdgeInsets.all(6.0),
              //                           child: Text(
              //                             'My Farm Monitoring',
              //                             // style: TextStyle(
              //                             // color: Colors.black,
              //                             // fontSize: 16,
              //                             // fontWeight: FontWeight.w600)
              //                           ),
              //                         )),*/
              //               ),
              //               SizedBox(height: 10),
              //               ChangedLanguage(text:"Disease Advisory",
              //                   style: TextStyle(
              //                     fontSize: 16,
              //                   )),
              //             ]),
              //       ),
              //     ),
              //     SizedBox(width: 10,),
              //     GestureDetector(
              //       onTap: () {
              //         noofFarms != 0
              //             ? Navigator.pushNamed(context, '/1')
              //             : QuickAlert.show(
              //           context: context,
              //           type: QuickAlertType.info,
              //           text: 'Please add your farm first ',
              //         );
              //       },
              //       child: Container(
              //         height: height(context) * 0.18,
              //         width: width(context) * 0.45,
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(10),
              //           border: Border.all(color: Colors.black38, width: 1),
              //         ),
              //         child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Container(
              //                 height: height(context) * 0.07,
              //                 width:width(context) * 0.170,
              //                 decoration: BoxDecoration(
              //                   //color: Colors.black,//Color(color),
              //
              //                     image: DecorationImage(
              //                         fit: BoxFit.fill,
              //                         image: AssetImage(
              //                           "assets/illustrations/farm.png",
              //                         ))),
              //                 /* child: Align(
              //                         alignment: Alignment.bottomCenter,
              //                         child: Padding(
              //                           padding: const EdgeInsets.all(6.0),
              //                           child: Text(
              //                             'My Farm Monitoring',
              //                             // style: TextStyle(
              //                             // color: Colors.black,
              //                             // fontSize: 16,
              //                             // fontWeight: FontWeight.w600)
              //                           ),
              //                         )),*/
              //               ),
              //               SizedBox(height: 10),
              //               ChangedLanguage(text:"Add Crop",
              //                   style: TextStyle(
              //                     fontSize: 16,
              //                   )),
              //             ]),
              //       ),
              //     )
              //   ],
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         noofFarms != 0
              //             ? Navigator.pushNamed(context, '/2')
              //             : QuickAlert.show(
              //           context: context,
              //           type: QuickAlertType.info,
              //           text: 'Please add your farm first ',
              //         );
              //       },
              //       child: Container(
              //         height: height(context) * 0.18,
              //         width: width(context) * 0.45,
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(10),
              //           border: Border.all(color: Colors.black38, width: 1),
              //         ),
              //         child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Container(
              //                 height: height(context) * 0.07,
              //                 width: width(context) * 0.17,
              //                 decoration: BoxDecoration(
              //                   //color: Colors.black,//Color(color),
              //
              //                     image: DecorationImage(
              //                         fit: BoxFit.fill,
              //                         image: AssetImage(
              //                           'assets/illustrations/scouting.png',
              //                         ))),
              //                 /* child: Align(
              //                         alignment: Alignment.bottomCenter,
              //                         child: Padding(
              //                           padding: const EdgeInsets.all(6.0),
              //                           child: Text(
              //                             'My Farm Monitoring',
              //                             // style: TextStyle(
              //                             // color: Colors.black,
              //                             // fontSize: 16,
              //                             // fontWeight: FontWeight.w600)
              //                           ),
              //                         )),*/
              //               ),
              //               SizedBox(height: 10),
              //               ChangedLanguage(text:"Scouting",
              //                   style: TextStyle(
              //                     fontSize: 16,
              //                   )),
              //             ]),
              //       ),
              //     ),
              //     SizedBox(width: 10,),
              //     GestureDetector(
              //       onTap: () {
              //         noofFarms != 0
              //             ? Navigator.pushNamed(context, '/3')
              //             : QuickAlert.show(
              //           context: context,
              //           type: QuickAlertType.info,
              //           text: 'Please add your farm first ',
              //         );
              //       },
              //       child: Container(
              //         height: height(context) * 0.18,
              //         width: width(context) * 0.45,
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(10),
              //           border: Border.all(color: Colors.black38, width: 1),
              //         ),
              //         child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Container(
              //                 height: height(context) * 0.07,
              //                 width:width(context) * 0.170,
              //                 decoration: BoxDecoration(
              //                   //color: Colors.black,//Color(color),
              //
              //                     image: DecorationImage(
              //                         fit: BoxFit.fill,
              //                         image: AssetImage(
              //                           "assets/illustrations/agriculture.png",
              //                         ))),
              //                 /* child: Align(
              //                         alignment: Alignment.bottomCenter,
              //                         child: Padding(
              //                           padding: const EdgeInsets.all(6.0),
              //                           child: Text(
              //                             'My Farm Monitoring',
              //                             // style: TextStyle(
              //                             // color: Colors.black,
              //                             // fontSize: 16,
              //                             // fontWeight: FontWeight.w600)
              //                           ),
              //                         )),*/
              //               ),
              //               SizedBox(height: 10),
              //               ChangedLanguage(text:"Farm Planner",
              //                   style: TextStyle(
              //                     fontSize: 16,
              //                   )),
              //             ]),
              //       ),
              //     )
              //   ],
              // ),
              SizedBox(
                height: 10,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: Row(
              //     children: [
              //       InkWell(
              //         onTap: () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => AddNewFarmsActivity()));
              //         },
              //         child: Container(
              //           width: width(context) * 0.44,
              //           height: height(context) * 0.056,
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(10),
              //             border: Border.all(color: Color(0xffECB34F), width: 1),
              //           ),
              //           padding: const EdgeInsets.symmetric(horizontal: 10),
              //           child: Row(
              //             children: [
              //               Image.asset(
              //                 "assets/new_icons/Add Farm.png",
              //                 height: 45,
              //                 width: 45,
              //               ),
              //               /*const Icon(
              //                 Icons.message,
              //                 color: Color(0xffECB34F),
              //               ),*/
              //               const SizedBox(
              //                 width: 10,
              //               ),
              //               const Text(
              //                 'Add Farm',
              //               ),
              //               Expanded(
              //                 child: Container(),
              //               ),
              //               Icon(
              //                 Icons.arrow_forward_ios,
              //                 size: height(context) * 0.02,
              //                 color: Color(0xffECB34F),
              //               )
              //             ],
              //           ),
              //         ),
              //       ),
              //       Expanded(child: SizedBox()),
              //       InkWell(
              //         onTap: () {
              //           noofFarms!=0?
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) =>  AddCropActivity())):
              //           QuickAlert.show(
              //             context: context,
              //             type: QuickAlertType.info,
              //             text: 'Please add your farm first ',
              //           );
              //           // showDialog(
              //           //     context: context,
              //           //     builder: (BuildContext context) {
              //           //       return AlertDialog(
              //           //         backgroundColor: Colors.red[100],
              //           //         title: Text("Farm Required"),
              //           //         content: Text("Please add your farm first"),
              //           //         actions: <Widget>[
              //           //           IconButton(
              //           //               icon: Icon(Icons.check),
              //           //               onPressed: () {
              //           //                 Navigator.of(context).pop();
              //           //               })
              //           //         ],
              //           //       );
              //           //     });
              //         },
              //         child: Container(
              //           width: width(context) * 0.44,
              //           height: height(context) * 0.056,
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(10),
              //             border: Border.all(color: Color(0xffECB34F), width: 1),
              //           ),
              //           padding: const EdgeInsets.symmetric(horizontal: 10),
              //           child: Row(
              //             children: [
              //               /*const Icon(
              //                 Icons.message,
              //                 color: Color(0xffECB34F),
              //               ),*/
              //               Image.asset(
              //                 "assets/new_icons/Add Crops.png",
              //                 height: 45,
              //                 width: 45,
              //               ),
              //               const SizedBox(
              //                 width: 10,
              //               ),
              //               const Text('Add Crop'),
              //               Expanded(
              //                 child: Container(),
              //               ),
              //               Icon(
              //                 Icons.arrow_forward_ios,
              //                 size: height(context) * 0.02,
              //                 color: Color(0xffECB34F),
              //               )
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // /*InkWell(
              //         onTap: () {
              //
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => MyWebView(uid: uid,api_key: api_key)));
              //          // launch('http://app.mapmycrop.com/mobile-dashboard.php?user_id=$uid');
              //         },
              //         child: Container(
              //           width: double.maxFinite,
              //           height: height(context) * 0.05,
              //           decoration: BoxDecoration(
              //               color: Colors.white,
              //               borderRadius: BorderRadius.circular(10),
              //               border: Border.all(color: Color(0xffECB34F), width: 1)),
              //           padding: const EdgeInsets.symmetric(horizontal: 15),
              //           child: Row(
              //             children: [
              //               const Icon(
              //                 Icons.message,
              //                 color: Color(0xffECB34F),
              //               ),
              //               const SizedBox(
              //                 width: 10,
              //               ),
              //               const Text('Farms'),
              //               Expanded(
              //                 child: Container(),
              //               ),
              //               Icon(
              //                 Icons.arrow_forward_ios,
              //                 size: height(context) * 0.02,
              //                 color: Color(0xffECB34F),
              //               )
              //             ],
              //           ),
              //         ),
              //       ),*/
              // const SizedBox(
              //   height: 12,
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: Row(
              //     children: [
              //       InkWell(
              //         onTap: () {
              //           noofFarms!=0?
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => const ScoutingActivity())):
              //           QuickAlert.show(
              //             context: context,
              //             type: QuickAlertType.info,
              //             text: 'Please add your farm first ',
              //           );
              //         },
              //         child: Container(
              //           width: width(context) * 0.44,
              //           height: height(context) * 0.056,
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(10),
              //             border: Border.all(color: Color(0xffECB34F), width: 1),
              //           ),
              //           padding: const EdgeInsets.symmetric(horizontal: 10),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             children: [
              //               Image.asset(
              //                 "assets/new_icons/Scouting.png",
              //                 height: 45,
              //                 width: 45,
              //               ),
              //               const SizedBox(
              //                 width: 10,
              //               ),
              //               const Text('Scouting'),
              //               Expanded(
              //                 child: Container(),
              //               ),
              //               Icon(
              //                 Icons.arrow_forward_ios,
              //                 size: height(context) * 0.02,
              //                 color: Color(0xffECB34F),
              //               )
              //             ],
              //           ),
              //         ),
              //       ),
              //       Expanded(child: SizedBox()),
              //       InkWell(
              //         onTap: () {
              //           noofFarms!=0?
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) =>  PlannerActivity())):QuickAlert.show(
              //             context: context,
              //             type: QuickAlertType.info,
              //             text: 'Please add your farm first ',
              //           );
              //           // showDialog(
              //           //     context: context,
              //           //     builder: (BuildContext context) {
              //           //       return AlertDialog(
              //           //         backgroundColor: Colors.red[100],
              //           //         title: Text("Farm Required"),
              //           //         content: Text("Please add your farm first"),
              //           //         actions: <Widget>[
              //           //           IconButton(
              //           //               icon: Icon(Icons.check),
              //           //               onPressed: () {
              //           //                 Navigator.of(context).pop();
              //           //               })
              //           //         ],
              //           //       );
              //           //     });
              //         },
              //         child: Container(
              //           width: width(context) * 0.44,
              //           height: height(context) * 0.056,
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(10),
              //             border: Border.all(color: Color(0xffECB34F), width: 1),
              //           ),
              //           padding: const EdgeInsets.symmetric(horizontal: 10),
              //           child: Row(
              //             children: [
              //               Image.asset(
              //                 "assets/new_icons/Farm Planner.png",
              //                 height: 45,
              //                 width: 45,
              //               ),
              //               const SizedBox(
              //                 width: 15,
              //               ),
              //               const Text(
              //                 'Planner',
              //                 textAlign: TextAlign.center,
              //               ),
              //               Expanded(
              //                 child: const Text(
              //                   '',
              //                 ),
              //               ),
              //               Icon(
              //                 Icons.arrow_forward_ios,
              //                 size: height(context) * 0.02,
              //                 color: Color(0xffECB34F),
              //               )
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height:5.0,
              // ),
              GestureDetector(
                onTap: () {
                  FirebaseAnalytics.instance.logEvent(
                    name: "market",
                    parameters: {
                      "content_type": "Activity_planned",
                      "api_key": api_key,
                    },
                  ).onError((error, stackTrace) =>
                      print('analytics error is $error'));
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> FarmIdScreen()));
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MandiPriceDta()));
                },
                child: /*Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      // margin: const EdgeInsets.symmetric(horizontal: 20,vertical:10),
                      height: height(context) * 0.18,
                      foregroundDecoration: BoxDecoration(
                        // color: Colors.black26,
                        borderRadius: BorderRadius.circular(5),
                      ),

                      //width: width(context) * 0.9,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xfff9e2ae),
                            Color(0xfff9e2ae),
                          ],

                          //borderRadius: BorderRadius.circular(5),
                        ),
                        //color: Colors.grey.shade200,
                        */ /*child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: height(context)*0.07,
                          width: width(context)*0.45,
                          //color: Colors.white,
                          padding: EdgeInsets.all(height(context) * 0.01),
                          decoration: BoxDecoration(
                              color: Colors.white24,
                              //borderRadius: BorderRadius.circular(10)
                          ),
                          child: Center(
                            child: Text(
                              'Markets',
                              style: TextStyle(
                                color: Colors.white,
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),*/ /*
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/illustrations/mandi.jpg',
                            height: height(context) * 0.175,
                            width: width(context) * 0.50,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            width: width(context) * 0.06,
                          ),
                          Expanded(
                            child: ChangedLanguage(
                              text: 'Mandi Rates',
                              // softWrap: true,
                              // maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )*/
                    Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      height: height(context) * 0.18,
                      width: width(context),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                offset: Offset(10, 10),
                                blurRadius: 12,
                                spreadRadius: 0)
                          ]
                          //borderRadius: BorderRadius.circular(10),
                          /*image: DecorationImage(
                            //opacity: 0.8,
                            //image: SvgPicture.asset('assets/illustrations/FertilizerRecommendation.jpg'),
                            fit: BoxFit.fill,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.82), BlendMode.dstATop),
                          )*/
                          ),
                      child: SvgPicture.asset(
                        'assets/svgImages/Market.svg',
                        fit: BoxFit.fill,
                        width: width(context),
                      ),
                      //color: Colors.grey.shade200,
                      /*child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                //color: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: height(context) * 0.02),
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Text(
                                  'Fertilizer Recommendation',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),*/
                    ),
                    Positioned(
                      top: height(context)*0.01,
                      right: width(context)*0.05,
                      child: Container(

                        height: height(context)*0.04,
                        width: width(context)*0.51,
                        child: Center(
                          child: languageText(
                            'Mandi',
                            TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff585858)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          FirebaseAnalytics.instance.logEvent(
                            name: "crop_guide",
                            parameters: {
                              "content_type": "Activity_planned",
                              "api_key": api_key,
                            },
                          ).onError((error, stackTrace) =>
                              print('analytics error is $error'));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CropGuideDashboard()));
                        },
                        child: Container(
                          height: height(context) * 0.18,
                          width: width(context) * 0.45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 12,
                                  spreadRadius: 0,
                                  color: Colors.grey.shade200)
                            ],
                            border: Border.all(color: Colors.grey.shade400, width: 1),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /* Container(
                                  height: height(context) * 0.12,
                                  width: width(context) * 0.20,
                                  decoration: BoxDecoration(
                                      //color: Colors.black,//Color(color),

                                      */ /*image: const DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                            'assets/illustrations/Crop_Guide.png',
                                          ))*/ /*),
                                  */ /* child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          'My Farm Monitoring',
                                          // style: TextStyle(
                                          // color: Colors.black,
                                          // fontSize: 16,
                                          // fontWeight: FontWeight.w600)
                                        ),
                                      )),*/ /*
                                  child: SvgPicture.asset('assets/svgImages/Crop_Guide.svg'),
                                )*/
                                Container(
                                  padding: EdgeInsets.all(2),
                                  height: height(context) * 0.12,
                                  width: height(context) * 0.12,
                                  decoration: BoxDecoration(
                                      //border: Border.all(color: Colors.grey.shade300,width: 0.5),
                                      borderRadius: BorderRadius.circular(
                                          height(context) * 0.07),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 12,
                                            spreadRadius: 0,
                                            color: Colors.grey.shade200)
                                      ]
                                      //color: Colors.black,//Color(color),

                                      /*image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                              horizontalScroll1[index].image,
                                            ))*/
                                      ),
                                  /* child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: const EdgeInsets.all(6.0),
                                              child: Text(
                                                'My Farm Monitoring',
                                                // style: TextStyle(
                                                // color: Colors.black,
                                                // fontSize: 16,
                                                // fontWeight: FontWeight.w600)
                                              ),
                                            )),*/
                                  child: Center(
                                      child: SvgPicture.asset(
                                          'assets/svgImages/Crop_Guide.svg')),
                                ),
                                FutureBuilder(
                                  future: changeLanguage('Crop Guide'),
                                  builder: (context, i) => i.hasData
                                      ? Text(
                                          i.data,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: height(context)*0.016),textAlign: TextAlign.center,maxLines: 2,
                                        )
                                      : Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.white,
                                          child: Card(
                                            child: SizedBox(
                                              height: height(context) * 0.014,
                                              width: width(context) * 0.25,
                                            ),
                                          )),
                                )
                                /*ChangedLanguage(text:'Crop Guide',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                    )),*/
                              ]),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          FirebaseAnalytics.instance.logEvent(
                            name: "community",
                            parameters: {
                              "content_type": "Activity_planned",
                              "api_key": api_key,
                            },
                          ).onError((error, stackTrace) =>
                              print('analytics error is $error'));
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.loading,
                              text: await changeLanguage("Coming Soon..."));

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const CommunityWebview()));
                        },
                        child: Container(
                          height: height(context) * 0.18,
                          width: width(context) * 0.45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade400, width: 1),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 12,
                                  spreadRadius: 0,
                                  color: Colors.grey.shade200)
                            ],
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /*Container(
                                  height: height(context) * 0.12,
                                  width: width(context) * 0.20,
                                  decoration: BoxDecoration(
                                      //color: Colors.black,//Color(color),

                                      */ /*image: const DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                            'assets/illustrations/contactus.png',
                                          ))*/ /*),
                                  */ /* child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          'My Farm Monitoring',
                                          // style: TextStyle(
                                          // color: Colors.black,
                                          // fontSize: 16,
                                          // fontWeight: FontWeight.w600)
                                        ),
                                      )),*/ /*
                                  child: SvgPicture.asset('assets/svgImages/Community.svg'),
                                ),*/
                                Container(
                                  padding: EdgeInsets.all(2),
                                  height: height(context) * 0.12,
                                  width: height(context) * 0.12,
                                  decoration: BoxDecoration(
                                      //border: Border.all(color: Colors.grey.shade300,width: 0.5),
                                      borderRadius: BorderRadius.circular(
                                          height(context) * 0.07),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 12,
                                            spreadRadius: 0,
                                            color: Colors.grey.shade200)
                                      ]
                                      //color: Colors.black,//Color(color),

                                      /*image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                              horizontalScroll1[index].image,
                                            ))*/
                                      ),
                                  /* child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: const EdgeInsets.all(6.0),
                                              child: Text(
                                                'My Farm Monitoring',
                                                // style: TextStyle(
                                                // color: Colors.black,
                                                // fontSize: 16,
                                                // fontWeight: FontWeight.w600)
                                              ),
                                            )),*/
                                  child: Center(
                                      child: SvgPicture.asset(
                                          'assets/svgImages/Community.svg')),
                                ),
                                // SizedBox(height: 10),
                                FutureBuilder(
                                  future: changeLanguage('Community'),
                                  builder: (context, i) => i.hasData
                                      ? Text(
                                          i.data,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: height(context)*0.016),textAlign: TextAlign.center,maxLines: 2,
                                        )
                                      : Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.white,
                                          child: Card(
                                            child: SizedBox(
                                              height: height(context) * 0.014,
                                              width: width(context) * 0.25,
                                            ),
                                          )
                                    ),
                                ),
                                /*ChangedLanguage(text:'Community',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                    )),*/
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              // SizedBox(
              //   width: width(context) * 0.9,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Text("Crop Guide",
              //           style:
              //               TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              //       InkWell(
              //         onTap: () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => CropGuideDashboard()));
              //         },
              //         child: Container(
              //           margin: const EdgeInsets.symmetric(vertical: 10),
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 15, vertical: 5),
              //           decoration: BoxDecoration(
              //               color: Colors.white,
              //               borderRadius: BorderRadius.circular(15)),
              //           child: Row(
              //             children: const [
              //               Text('More'),
              //               SizedBox(
              //                 width: 5,
              //               ),
              //               Icon(
              //                 Icons.arrow_forward_ios,
              //                 color: Color(0xffECB34F),
              //                 size: 15,
              //               )
              //             ],
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              GestureDetector(
                onTap: () async {
                  FirebaseAnalytics.instance.logEvent(
                    name: "disease_detection",
                    parameters: {
                      "content_type": "Activity_planned",
                      "api_key": api_key,
                    },
                  ).onError((error, stackTrace) =>
                      print('analytics error is $error'));
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.loading,
                      text: await changeLanguage("Coming Soon..."));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => DiseaseDetectionActivity()));
                },
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      height: height(context) * 0.18,
                      width: width(context) - 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                offset: Offset(10, 10),
                                blurRadius: 12,
                                spreadRadius: 0)
                          ]
                          //borderRadius: BorderRadius.circular(10),
                          /*image: DecorationImage(
                            //opacity: 0.8,
                            //image: SvgPicture.asset('assets/illustrations/FertilizerRecommendation.jpg'),
                            fit: BoxFit.fill,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.82), BlendMode.dstATop),
                          )*/
                          ),
                      child: Center(
                          child: SvgPicture.asset(
                              'assets/svgImages/Disease.svg',
                              fit: BoxFit.fill)),
                      //color: Colors.grey.shade200,
                      /*child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                //color: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: height(context) * 0.02),
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Text(
                                  'Fertilizer Recommendation',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),*/
                    ),
                    Positioned(
                      top: height(context)*0.02,
                      right: width(context)*0.05,
                      child: SizedBox(

                        height: height(context)*0.04,
                        width: width(context)*0.51,
                        child: Center(
                          child: languageText(
                            'Disease Detection',
                            TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff585858)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ) /*Container(
                 // padding: EdgeInsets.only(bottom: 5),
                  color: Color(0xfffbdb5b),
                  height: height(context) * 0.16,
                  width: width(context),
                  child: */ /*FittedBox(
                    fit: BoxFit.fill,
                    child: ClipRect(
                      child: Container(
                        child: Align(
                          alignment: Alignment(-0.1, -0.5),
                          widthFactor: 1.1,
                          heightFactor: 0.7,
                          child: SvgPicture.asset('assets/svgImages/Disease_Detection.svg'),
                        ),
                      ),
                    ),
                  ) SvgPicture.asset('assets/svgImages/Disease_Detection.svg'),
                )*/
                ,

                // Container(
                //   height: height(context) * 0.2,
                //   width: width(context),
                //
                //   //padding: EdgeInsets.only(top:10),
                //   //margin: const EdgeInsets.symmetric(horizontal: 20),
                //   /*foregroundDecoration: BoxDecoration(
                //       // color: Colors.black26
                //       ),*/
                //   decoration: BoxDecoration(
                //       color: Color(0xfffbdb5b),
                //       // borderRadius: BorderRadius.circular(10),
                //      /* image: DecorationImage(
                //           //opacity: 0.7,
                //           image: AssetImage(
                //               'assets/illustrations/5.png'), //AssetImage('assets/images/soilTemp.jpg'),
                //           fit: BoxFit.fill)*/),
                //   child:Center(child: ClipRect(child: Image.asset('assets/illustrations/6.png',width:width(context)*0.93,height:height(context)*0.2,fit:BoxFit.fill)))
                //   /*child: Column(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       Container(
                //         //color: Colors.white,
                //         padding: EdgeInsets.symmetric(Y
                //             horizontal: height(context) * 0.02),
                //         decoration: BoxDecoration(
                //             color: Colors.white24,
                //             borderRadius: BorderRadius.circular(4)),
                //         child: Text(
                //           'Coming soon....',
                //           style: TextStyle(
                //             color: Colors.white,
                //               fontSize: 15, fontWeight: FontWeight.bold),
                //         ),
                //       ),
                //       SizedBox(
                //         height: 23,
                //       ),
                //     ],
                //   ),*/
                // ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          FirebaseAnalytics.instance.logEvent(
                            name: "sell_produce",
                            parameters: {
                              "content_type": "Activity_planned",
                              "api_key": api_key,
                            },
                          ).onError((error, stackTrace) =>
                              print('analytics error is $error'));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelfProduce(phone: phone,email: email)));
                        },
                        child: Container(
                          height: height(context) * 0.18,
                          width: width(context) * 0.45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade400, width: 1),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 12,
                                  spreadRadius: 0,
                                  color: Colors.grey.shade200)
                            ],
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /*Container(
                                  height: height(context) * 0.12,
                                  width: width(context) * 0.20,
                                  decoration: BoxDecoration(
                                      //color: Colors.black,//Color(color),

                                      */ /*image: const DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                            'assets/illustrations/solar-energy.png',
                                          ))*/ /*),
                                  */ /* child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          'My Farm Monitoring',
                                          // style: TextStyle(
                                          // color: Colors.black,
                                          // fontSize: 16,
                                          // fontWeight: FontWeight.w600)
                                        ),
                                      )),*/ /*
                                  child: SvgPicture.asset('assets/svgImages/Sell_Produce.svg'),
                                ),*/
                                Container(
                                  padding: EdgeInsets.all(2),
                                  height: height(context) * 0.12,
                                  width: height(context) * 0.12,
                                  decoration: BoxDecoration(
                                      //border: Border.all(color: Colors.grey.shade300,width: 0.5),
                                      borderRadius: BorderRadius.circular(
                                          height(context) * 0.07),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 12,
                                            spreadRadius: 0,
                                            color: Colors.grey.shade200)
                                      ]
                                      //color: Colors.black,//Color(color),

                                      /*image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                              horizontalScroll1[index].image,
                                            ))*/
                                      ),
                                  /* child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: const EdgeInsets.all(6.0),
                                              child: Text(
                                                'My Farm Monitoring',
                                                // style: TextStyle(
                                                // color: Colors.black,
                                                // fontSize: 16,
                                                // fontWeight: FontWeight.w600)
                                              ),
                                            )),*/
                                  child: Center(
                                      child: SvgPicture.asset(
                                          'assets/svgImages/Sell_Produce.svg')),
                                ),
                                // SizedBox(height: 10),
                                FutureBuilder(
                                  future: changeLanguage('Sell Produce'),
                                  builder: (context, i) => i.hasData
                                      ? Text(
                                          i.data,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: height(context)*0.016),textAlign: TextAlign.center,maxLines: 2,
                                        )
                                      : Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.white,
                                          child: Card(
                                            child: SizedBox(
                                              height: height(context) * 0.014,
                                              width: width(context) * 0.25,
                                            ),
                                          )),
                                )
                                /*ChangedLanguage(text:'Sell Produce',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                    )),*/
                              ]),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          FirebaseAnalytics.instance.logEvent(
                            name: "expert_call",
                            parameters: {
                              "content_type": "Activity_planned",
                              "api_key": api_key,
                            },
                          ).onError((error, stackTrace) =>
                              print('analytics error is $error'));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ExpertCall()));
                        },
                        child: Container(
                          height: height(context) * 0.18,
                          width: width(context) * 0.45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade400, width: 1),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 12,
                                  spreadRadius: 0,
                                  color: Colors.grey.shade200)
                            ],
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /*Container(
                                  height: height(context) * 0.12,
                                  width: width(context) * 0.2,
                                  decoration: BoxDecoration(
                                      //color: Colors.black,//Color(color),

                                      */ /*image: const DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                            'assets/illustrations/carrot.png',
                                          ))*/ /*),
                                  */ /* child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          'My Farm Monitoring',
                                          // style: TextStyle(
                                          // color: Colors.black,
                                          // fontSize: 16,
                                          // fontWeight: FontWeight.w600)
                                        ),
                                      )),*/ /*
                                  child: SvgPicture.asset('assets/svgImages/Schedule_Call.svg'),
                                ),*/
                                Container(
                                  padding: EdgeInsets.all(2),
                                  height: height(context) * 0.12,
                                  width: height(context) * 0.12,
                                  decoration: BoxDecoration(
                                      //border: Border.all(color: Colors.grey.shade300,width: 0.5),
                                      borderRadius: BorderRadius.circular(
                                          height(context) * 0.07),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 12,
                                            spreadRadius: 0,
                                            color: Colors.grey.shade200)
                                      ]
                                      //color: Colors.black,//Color(color),

                                      /*image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                              horizontalScroll1[index].image,
                                            ))*/
                                      ),
                                  /* child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: const EdgeInsets.all(6.0),
                                              child: Text(
                                                'My Farm Monitoring',
                                                // style: TextStyle(
                                                // color: Colors.black,
                                                // fontSize: 16,
                                                // fontWeight: FontWeight.w600)
                                              ),
                                            )),*/
                                  child: Center(
                                      child: SvgPicture.asset(
                                          'assets/svgImages/Schedule_Call.svg')),
                                ),
                                // SizedBox(height: 10),
                                FutureBuilder(
                                  future: changeLanguage('Schedule Call'),
                                  builder: (context, i) => i.hasData
                                      ? Text(
                                          i.data,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: height(context)*0.016),textAlign: TextAlign.center,maxLines: 2,
                                        )
                                      : Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.white,
                                          child: Card(
                                            child: SizedBox(
                                              height: height(context) * 0.014,
                                              width: width(context) * 0.25,
                                            ),
                                          )),
                                )
                                /*ChangedLanguage(text:'Schedule Call',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                    )),*/
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(
              //   height: 5.0,
              // ),
              // SizedBox(
              //   width: width(context) * 0.9,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Text("Community",
              //           style:
              //               TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              //       InkWell(
              //         onTap: () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => const CommunityWebview()));
              //         },
              //         child: Container(
              //           margin: const EdgeInsets.symmetric(vertical: 10),
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 15, vertical: 5),
              //           decoration: BoxDecoration(
              //               color: Colors.white,
              //               borderRadius: BorderRadius.circular(15)),
              //           child: Row(
              //             children: const [
              //               Text('See all'),
              //               SizedBox(
              //                 width: 5,
              //               ),
              //               Icon(
              //                 Icons.arrow_forward_ios,
              //                 color: Color(0xffECB34F),
              //                 size: 15,
              //               )
              //             ],
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              GestureDetector(
                onTap: () {
                  FirebaseAnalytics.instance.logEvent(
                    name: "fertilizer_calculator",
                    parameters: {
                      "content_type": "Activity_planned",
                      "api_key": api_key,
                    },
                  ).onError((error, stackTrace) =>
                      print('analytics error is $error'));
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> FarmIdScreen()));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const FertilizerCalculaterActivity()));
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      height: height(context) * 0.18,
                      width: width(context),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                offset: Offset(10, 10),
                                blurRadius: 12,
                                spreadRadius: 0)
                          ]
                          //borderRadius: BorderRadius.circular(10),
                          /*image: DecorationImage(
                        //opacity: 0.8,
                        //image: SvgPicture.asset('assets/illustrations/FertilizerRecommendation.jpg'),
                        fit: BoxFit.fill,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.82), BlendMode.dstATop),
                      )*/
                          ),
                      child: SvgPicture.asset(
                        'assets/svgImages/Fertilizer.svg',
                        fit: BoxFit.fill,
                        width: width(context),
                      ),

                      //color: Colors.grey.shade200,
                      /*child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            //color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: height(context) * 0.02),
                            decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(
                              'Fertilizer Recommendation',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),*/
                    ),
                    Positioned(
                      top: height(context)*0.01,
                      right: width(context)*0.05,
                      child: Container(

                        height: height(context)*0.04,
                        width: width(context)*0.51,
                        child: Center(
                          child: languageText(
                            'Fertilizer Recommendation',
                             TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff585858)),

                          ),
                        ),
                      ),
                    ),
                    /*Positioned(
                      bottom: 10,
                      child: Container(
                        width: width(context),
                        //color: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: height(context) * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // borderRadius: BorderRadius.only(bottomLeft:Radius.circular(10),bottomRight:Radius.circular(10))
                        ),
                        child: Center(
                          child: ChangedLanguage(
                            text: 'Fertilizer Recommendation',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),*/
                  ],
                ),
              ),

              SizedBox(height: 10),

              /*GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const FertilizerCalculaterActivity()));
          },
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.shade500,
                //     blurRadius: 5,
                //     spreadRadius: 0,
                //   ),
                // ]
            ),
            width: width(context) * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fertilizer Recommendation',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: const [
                //     Text(
                //       '11 Nov 2022',
                //       style: TextStyle(fontSize: 10, color: Colors.grey),
                //     )
                //   ],
                // ),
                Container(
                  width: width(context) * 0.9,
                  height: height(context) * 0.2,
                  // color: Colors.grey.shade400,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/Banners/Fertilizers Recommodations.png'),
                          fit: BoxFit.fill)),
                )
              ],
            ),
          ),
            )*/
            ],
          ),
          FutureBuilder(
              future: internetConnection(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? snapshot.data == true
                        ? Container()
                        : Container(
                            height: 20,
                            width: width(context),
                            color: Colors.red,
                            child: Center(
                                child: Text(
                              'You are offline make sure you\'re connected',
                              style: TextStyle(color: Colors.white),
                            )),
                          )
                    : Container();
              }),
        ],
      ),
      /* bottomNavigationBar: CurvedNavigationBar(
       // key: _bottomNavigationKey,
        index: 1,
        height: 60,
        buttonBackgroundColor: Colors.orange,
        backgroundColor: Colors.transparent,
        //color: Colors.white,
        color: Colors.white,
        animationCurve: Curves.linearToEaseOut,
        items: <Widget>[
          Icon(
            Icons.call,
            size: 20,
            color: Colors.black,
          ),
          Image.asset('assets/images/mapmycrop_logo1.png',height: 40,width:40, fit:BoxFit.fill),
          Icon(
            Icons.message_rounded,
            size: 20,
            color: Colors.black,
          ),
        ],
        onTap: (index) {
          setState(() {
            //selectedpage = index;  // changing selected page as per bar index selected by the user
          });
        },
      ),*/
      //bottomNavigationBar: ,
      bottomNavigationBar: CircleNavBar(
        activeIcons: [
          Container(
            height: 70,
            width: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 2, color: Colors.orange),
              image: DecorationImage(
                  image: AssetImage(
                      'assets/new_images/logo.png')), //CachedNetworkImageProvider('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTD8u1Nmrk78DSX0v2i_wTgS6tW5yvHSD7o6g&usqp=CAU')),
            ),
          ),
          Container(
            height: 70,
            width: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 2, color: Colors.orange),
              image: DecorationImage(
                  image: AssetImage(
                      'assets/new_images/logo.png')), //CachedNetworkImageProvider('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTD8u1Nmrk78DSX0v2i_wTgS6tW5yvHSD7o6g&usqp=CAU')),
            ),
          ).onTap(() {
            // showNotification();
            // Navigator.push((context), MaterialPageRoute(builder: (context)=>Mmc_HomePage(farmList: farmnames,)));
            // Navigator.push((context),
            //     MaterialPageRoute(builder: (context) => VideoList()));
            //Navigator.push((context), MaterialPageRoute(builder: (context)=>MandiPriceDta1()));
            // few clouds Navigator.push((context), MaterialPageRoute(builder: (context)=>Mmc_HomePage(farmList: farmnames,)));
            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (_) => autoCompletePlaces()));
          }),
          Container(
            height: 70,
            width: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 2, color: Colors.orange),
              image: DecorationImage(
                  image: AssetImage(
                      'assets/new_images/logo.png')), //CachedNetworkImageProvider('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTD8u1Nmrk78DSX0v2i_wTgS6tW5yvHSD7o6g&usqp=CAU')),
            ),
          ),
        ],
        inactiveIcons: [
          Icon(Icons.call, color: Colors.orange).onTap(() async {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ExpertCall()));
          }),
          Text("Home"),
          Icon(Icons.chat, color: Colors.orange).onTap(() async {
            await launch('https://wa.me/917066006625');
          }),
        ],
        color: Colors.white,
        circleColor: Colors.white,
        height: 60,
        circleWidth: 60,
        activeIndex: 1,
        // onChanged: (v) {
        //   // TODO
        // },
        // tabCurve: ,
        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          // bottomRight: Radius.circular(24),
          // bottomLeft: Radius.circular(24),
        ),
        shadowColor: Colors.deepPurple,
        circleShadowColor: Colors.deepPurple,
        elevation: 1,
        // gradient: LinearGradient(
        //   begin: Alignment.topRight,
        //   end: Alignment.bottomLeft,
        //   colors: [ Colors.blue, Colors.red ],
        // ),
        // circleGradient: LinearGradient(
        //   begin: Alignment.topRight,
        //   end: Alignment.bottomLeft,
        //   colors: [ Colors.blue, Colors.red ],
        // ),
      ),
      drawer: ClipPath(
        //clipper: OvalRightBorderClipper(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Drawer(
          child: Container(
            padding: const EdgeInsets.only(left: 16.0, right: 30),
            decoration: BoxDecoration(
                //color: Color(0xffECB34F),
                ),
            width: 300,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    /*Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.all(8),
                      child: IconButton(
                        icon: Icon(
                          Icons.power_settings_new,
                          color: Color(0xFF212121),
                        ),
                        onPressed: () async {
                          //scaffoldKey.currentState!.openEndDrawer();
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              title:await changeLanguage('Are You Sure?'),
                              text:await changeLanguage('Do you want to logout'),
                              confirmBtnText: await changeLanguage('Yes'),
                              cancelBtnText: await changeLanguage('No'),
                              confirmBtnColor: Colors.green,
                              //customAsset: 'assets/new_images/logo.png',
                              onCancelBtnTap: () {
                                Navigator.pop(context);
                              },
                              onConfirmBtnTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('_isLoggedIn', false);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const LoginPageActivity()));
                              });
                        },
                      ),
                    ),*/
                    SizedBox(height: 50),
                    Container(
                      height: 70,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: Colors.orange),
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/new_images/logo.png')), //CachedNetworkImageProvider('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTD8u1Nmrk78DSX0v2i_wTgS6tW5yvHSD7o6g&usqp=CAU')),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    // Text(
                    //   "John Dow",
                    //   style: TextStyle(color: Color(0xFF212121), fontSize: 18.0, fontWeight: FontWeight.w600),
                    // ),
                    Text(
                        //phone != null ?? phone ? email : ''
                        phone ?? email ?? '',
                        style: TextStyle(
                            color: Color(0xFF212121), fontSize: height(context)*0.016),textAlign: TextAlign.center,maxLines: 2,),
                    30.height,
                    // itemList(Icon(Icons.home), "Home"),
                    // Divider(),
                    // 15.height,
                    // itemList(Icon(Icons.person_pin,), "My profile"),
                    // Divider(),
                    // 15.height,
                    Row(
                      children: [
                        Icon(Icons.notifications_none_rounded),
                        10.width,
                        FutureBuilder(
                          future: changeLanguage('Notifications'),
                          builder: (context, i) => i.hasData
                              ? Text(
                                  i.data,
                                  style: TextStyle(color: Color(0xFF212121)),
                                )
                              : Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.white,
                                  child: Card(
                                    child: SizedBox(
                                      height: height(context) * 0.014,
                                      width: width(context) * 0.25,
                                    ),
                                  )),
                        )
                        /*ChangedLanguage(text:"Messages",
                            style: TextStyle(color: Color(0xFF212121))),*/
                      ],
                    ).onTap(() async {
                      //trans('Messages','en');
                      //print("whatsapp");
                      await launch('https://wa.me/917066006625');
                    }),
                    Divider(),
                    10.height,
                    // itemList(Icon(Icons.notifications,), "Notifications"),
                    // Divider(),
                    // 10.height,
                    // Row(
                    //   children: [
                    //     Icon(Icons.pest_control),
                    //     10.width,
                    //     Text("Fertilizers", style: TextStyle(color:  Color(0xFF212121))),
                    //   ],
                    // ).onTap(() {
                    //   //scaffoldKey.currentState!.openEndDrawer();
                    //   //toasty(context, title);
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) =>
                    //               FertilizerCalculaterActivity()));
                    // }),
                    // Divider(),
                    // 10.height,
                    Row(
                      children: [
                        Icon(Icons.sunny),
                        10.width,
                        FutureBuilder(
                          future: changeLanguage('Weather'),
                          builder: (context, i) => i.hasData
                              ? Text(
                                  i.data,
                                  style: TextStyle(color: Color(0xFF212121)),
                                )
                              : Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.white,
                                  child: Card(
                                    child: SizedBox(
                                      height: height(context) * 0.014,
                                      width: width(context) * 0.25,
                                    ),
                                  )),
                        )

                        /* ChangedLanguage(text:"Weather",
                            style: TextStyle(color: Color(0xFF212121))),*/
                      ],
                    ).onTap(() {
                      //scaffoldKey.currentState!.openEndDrawer();
                      //toasty(context, title);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => WeatherWebView()));
                    }),
                    Divider(),
                    10.height,
                    /*Row(
                      children: [
                        Icon(Icons.chat_outlined),
                        10.width,
                        Text("Community",
                            style: TextStyle(color: Color(0xFF212121))),
                      ],
                    ).onTap(() {
                      //scaffoldKey.currentState!.openEndDrawer();
                      //toasty(context, title);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const CommunityWebview()));
                    }),
                    Divider(),
                    10.height,*/
                    Row(
                      children: [
                        Icon(Icons.bookmark_border_outlined),
                        10.width,
                        FutureBuilder(
                          future: changeLanguage('Knowledge Base'),
                          builder: (context, i) => i.hasData
                              ? Text(
                                  i.data,
                                  style: TextStyle(color: Color(0xFF212121)),
                                )
                              : Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.white,
                                  child: Card(
                                    child: SizedBox(
                                      height: height(context) * 0.014,
                                      width: width(context) * 0.25,
                                    ),
                                  )),
                        )

                        /*ChangedLanguage(text:"Knowledge Base",
                            style: TextStyle(color: Color(0xFF212121))),*/
                      ],
                    ).onTap(() {
                      //scaffoldKey.currentState!.openEndDrawer();
                      //toasty(context, title);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const CustomerSupport()));
                    }),
                    Divider(),
                    10.height,
                    Row(
                      children: [
                        Icon(Icons.handshake_outlined),
                        10.width,
                        FutureBuilder(
                          future: changeLanguage('Contact Us'),
                          builder: (context, i) => i.hasData
                              ? Text(
                                  i.data,
                                  style: TextStyle(color: Color(0xFF212121)),
                                )
                              : Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.white,
                                  child: Card(
                                    child: SizedBox(
                                      height: height(context) * 0.014,
                                      width: width(context) * 0.25,
                                    ),
                                  )),
                        )

                        /*ChangedLanguage(text:"Contact us",
                            style: TextStyle(color: Color(0xFF212121))),*/
                      ],
                    ).onTap(() {
                      //scaffoldKey.currentState!.openEndDrawer();
                      //toasty(context, title);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ContactUsActivity()));
                    }),
                    Divider(),
                    10.height,
                    //itemList(Icon(Icons.info_outline), "Help"),
                    // Divider(),
                    // 15.height,
                    Row(
                      children: [
                        Icon(Icons.feedback_outlined),
                        10.width,
                        FutureBuilder(
                          future: changeLanguage('Feedback'),
                          builder: (context, i) => i.hasData
                              ? Text(
                                  i.data,
                                  style: TextStyle(color: Color(0xFF212121)),
                                )
                              : Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.white,
                                  child: Card(
                                    child: SizedBox(
                                      height: height(context) * 0.014,
                                      width: width(context) * 0.25,
                                    ),
                                  )),
                        )

                        /*ChangedLanguage(text:"Feedback",
                            style: TextStyle(color: Color(0xFF212121))),*/
                      ],
                    ).onTap(() {
                      //scaffoldKey.currentState!.openEndDrawer();
                      //toasty(context, title);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FeedbackActivity()));
                    }),
                    Divider(),
                    10.height,
                    Row(
                      children: [
                        Icon(Icons.share),
                        10.width,
                        FutureBuilder(
                          future: changeLanguage('Share App'),
                          builder: (context, i) => i.hasData
                              ? Text(
                                  i.data,
                                  style: TextStyle(color: Color(0xFF212121)),
                                )
                              : Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.white,
                                  child: Card(
                                    child: SizedBox(
                                      height: height(context) * 0.014,
                                      width: width(context) * 0.25,
                                    ),
                                  )),
                        )
                        /*ChangedLanguage(text:"Share app",
                            style: TextStyle(color: Color(0xFF212121))),*/
                      ],
                    ).onTap(() {
                      //scaffoldKey.currentState!.openEndDrawer();
                      //toasty(context, title);
                      share();
                    }, hoverColor: Colors.green),
                    Divider(),
                    10.height,
                    Row(
                      children: [
                        Icon(
                          Icons.star_half_sharp,
                        ),
                        10.width,
                        FutureBuilder(
                          future: changeLanguage('Rate us'),
                          builder: (context, i) => i.hasData
                              ? Text(
                                  i.data,
                                  style: TextStyle(color: Color(0xFF212121)),
                                )
                              : Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.white,
                                  child: Card(
                                    child: SizedBox(
                                      height: height(context) * 0.014,
                                      width: width(context) * 0.25,
                                    ),
                                  )),
                        )
                        /* ChangedLanguage(text:"Rate us",
                            style: TextStyle(color: Color(0xFF212121))),*/
                      ],
                    ).onTap(() {
                      //scaffoldKey.currentState!.openEndDrawer();
                      //toasty(context, title);
                      final InAppReview inAppReview = InAppReview.instance;
                      inAppReview.requestReview();
                    }),
                    Divider(),
                    10.height,
                    // Row(
                    //   children: [
                    //     Icon(Icons.language),
                    //     10.width,
                    //     ChangedLanguage(text:"Language",
                    //         style: TextStyle(color: Color(0xFF212121))),
                    //   ],
                    // ).onTap(() {
                    //   _showlangDialog();
                    // }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.language),
                        10.width,
                        FutureBuilder(
                          future: changeLanguage('Language'),
                          builder: (context, i) => i.hasData
                              ? Text(
                                  i.data,
                                  style: TextStyle(color: Color(0xFF212121)),
                                )
                              : Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.white,
                                  child: Card(
                                    child: SizedBox(
                                      height: height(context) * 0.014,
                                      width: width(context) * 0.15,
                                    ),
                                  )),
                        ),
                        /*ChangedLanguage(text:'Language',
                            style: TextStyle(color: Color(0xFF212121))),*/
                        20.width,
                        SizedBox(
                          height: 25,
                          child:
                              //    DropdownButtonHideUnderline(
                              //     child: DropdownButton<String>(
                              //       //focusNode: emailIDFocusNode,
                              //       hint: Padding(
                              //         padding: const EdgeInsets.only(left: 8.0),
                              //         child: ChangedLanguage(text:'Select'),
                              //       ),
                              //       value: selectedLanguage,
                              //       elevation: 25,
                              //       isExpanded: true,
                              //       icon: Icon(Icons.arrow_drop_down_circle),
                              //       items: Languages.map((String value) {
                              //         return DropdownMenuItem<String>(
                              //           value: value,
                              //           child: Center(
                              //               child: ChangedLanguage(text:
                              //               value,
                              //                 style: TextStyle(fontWeight: FontWeight.w500),
                              //               )),
                              //         );
                              //       }).toList(),
                              //       onChanged: (String newvalue) async {
                              //         SharedPreferences prefs = await SharedPreferences.getInstance();
                              //         setState(() {
                              //           selectedLanguage=newvalue;
                              //           var index = Languages.indexOf(newvalue);
                              //           prefs.setString('language', LanguageCodes[index]);
                              //           //Navigator.pop(context);
                              //         });
                              //         Navigator.pushReplacement(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (BuildContext context) => super.widget));
                              //       },
                              //     ),
                              //   )
                              DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              // minWidth: 40,
                              // height: 25,
                              //alignedDropdown: true,
                              child: DropdownButton(
                                ///dropdown.dart change line no 518 set selectedItemOffset = -40
                                dropdownColor: Colors.grey.shade100,
                                menuMaxHeight: height(context) * 0.2,
                                borderRadius: BorderRadius.circular(15),
                                //underline: Divider(),
                                hint: Text(currentLanguage,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF212121))),
                                //value: currentLanguage,
                                items: Languages.map((String value) {
                                  return DropdownMenuItem<String>(
                                      alignment: AlignmentDirectional.center,
                                      value: value,
                                      child: Text(
                                        value,
                                      ));
                                }).toList(),
                                onChanged: (value) async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  setState(() {
                                    var index = Languages.indexOf(value);
                                    prefs.setString(
                                        'language', LanguageCodes[index]);
                                    currentLanguage = value;
                               //     getGlobalCropList(prefs.getString('api_key'));
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                super.widget));

                                    //print(selectedLanguage);
                                    //Navigator.pop(context);
                                  });
                                },
                                //style: Theme.of(context).textTheme.title,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // Container(
      //   //color: Color(0xffECB34F), //Colors.grey.shade200,
      //   //width: width(context)*0.50,
      //   child: Drawer(
      //       child: Container(
      //         //color: Color(0xffECB34F),
      //         padding: EdgeInsets.only(
      //             top: height(context) * 0.10,
      //             //bottom: height(context)*0.1,
      //             left: width(context) * 0.02,
      //             right: width(context) * 0.1),
      //         child: Column(
      //           children: [
      //             Padding(
      //               padding: const EdgeInsets.only(left: 20),
      //               child: Row(
      //                 children: [
      //                   InkWell(
      //                     onTap: () {
      //                       Navigator.pop(context);
      //                     },
      //                     child: Image.asset(
      //                       'assets/new_images/back.png',
      //                       height: screenHeight * 0.04,
      //                     ),
      //                   ),
      //                   const SizedBox(
      //                     width: 20,
      //                   ),
      //                   Image.asset(
      //                     'assets/new_images/logo.png',
      //                   )
      //                 ],
      //               ),
      //             ),
      //             const Padding(
      //               padding: EdgeInsets.only(left: 10),
      //               child: Divider(
      //                 height: 30,
      //                 thickness: 1.5,
      //                 color: Colors.black,
      //               ),
      //             ),
      //             SizedBox(
      //               height: height(context) * 0.58,
      //               child: Column(
      //                 children: [
      //                   SizedBox(
      //                     height: screenHeight * 0.05,
      //                     child: ListTile(
      //                       //tileColor: Colors.white,
      //                       leading: const Icon(
      //                         Icons.notifications_none_rounded,
      //                         color: Colors.black,
      //                       ),
      //                       title: const Text(
      //                         'Notifications',
      //                         style: TextStyle(color: Colors.black),
      //                       ),
      //                       onTap: () {
      //                         // Navigator.push(
      //                         //     context,
      //                         //     MaterialPageRoute(
      //                         //         builder: (context) => LocalNotificationScreen()));
      //                       },
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: screenHeight * 0.05,
      //                     child: ListTile(
      //                       //tileColor: Colors.white,
      //                       leading: const Icon(
      //                         Icons.message,
      //                         color: Colors.black,
      //                       ),
      //                       title: const Text(
      //                         'Messages',
      //                         style: TextStyle(color: Colors.black),
      //                       ),
      //                       onTap: () {
      //                         // Navigator.push(
      //                         //     context,
      //                         //     MaterialPageRoute(
      //                         //         builder: (context) => GoogleSignInScreen()));
      //                       },
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: screenHeight * 0.05,
      //                     child: ListTile(
      //                       //tileColor: Colors.white,
      //                       leading: const Icon(
      //                         Icons.pest_control,
      //                         color: Colors.black,
      //                       ),
      //                       title: const Text(
      //                         'Fertilizer',
      //                         style: TextStyle(color: Colors.black),
      //                       ),
      //                       onTap: () async {
      //                         // await FirebaseAnalytics.instance.logEvent(
      //                         //   name: "Fertilizers",
      //                         //   parameters: {
      //                         //     "content_type": "UesrID",
      //                         //     "userID": uid,
      //                         //   },
      //                         // );
      //                         Navigator.push(
      //                             context,
      //                             MaterialPageRoute(
      //                                 builder: (context) =>
      //                                     FertilizerCalculaterActivity()));//facebook_login(plugin: plugin,)));
      //                       },
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: screenHeight * 0.05,
      //                     child: ListTile(
      //                       //tileColor: Colors.white,
      //                       leading: const Icon(
      //                         Icons.wb_sunny,
      //                         color: Colors.black,
      //                       ),
      //                       title: const Text(
      //                         'Weather',
      //                         style: TextStyle(color: Colors.black),
      //                       ),
      //                       onTap: () async {
      //                         Navigator.of(context).push(MaterialPageRoute(
      //                             builder: (_) => WeatherWebView()));
      //                       },
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: screenHeight * 0.05,
      //                     child: ListTile(
      //                       //tileColor: Colors.white,
      //                       leading: const Icon(
      //                         Icons.chat_bubble_outline_rounded,
      //                         color: Colors.black,
      //                       ),
      //                       title: const Text(
      //                         'Community',
      //                         style: TextStyle(color: Colors.black),
      //                       ),
      //                       onTap: () async {
      //                         Navigator.of(context).push(MaterialPageRoute(
      //                             builder: (_) => const CommunityWebview()));
      //                       },
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: screenHeight * 0.05,
      //                     child: ListTile(
      //                       //tileColor: Colors.white,
      //                       leading: const Icon(
      //                         Icons.book,
      //                         color: Colors.black,
      //                       ),
      //                       title: const Text(
      //                         'Knowledge Base',
      //                         style: TextStyle(color: Colors.black),
      //                       ),
      //                       onTap: () async {
      //                         Navigator.of(context).push(MaterialPageRoute(
      //                             builder: (_) => const CustomerSupport()));
      //                       },
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: screenHeight * 0.05,
      //                     child: ListTile(
      //                       //tileColor: Colors.white,
      //                       leading: const Icon(
      //                         Icons.feedback,
      //                         color: Colors.black,
      //                       ),
      //                       title: const Text(
      //                         'Feedback',
      //                         style: TextStyle(color: Colors.black),
      //                       ),
      //                       onTap: () async {
      //                         Navigator.push(
      //                             context,
      //                             MaterialPageRoute(
      //                                 builder: (context) =>
      //                                 const FeedbackActivity()));
      //                       },
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: screenHeight * 0.05,
      //                     child: ListTile(
      //                       //tileColor: Colors.white,
      //                       leading: const Icon(
      //                         Icons.share,
      //                         color: Colors.black,
      //                       ),
      //                       title: const Text(
      //                         'Share app',
      //                         style: TextStyle(color: Colors.black),
      //                       ),
      //                       onTap: () {
      //                         share();
      //                       },
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: screenHeight * 0.05,
      //                     child: ListTile(
      //                       //tileColor: Colors.white,
      //                       leading: const Icon(
      //                         Icons.person_add_alt_1,
      //                         color: Colors.black,
      //                       ),
      //                       title: const Text(
      //                         'Contact us',
      //                         style: TextStyle(color: Colors.black),
      //                       ),
      //                       onTap: () {
      //                         Navigator.push(
      //                             context,
      //                             MaterialPageRoute(
      //                                 builder: (context) =>
      //                                 const ContactUsActivity()));
      //                       },
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: screenHeight * 0.05,
      //                     child: ListTile(
      //                       //tileColor: Colors.white,
      //                       leading: const Icon(
      //                         Icons.star_rate,
      //                         color: Colors.black,
      //                       ),
      //                       title: const Text(
      //                         'Rate us',
      //                         style: TextStyle(color: Colors.black),
      //                       ),
      //                       onTap: () {
      //                         final InAppReview inAppReview = InAppReview.instance;
      //                         inAppReview.requestReview();
      //                         //_showRatingDialog();
      //                       },
      //                     ),
      //                   ),
      //                   // SizedBox(
      //                   //   height: screenHeight * 0.05,
      //                   //   child: ListTile(
      //                   //     tileColor: Colors.white,
      //                   //     leading: const Icon(
      //                   //       Icons.language,
      //                   //       color: Colors.white,
      //                   //     ),
      //                   //     title: const Text(
      //                   //       'Language',
      //                   //       style: TextStyle(color: Colors.white),
      //                   //     ),
      //                   //     onTap: () {
      //                   //       _showlangDialog();
      //                   //     },
      //                   //   ),
      //                   // ),
      //                 ],
      //               ),
      //             ),
      //             const Padding(
      //               padding: EdgeInsets.only(left: 10),
      //               child: Divider(
      //                 height: 10,
      //                 thickness: 1.5,
      //                 color: Colors.black,
      //               ),
      //             ),
      //             ListTile(
      //               leading: const Icon(
      //                 Icons.logout,
      //                 color: Colors.black,
      //               ),
      //               title: const Text(
      //                 "Logout",
      //                 style: TextStyle(color: Colors.black),
      //               ),
      //               onTap: () async {
      //                 QuickAlert.show(
      //                     context: context,
      //                     type: QuickAlertType.confirm,
      //                     text: 'Do you want to logout',
      //                     confirmBtnText: 'Yes',
      //                     cancelBtnText: 'No',
      //                     confirmBtnColor: Colors.green,
      //                     onCancelBtnTap: () {
      //                       Navigator.pop(context);
      //                     },
      //                     onConfirmBtnTap: () async {
      //                       SharedPreferences prefs =
      //                       await SharedPreferences.getInstance();
      //                       prefs.setBool('_isLoggedIn', false);
      //                       Navigator.pushReplacement(
      //                           context,
      //                           MaterialPageRoute(
      //                               builder: (BuildContext context) =>
      //                               const LoginPageActivity()));
      //                     });
      //                 // await FirebaseAnalytics.instance.logEvent(
      //                 //   name: "log_out",
      //                 //   parameters: {
      //                 //     "content_type": "UesrID",
      //                 //     "userID": uid,
      //                 //   },
      //                 // );
      //               },
      //             )
      //           ],
      //         ),
      //       )),
      // ),
    );
  }

  Widget itemList(Widget icon, String title) {
    return Row(
      children: [
        icon,
        10.width,
        Text(title, style: TextStyle(color: Color(0xFF212121))),
      ],
    ).onTap(() {
      //scaffoldKey.currentState!.openEndDrawer();
      //toasty(context, title);
    });
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      //Toast.show("Please Press again to exit", context, duration: Toast.LENGTH_LONG);
      Fluttertoast.showToast(
          msg: "Please Press again to exit", toastLength: Toast.LENGTH_LONG);
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Map My Crop',
        text:
            'Don\'t miss the opportunity to use this amazing app!\n\nAt Map My Crop \u{1F33E} we help farmers to monitor crops from anywhere at anytime. We provide easy to read maps to identify low yield areas of your farm and provide helpful insights to improve crop yield.\n\nDownload the application and connect with our Agri-experts for more information \u{1F4F2}.',
        linkUrl: urlPath,
        chooserTitle: 'Map My Crop');
  }

  void _showlangDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  'Change app language',
                  style: const TextStyle(
                    color: Color(0xcc000000),
                    fontSize: 17,
                    /*fontFamily: "Inter"*/
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              //Text(S.of(context).change), //Text("Change app language"),
              actions: <Widget>[
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 200.0,
                        child: MaterialButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            setState(() {
                              prefs.setString('language', "mr");
                              //Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          super.widget));
                            });
                          },
                          child: Text(
                            "Marathi",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(
                        width: 200.0,
                        child: MaterialButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            setState(() {
                              prefs.setString('language', "hi");
                              //Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          super.widget));
                            });
                          },
                          child: Text(
                            "Hindi",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          color: const Color(0xffECB34F),
                        ),
                      ),
                      SizedBox(
                        width: 200.0,
                        child: MaterialButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            setState(() {
                              prefs.setString('language', "en");
                              //Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          super.widget));
                            });
                           // getGlobalCropList(prefs.getString('api_key'));
                          },
                          child: Text(
                            "English",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          color: const Color(0xfff7941e),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
        });
  }
}

class OvalRightBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - 50, 0);
    path.quadraticBezierTo(
        size.width, size.height / 4, size.width, size.height / 2);
    path.quadraticBezierTo(size.width, size.height - (size.height / 4),
        size.width - 40, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class HorizontalScroll {
  String name;
  String image;

  HorizontalScroll({this.name, this.image});
}

class HorizontalScroll1 {
  String name;
  String image;

  HorizontalScroll1({this.name, this.image});
}
