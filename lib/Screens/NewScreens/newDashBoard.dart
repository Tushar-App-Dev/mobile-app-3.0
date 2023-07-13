import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mmc_master/Mandi/MandiPriceData.dart';
import 'package:mmc_master/Screens/NewScreens/DashboardActivity.dart';
import 'package:mmc_master/Screens/NewScreens/SelfProduceActivity.dart';
import 'package:mmc_master/Screens/constant/Constant.dart';
import 'package:nb_utils/nb_utils.dart' as nb;
import 'package:url_launcher/url_launcher.dart';

import 'ExpertCall.dart';

class NewDashBoard extends StatefulWidget {
  const NewDashBoard({Key key}) : super(key: key);

  @override
  State<NewDashBoard> createState() => _NewDashBoardState();
}

class _NewDashBoardState extends State<NewDashBoard> {
  int _tabIndex = 1;
  int get tabIndex => _tabIndex;
  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }
  List<Widget> Tabs = [
    MandiPriceDta().expand(),
    SelfProduce().expand(),
    DashboardActivity().expand(),
    ExpertCall().expand()
  ];

  PageController pageController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Color(0xff3d372f).withOpacity(0.25),
        bottomOpacity: 0.08,
        leading: SizedBox(),
        title: Text(
          'Home',
          style: TextStyle(color: black, fontWeight: FontWeight.w600),
        ),
        elevation: 7,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipOval(
              child: Image.asset(
                'assets/images/default.jpg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          )
        ],
        centerTitle: true,
        backgroundColor: themeColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12))),
      ),
      body: SizedBox(
        width: width(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: height(context) * 0.2,
              width: width(context) * 0.9,
              child: Stack(
                children: [
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: height(context) * 0.027,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: themeColor),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: height(context) * 0.15,
                                  width: height(context) * 0.15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12)),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/soilMoisture.jpg'),
                                          fit: BoxFit.fill)),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        // crossAxisAlignment:CrossAxisAlignment,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(12)),
                                                border:
                                                    Border.all(color: themeColor),
                                                color: themeColor,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Pise Vasti',
                                                  style: TextStyle(
                                                      color: black,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Icon(Icons.pin_drop_outlined,
                                            size: 12, color: green),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text('Solapur',
                                            style: TextStyle(fontSize: 12))
                                      ]),
                                      Row(children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Icon(Icons.pin_drop_outlined,
                                            size: 12, color: green),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text('12.73 Acres',
                                            style: TextStyle(fontSize: 12))
                                      ]),
                                      Row(children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Icon(Icons.fullscreen_outlined,
                                            size: 12, color: green),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text('Sugarcane',
                                            style: TextStyle(fontSize: 12))
                                      ]),
                                      Row(children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Icon(Icons.emoji_emotions_outlined,
                                            size: 12, color: orange),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text('Unhealthy',
                                            style: TextStyle(fontSize: 12))
                                      ]),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: height(context) * 0.017,


                      
                    right: height(context) * 0.02,
                    child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13)),
                        child: Icon(
                          Icons.add_circle_outline,
                          color: green,
                          size: 25,
                        )),
                  )
                ],
              ),
            ),
            // Tabs[tabIndex]
          ],
        ),
      ),
      bottomNavigationBar: CircleNavBar(
        tabDurationMillSec: 1500,
        iconDurationMillSec: 1500,
        tabCurve: Curves.easeInOut,
        activeIcons:  [
          Icon(Icons.home_outlined, color: tabIndex==0?orange:green),
          Icon(Icons.handshake_outlined, color: tabIndex==1?orange:green),
          Icon(Icons.home, color: tabIndex==2?orange:green),
          Icon(Icons.phone, color: tabIndex==3?orange:green),
        ],
        inactiveIcons:  [
          Icon(Icons.home_outlined, color: tabIndex==0?orange:green),
          Icon(Icons.handshake_outlined, color: tabIndex==1?orange:green),
          Icon(Icons.home, color: tabIndex==2?orange:green),
          Icon(Icons.phone, color: tabIndex==3?orange:green),
          // Text("Market"),
          // Text("deal"),
          // Text("Home"),
          // Text("Call"),
        ],
        color: Colors.white,
        height: 60,
        circleWidth: 40,
        activeIndex: tabIndex,
        onTap: (index) {
          setState((){
            tabIndex = index;
          });

          // pageController.jumpToPage(tabIndex);
        },
        //padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          // bottomRight: Radius.circular(24),
          // bottomLeft: Radius.circular(24),
        ),

        shadowColor: green,
        elevation: 2,
      ),
    );
  }
}
