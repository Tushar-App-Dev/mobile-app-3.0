import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../Model/PlanModal.dart';
import 'NewScreens/DashboardActivity.dart';
import 'constant/Constant.dart';

class ChoosePlanScreen extends StatefulWidget {
  @override
  ChoosePlanScreenState createState() => ChoosePlanScreenState();
}

class ChoosePlanScreenState extends State<ChoosePlanScreen> {
  List<PlanModal> planList = [];
  PageController controller = PageController(initialPage: 0, viewportFraction: 0.85);
  int selectedIndex = 0;
  int pageIndex = 0;
  Color blueButtonAndTextColor = Color(0xFF3878ec);

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    planList.add(
      PlanModal(
        image: 'assets/images/weather.png',//'assets/images/ThirdScreen1.png',
        title: 'Free',
        subTitle: 'For a trial period of 14 days and \nfarm limit of 25 ha.',
        price: '\₹0',//'\$0',
        planPriceSubTitle: 'per user',
        optionList: [
          PlanModal(title: 'NDVI'),
          PlanModal(title: 'EVI'),
          PlanModal(title: 'Farm Score'),
          PlanModal(title: 'Live Weather Forecast'),
          PlanModal(title: 'Crop Classification'),
        ],
      ),
    );
    planList.add(
      PlanModal(
        image: 'assets/images/loc.png',//'assets/images/ThirdScreen2.png',
        title: 'Standard',
        subTitle: 'Monthly premium subscription \nwith 100 ha farm area.',
        price: '\₹299',
        planPriceSubTitle: 'per user/month',
        optionList: [
          PlanModal(title: 'Everything in free'),
          PlanModal(title: 'Crop Insights'),
          PlanModal(title: 'Weather Insights'),
          PlanModal(title: 'Scouting'),
          PlanModal(title: 'API'),
        ],
        isVisible: true,
      ),
    );
    planList.add(
      PlanModal(
        image: 'assets/images/expert.png',//'assets/images/ThirdScreen3.png',
        title: 'Enterprise',
        subTitle: 'Monthly premium subscription \nwith 100 ha farm area.',
        price: '\₹599',
        planPriceSubTitle: 'per user / Year',
        optionList: [
          PlanModal(title: 'Everything in free'),
          PlanModal(title: 'Crop Insights'),
          PlanModal(title: 'Weather Insights'),
          PlanModal(title: 'Scouting'),
          PlanModal(title: 'API'),
        ],
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Pricing plan',
        textColor:Colors.white,
        //center: true,
        //color: context.scaffoldBackgroundColor,
        color: Color(0xffECB34F)
      ),
      backgroundColor: context.scaffoldBackgroundColor,
      body: Container(
        height:height(context),
        width: width(context),
        child: PageView.builder(
          controller: controller,
          itemCount: planList.length,
          onPageChanged: (index) {
            pageIndex = index;
            setState(() {});
          },
          itemBuilder: (_, int index) {
            bool isPageIndex = selectedIndex == index;
            return AnimatedContainer(
              margin: EdgeInsets.symmetric(vertical: pageIndex == index ? 16 : 50, horizontal: 8),
              height: pageIndex == index ? 0.5 : 0.45,
              width: width(context),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: defaultBoxShadow(),
              ),
               duration: 10000.microseconds,
              curve: Curves.linearToEaseOut,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    planList[index].image.validate(),
                    fit: BoxFit.cover,
                    height: 150,//190,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(planList[index].title.validate(), style: boldTextStyle(size: 30)),
                        Text(planList[index].subTitle.validate(), style: secondaryTextStyle()),
                        24.height,
                        Text(planList[index].price.validate(), style: boldTextStyle(size: 45, color: blueButtonAndTextColor)),
                        Text(planList[index].planPriceSubTitle.validate(), style: secondaryTextStyle()),
                        24.height,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: UL(
                            symbolType: SymbolType.Bullet,
                            symbolColor: Colors.orange,
                            spacing: 24,
                            children: List.generate(
                              planList[index].optionList.length,
                                  (i) => Text(planList[index].optionList[i].title.validate(), style: boldTextStyle()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).expand(),
                  AppButton(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    width: width(context) - 120,
                    child: TextIcon(
                      prefix: isPageIndex ? Icon(Icons.check, color: selectedIndex == index ? Colors.green : null, size: 16) : null,
                      text: isPageIndex ? ' Your current plan' : 'Upgrade',
                      textStyle: boldTextStyle(size: 18, color: isPageIndex ? Colors.green : white),
                    ),
                    onTap: () {
                      // setState(() {
                      //   Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (BuildContext context) => DashboardActivity()));
                      // });
                      selectedIndex = index;
                    },
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
                    color: isPageIndex ? Colors.green.shade100 : Colors.orangeAccent,//Color(0xffFFE8C6),//blueButtonAndTextColor
                  ).paddingBottom(16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}