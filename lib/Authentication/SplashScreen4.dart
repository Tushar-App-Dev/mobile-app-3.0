import 'package:flutter/material.dart';
import 'package:mmc_master/Authentication/LoginPageActivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/SplashModel.dart';
import '../Screens/constant/Constant.dart';

class SplashScreen4 extends StatefulWidget {
  const SplashScreen4({Key key}) : super(key: key);

  @override
  _SplashScreen4State createState() => _SplashScreen4State();
}

class _SplashScreen4State extends State<SplashScreen4> {
  int currentIndex = 0;
  PageController _pageController;
  bool _isLoggedIn = false;
  static const List<String> LanguageCodes = ['en','hi','es','fr','mr','bn','gu','ml','pa','ta','te'];
  static const List<String> Languages = ['English','Hindi','Spanish','French','Marathi','Bengali','Gujarati','Malayalam','Punjabi','Tamil','Telugu'];

  List<SplashModel> screens = <SplashModel>[
    SplashModel(
      img: 'assets/images/farm_image-1.png',
      text: "Actionable Weather and \nCrop Insights",
      bg: Colors.white,
      button: Color(0xFF4756DF),
    ),
    SplashModel(
      img: 'assets/images/farm_image-3.png',
      text: "Reliable Weather Forecast \nand Historical Data",
      bg: Colors.white,
      button: Colors.white,
    ),
    SplashModel(
      img: 'assets/images/farm_image-4.png',
      text:
          "Manage your fields easier \nMonitor online.\nDetect in real-time. Act smart",
      bg: Colors.white,
      button: Color(0xFF4756DF),
    ),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  onDoneLoading() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('_isLoggedIn');
    if(prefs.getString('language')==null) {
      showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0)),
          ),
          builder: (context) {
            return ListView.builder(
                itemCount: Languages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ListTile(
                      title: Center(child: Text(Languages[index])),
                      onTap: () {
                        setState(() {
                          prefs.setString('language', LanguageCodes[index]);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (
                                      BuildContext context) => const LoginPageActivity()));
                          //print(selectedLanguage);
                          //Navigator.pop(context);
                        });
                      },
                    ),
                  );
                }
            );
          });
    }
    // if (_isLoggedIn ?? false) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (BuildContext context) => LoginPageActivity(),
    //     ),
    //   );
    else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => LoginPageActivity()));
    }
  }

  _storeOnboardInfo() async {
    //print("Shared pref called");
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
    //print(prefs.getInt('onBoard'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //currentIndex % 2 == 0 ? Color(0xFFFFFFFF) : Color(0xFF4756DF),
      body: PageView.builder(
          itemCount: screens.length,
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (_, index) {
            return Container(
              width: width(context),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  image: DecorationImage(
                      opacity: 0.8,
                      image: AssetImage(
                          'assets/illustrations/image${index == 2 ? 0 : index == 0 ? 2 : 1}.png'),
                      fit: BoxFit.fill)),
              // height: height(context),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisSize: MainAxisSize.min,
                children: [
                  //Image.asset(screens[index].img,width:200,),
                  // Container(
                  //   height: 10.0,
                  //   child: ListView.builder(
                  //     itemCount: screens.length,
                  //     shrinkWrap: true,
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: (context, index) {
                  //       return Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Container(
                  //               margin: EdgeInsets.symmetric(horizontal: 3.0),
                  //               width: currentIndex == index ? 25 : 8,
                  //               height: 8,
                  //               decoration: BoxDecoration(
                  //                 color:Colors.white,
                  //                 borderRadius: BorderRadius.circular(10.0),
                  //               ),
                  //             ),
                  //           ]);
                  //     },
                  //   ),
                  // ),
                  // SizedBox(height: height(context)*0.03,),
                  SizedBox(
                    height: height(context) * 0.16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 20),
                      Text(
                        screens[index].text,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: /*index==2?Colors.white:*/ Colors.black,
                          fontSize: 25,
                          fontFamily: "Open Sans",
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  //Expanded(child: SizedBox()),
                  SizedBox(
                    height: height(context) * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () async {
                          print(index);
                          if (index == screens.length - 1) {
                            await _storeOnboardInfo();
                            onDoneLoading();
                          }
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        child: Container(
                          width: width(context) * 0.35,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.green[300],
                            // color: Color(0xfff7941e),
                          ),
                          //padding: const EdgeInsets.only(left: 91, right: 122, top: 20, bottom: 19, ),
                          child: Center(
                            child: Text(
                              index != 2 ? "Next" : "Get Started",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  /*TextButton(
                    onPressed: () {
                      _storeOnboardInfo();
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => LoginPageActivity()));
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 17,
                        color:Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),*/
                  //SizedBox(height: height(context)*0.10,),
                ],
              ),
            );
          }),
    );
  }
}
