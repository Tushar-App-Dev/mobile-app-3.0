import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mmc_master/Screens/NewScreens/AddCropActivity.dart';
import 'package:mmc_master/Screens/NewScreens/AdvisoryActivity.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/LoginPageActivity.dart';
import 'Authentication/SplashScreen4.dart';
import 'ChangeLanguageNotifier.dart';
import 'Screens/NewScreens/AddNewFarmsActivity.dart';
import 'Screens/NewScreens/CropGuideListActivity.dart';
import 'Screens/NewScreens/DashboardActivity.dart';
import 'Screens/NewScreens/PlannerActivity.dart';
import 'Screens/NewScreens/ScoutingActivity.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


/// Created by Bharat on 22-march-22.

// @dart=2.9

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

int isviewed;
bool _isLoggedIn;
enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

Future<void> main() async {  //void only
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await Hive.initFlutter();
  // Hive.registerAdapter(DiseaseAdapter());
  // await Hive.openBox<Disease>('plant_diseases');

  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  _isLoggedIn = prefs.getBool('_isLoggedIn');
  // if(prefs.getString('language')==null){
  //   prefs.setString('language', "en");
  // }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
       ChangeNotifierProvider<LanguageChangeProvider>(create: (context) => LanguageChangeProvider()),
       //ChangeNotifierProvider<DiseaseService>(create: (context) => DiseaseService()),
     ],
        child: Builder(
            builder: (context) => (MaterialApp(
              //Get
              debugShowCheckedModeBanner: false,
              locale: Provider.of<LanguageChangeProvider>(context, listen: true).currentLocale,
              localizationsDelegates:  const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              title: 'Make My Crop',
                theme: ThemeData(
                    fontFamily: "Poppins"
                ),
              routes: <String, WidgetBuilder>{
                '/Global': (BuildContext context) =>  CropGuideListActivity(title:'Global'),
                '/India': (BuildContext context) =>  CropGuideListActivity(title:'India'),
                '/0': (BuildContext context) => AdvisoryActivity(),
                '/2': (BuildContext context) =>ScoutingActivity(),
                '/1': (BuildContext context) =>AddCropActivity(),
                '/3': (BuildContext context) => PlannerActivity(),
                // '/4': (BuildContext context) =>ExpertCall(),
                // '/5': (BuildContext context) =>DownloadImageryActivity(),
                // '/6': (BuildContext context) =>MandiPriceDta(),
              },
              home: isviewed != 0
                  ? SplashScreen4()
                  : _isLoggedIn != true
                  ? LoginPageActivity()//LoginPage()
                  : DashboardActivity()//Bottomnavigationbar(),
            ))));
  }
}
