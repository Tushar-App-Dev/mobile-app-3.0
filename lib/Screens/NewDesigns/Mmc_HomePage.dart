import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mmc_master/constants/constants.dart';

import '../constant/Constant.dart';
import 'package:shimmer/shimmer.dart';


class Mmc_HomePage extends StatefulWidget {
  const Mmc_HomePage({Key key, this.farmList}) : super(key: key);
final List<String> farmList;
  @override
  State<Mmc_HomePage> createState() => _Mmc_HomePageState();
}

class _Mmc_HomePageState extends State<Mmc_HomePage> {
  FocusNode farmFocusNode = FocusNode();
  String farm = 'Pise Vasti';
  //List<String> farms = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Mmc_AppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          width: width(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 40),
                padding: EdgeInsets.symmetric(horizontal: 13,vertical: 26),
                height: height(context)*0.18,
                width: width(context)*0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: themeColor),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(blurRadius: 12,offset: Offset.fromDirection(20.2),spreadRadius: 0,color: Color(0xff5A503E).withOpacity(0.1),),
                    // BoxShadow(blurRadius: 16,spreadRadius: 12,color: Colors.blue),
                  ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select farm below to get all the updates related to your selected farm. '),
                    Container(height: height(context)*0.05,
                      // width: width(context),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: themeColor,strokeAlign: StrokeAlign.outside),
                          borderRadius: BorderRadius.circular(8),

                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: height(context)*0.05,
                            width: width(context)*0.35,
                            decoration: BoxDecoration(
                              color: themeColor,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8))
                            ),
                            child: Center(child: Text('Select Farm',style: TextStyle(fontWeight: FontWeight.w600),)),
                          ),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                borderRadius: BorderRadius.circular(12),
                                menuMaxHeight: height(context)*0.3,
                                dropdownColor: Colors.white,
                                focusNode: farmFocusNode,
                                hint: Center(child:Text(farm==null?'Select farm':farm,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0))

                                /*FutureBuilder(future:changeLanguage(farm==null?'Select farm':farm),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0),):Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.white,child: Card(
                                  child: SizedBox(
                                    height: height(context)*0.014,
                                    width: width(context)*0.5,
                                  ),
                                )),)*/
                                  // Text(state==null?'Select state':state)
                                ),
                              //  value: stateValue,
                                elevation: 25,
                                isExpanded: true,
                                icon: Container(
                                  height: height(context)*0.06,
                                  width: height(context)*0.05,
                                    decoration:BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: themeColor)
                                    ),
                                    child: Icon(Icons.keyboard_arrow_down_outlined,color: themeColor,)),
                                items: widget.farmList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: FutureBuilder(future:changeLanguage(value),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                    baseColor: Colors.grey.shade300,
                                                    highlightColor: Colors.white,child: Card(
                                                  child: SizedBox(
                                                    height: height(context)*0.014,
                                                    width: width(context)*0.5,
                                                  ),
                                                )),)
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                // selectedItemBuilder: (context){
                                //   return [Column(
                                //     mainAxisSize: MainAxisSize.max,
                                //     crossAxisAlignment: CrossAxisAlignment.center,
                                //     children: [
                                //       Row(
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         children: [
                                //           Expanded(
                                //               child: FutureBuilder(future:changeLanguage(value),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                //                   baseColor: Colors.grey.shade300,
                                //                   highlightColor: Colors.white,child: Card(
                                //                 child: SizedBox(
                                //                   height: height(context)*0.014,
                                //                   width: width(context)*0.5,
                                //                 ),
                                //               )),)
                                //           ),
                                //         ],
                                //       ),
                                //     ],
                                //   )];
                                // }
                                // ,
                                onChanged: (String newvalue) {
                                  setState((){
                                    farm = newvalue;
                                  });

                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height:24,),
              ChangedLanguage(
                text: 'Currrent Weather',
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w700,
                    fontSize: 17),
              ),
              Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    width: width(context)*0.9,
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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


                        Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 13),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location',
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold),
                                ),

                                Text(
                                  '37.56\u2103',
                                  style: TextStyle(
                                      fontSize: 45, color: orange,fontWeight: FontWeight.w600,height: 1),
                                ),

                                ChangedLanguage(
                                  text: 'clear sky',
                                  style: TextStyle(color: Colors.blueGrey,fontSize: 12,height: 0.9),
                                ),
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        Icon(Icons.water_drop_outlined,
                                            color: orange,size: 12,),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        ChangedLanguage(
                                          text: 'Humidity',

                                          style:
                                          TextStyle(color: Colors.blueGrey,fontSize: 12),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '16%',
                                          style: TextStyle(color: black,fontSize: 12),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(FontAwesomeIcons.wind,size: 12,
                                            color: orange),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        ChangedLanguage(
                                          text: 'Wind',
                                          style:
                                          TextStyle(color: Colors.blueGrey,fontSize: 12,height:0.9),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '6.52 kph',
                                          style: TextStyle(color: black,fontSize: 12,height:0.9),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.compress,
                                            color: orange,size: 12,),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        ChangedLanguage(
                                          text: 'Pressure',
                                          style:
                                          TextStyle(color: Colors.blueGrey,fontSize: 12),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '1008hPa',
                                          style: TextStyle(color: black,fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            /*SizedBox(
                              width: width(context) * 0.15,
                            ),*/
                            SvgPicture.asset('assets/svgImages/09d.svg',height: height(context)*0.15,width:width(context)*0.45,fit: BoxFit.fill,)
                          ],
                        ),

                      ],
                    ),
                  ) /*:Container(
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
              ),

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
            ],
          ),
        ),
      ),
    );
  }
}
