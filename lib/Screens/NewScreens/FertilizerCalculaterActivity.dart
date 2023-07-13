import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/constants.dart';
import '../constant/Constant.dart';

class FertilizerCalculaterActivity extends StatefulWidget {
  const FertilizerCalculaterActivity({Key key}) : super(key: key);

  @override
  State<FertilizerCalculaterActivity> createState() => _FertilizerCalculaterActivityState();
}

class _FertilizerCalculaterActivityState extends State<FertilizerCalculaterActivity> {
  int quantity=1;
  int _radioSelected1=1;
  String acre;
  bool _isFormVisible= true;
  bool _isButtonEnabled =false;
  bool _isDataUploaded = false;
  String crop='',
      urea='',
      mop='',
      dap='',
      ssp='';
  var UREA=0,
      SSP=0,
      MOP=0,
      DAP=0;
  List<String> croplist = ['Bean','Brinjal','Capsicum & Chilli','Black & Green Gram',
    'Cabbage','Cotton','Cucumber','Ginger','Rice','Sugarcane','Turmeric','Chickpea & Gram','Maize','Melon','Millet','Okra','Onion','Peanut','Pigeon','Pea & Red',
        'Potato','Sorghum','Soyabean','Tomato', 'Wheat'];
  String cropDropDownValue;

  @override
  void initState() {
    //fetchfertilizerData();
    super.initState();
  }

  Future<void> fetchfertilizerData() async {
    var data,dataValue;
    var uri = Uri.parse(
        "http://115.124.127.208/MMC/fertilizer_data.php");
    var request = new http.MultipartRequest("POST", uri);
    request.fields['CROP'] = cropDropDownValue.toString();
    // request.fields['type'] = "GET";
    //print(request);
    var response = await request.send();

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) async {
        data = jsonDecode(value);
        print(data);
        do{
          await Future.delayed(Duration(milliseconds: 1));
          setState(()  {
            // for (int i = 0; i < data.length; i++) {
            // do {
            //   await Future.delayed(Duration(milliseconds: 1));
            // } while (finalResult == null);
            crop = data[0]["CROP"];
            urea = data[0]["UREA"];
            ssp = data[0]["SSP"];
            mop = data[0]["MOP"];
            dap = data[0]["DAP"];
            print(crop);
            print(urea);
            // }
          });
        }while((urea==null||urea =='')||(ssp==null||ssp=='')||(mop==null||mop=='')||(dap==null||dap==""));

      });
    }
  }

  Future<void> calculateFertilizer() async {
    do{
      await Future.delayed(Duration(milliseconds: 1));
      print('the process repeated');
      if(!((urea==null||urea =='')||(ssp==null||ssp=='')||(mop==null||mop=='')||(dap==null||dap==""))){
        setState(() {
          UREA=int.parse(urea)*quantity;
          SSP=int.parse(ssp)*quantity;
          MOP=int.parse(mop)*quantity;
          DAP=int.parse(dap)*quantity;
          // print(UREA);
        });
      }

    }while((urea==null||urea =='')||(ssp==null||ssp=='')||(mop==null||mop=='')||(dap==null||dap==""));

  }

  void calculateAcreFertilizer(){
    setState(() {
      double a=2.47105;
      UREA=(int.parse(urea)*quantity/a).round();
      SSP=(int.parse(ssp)*quantity/a).round();
      MOP=(int.parse(mop)*quantity/a).round();
      DAP=(int.parse(dap)*quantity/a).round();
      print(UREA);
      print(SSP);
      print(MOP);
      print(DAP);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Color(0xffECB34F),
        title: ChangedLanguage(text:
          "Fertilizer Calculator",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            /*fontFamily: "Inter"*/
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Image.asset('assets/new_images/back.png')
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              margin: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 10),
                    child: FutureBuilder(future:changeLanguage("Select your Crop"),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      /*fontFamily: "Inter"*/
                      fontWeight: FontWeight.w500,
                    ),):Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.white,child: Card(
                      child: SizedBox(
                        height: height(context)*0.014,
                        width: width(context)*0.25,
                      ),
                    )),)


                   /* ChangedLanguage(text:
                      "Select your Crop",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                      ),
                    ),*/
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                      height: 40.0,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        ),
                        color: Colors.grey.shade400,
                      ),
                      child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            menuMaxHeight: 400,
                            hint: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Center(child: ChangedLanguage(text:'Choose Crop',style: TextStyle(color: Colors.black),)),
                            ),
                            value: cropDropDownValue,
                            elevation: 25,
                            isExpanded: true,
                            // dropdownColor:Colors.lightGreen,
                            icon: Icon(Icons.keyboard_arrow_down,color: Colors.black,),
                            items: croplist.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(
                                    child: FutureBuilder(future:changeLanguage(value),builder: (context,i)=> Text(i.hasData?i.data:'',style: const TextStyle(
                                        fontWeight: FontWeight.w500,color: Colors.black),),)


                                    /*Text(
                                      value,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,color: Colors.black),
                                    )*/),
                              );
                            }).toList(),
                            onChanged: (String newvalue) {
                              setState(() {
                                cropDropDownValue = newvalue;
                                // _isDataUploaded= true;
                                quantity=1;
                                _isFormVisible = true;
                                _isButtonEnabled= true;
                                fetchfertilizerData();
                              });
                            },
                          ),
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 12),
                    child: FutureBuilder(future:changeLanguage("Select your Farm Size in Number"),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      /*fontFamily: "Inter"*/
                      fontWeight: FontWeight.w500,
                    ),):Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.white,child: Card(
                      child: SizedBox(
                        height: height(context)*0.014,
                        width: width(context)*0.25,
                      ),
                    )),),

                    /*ChangedLanguage(text:
                      "Select your Farm Size in Number",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                      ),
                    ),*/
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    height:height(context)*0.30,
                    child: Stack(
                      children: [
                        Column(
                          // textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 45,
                                  color: Colors.grey.shade400,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        quantity!=1?quantity--:1;
                                      });
                                    },
                                    child: const Text(
                                      '-',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                //SizedBox(width: 20,),
                                Container(
                                  width:140,
                                  height: 40,
                                  // color: Colors.grey,
                                  child: Center(
                                    child: Text(
                                      '$quantity',style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),
                                    ),
                                  ),
                                ),
                                // SizedBox(width: 10,),
                                Container(
                                  height: 40,
                                  width: 45,
                                  color: Colors.grey.shade400,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        quantity++;
                                      });
                                    },
                                    style: ButtonStyle(),
                                    child: const Text(
                                      '+',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Column(
                                //   children: [
                                //     Radio(
                                //       value: 3,
                                //       groupValue: _radioSelected1,
                                //       activeColor: Colors.purple,
                                //       onChanged: (value) {
                                //         setState(() {
                                //           _radioSelected1 = value as int;
                                //           // _radioVal1 = 'Normal';
                                //           acre='plot';
                                //           calculateFertilizer();
                                //           print(_radioSelected1);
                                //         });
                                //       },
                                //     ),
                                //     Text('PLT')
                                //   ],
                                // ),
                                // Divider(
                                //   color: Colors.black,
                                //   thickness: 2,
                                // ),
                                Column(
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue: _radioSelected1,
                                      activeColor: Colors.purple,
                                      onChanged: (value) {
                                        setState(() {
                                          _radioSelected1 = value as int;
                                          // _radioVal1 = 'Normal';
                                          acre='acre';
                                          calculateFertilizer();
                                          print(_radioSelected1);
                                        });
                                      },
                                    ),
                                    ChangedLanguage(text:'Acre')
                                  ],
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 2,
                                ),
                                Column(
                                  children: [
                                    Radio(
                                      value: 2,
                                      groupValue: _radioSelected1,
                                      activeColor: Colors.purple,
                                      onChanged: (value) {
                                        setState(() {
                                          _radioSelected1 = value as int;
                                          // _radioVal1 = 'Normal';
                                          acre='Hectare';
                                          calculateFertilizer();
                                          print(_radioSelected1);
                                        });
                                      },
                                    ),
                                    ChangedLanguage(text:'Hectare')
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height:30.0,),
                            GestureDetector(
                              onTap: () async {
                                if (cropDropDownValue != null) {
                                  // if(UREA!=null&&SSP!=null&&MOP!=null) {
                                  _isFormVisible = false;
                                  // _isDataUploaded = true;
                                  if(_radioSelected1==2){
                                    calculateFertilizer();
                                  } else{
                                    do{
                                      await Future.delayed(Duration(milliseconds: 1));
                                      print('the process repeated');
                                      if(!((urea==null||urea =='')||(ssp==null||ssp=='')||(mop==null||mop=='')||(dap==null||dap==""))){
                                        setState(() {
                                          UREA=int.parse(urea)*quantity;
                                          SSP=int.parse(ssp)*quantity;
                                          MOP=int.parse(mop)*quantity;
                                          DAP=int.parse(dap)*quantity;
                                          // print(UREA);
                                        });
                                      }

                                    }while((urea==null||urea =='')||(ssp==null||ssp=='')||(mop==null||mop=='')||(dap==null||dap==""));
                                    /*setState(() {
                                      double a=2.47105;
                                      UREA=(int.parse(urea)*quantity/a).round();
                                      SSP=(int.parse(ssp)*quantity/a).round();
                                      MOP=(int.parse(mop)*quantity/a).round();
                                      DAP=(int.parse(dap)*quantity/a).round();
                                    });*/
                                    print(UREA);
                                    print(SSP);
                                    print(MOP);
                                    print(DAP);
                                  }
                                }
                                else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: ChangedLanguage(text:
                                            'Please select crop from Dropdown button'),
                                      ));
                                }

                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.0,vertical:10),
                                height: 45.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0xffECB34F),
                                ),
                                //padding: const EdgeInsets.only(left: 91, right: 122, top: 20, bottom: 19, ),
                                child:  Center(
                                  child: ChangedLanguage(text:
                                    "Calculate",
                                    //textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      /*fontFamily: "Inter"*/
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                      visible: !_isFormVisible,
                      child: Container(
                        width: double.infinity,
                        //height:height(context)*0.12,
                        child: !(UREA==0&&SSP==0&&DAP==0&&MOP==0)?Stack(
                          children: [
                            Column(
                              // textDirection: TextDirection.rtl,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                                    child: ChangedLanguage(text:
                                      "Fertilizers ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        /*fontFamily: "Inter"*/
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                ),
                                SizedBox(height: 10.0,),
                                Container(
                                  height: height(context)*0.2,
                                  width: width(context)*0.9,
                                  margin: EdgeInsets.symmetric(horizontal: 20.0,vertical:10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          elevation: 1,
                                          child:Container(
                                            width: width(context)*0.33,
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                                            child: Column(

                                              //crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Container(
                                                      height: height(context)*0.03,
                                                      width: height(context)*0.03,
                                                      decoration: BoxDecoration(
                                                          color:Colors.green,
                                                          borderRadius: BorderRadius.circular(height(context)*0.017)
                                                      ),
                                                      child:Center(child: Icon(Icons.shopping_bag_outlined,size: height(context)*0.0180,color:Colors.white))

                                                  ),
                                                  ChangedLanguage(text:'Urea',style:TextStyle(color: Colors.grey)),
                                                  Container(
                                                    //width: width(context)*0.15,
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [

                                                        Text(UREA.toString()??'',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                                        Text("Kg",style: TextStyle(fontSize: 10),)
                                                      ],
                                                    ),
                                                  )
                                                ]
                                            ),
                                          )
                                      ),
                                      Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          elevation: 1,
                                          child:Container(
                                            width: width(context)*0.33,
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                                            child: Column(
                                              //crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Container(
                                                      height: height(context)*0.03,
                                                      width: height(context)*0.03,
                                                      decoration: BoxDecoration(
                                                          color:Colors.green,
                                                          borderRadius: BorderRadius.circular(height(context)*0.017)
                                                      ),
                                                      child:Center(child: Icon(Icons.shopping_bag_outlined,size: height(context)*0.0180,color:Colors.white))

                                                  ),
                                                  ChangedLanguage(text:'SSP',style:TextStyle(color: Colors.grey)),
                                                  Container(
                                                    //width: width(context)*0.15,
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [

                                                        Text( SSP.toString()??'',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                                        Text("Kg",style: TextStyle(fontSize: 10),)
                                                      ],
                                                    ),
                                                  )
                                                ]
                                            ),
                                          )
                                      ),
                                      //

                                    ],
                                  ),
                                ),
                                Container(
                                  height: height(context)*0.2,
                                  width: width(context)*0.9,
                                  margin: EdgeInsets.symmetric(horizontal: 20.0,vertical:10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          elevation: 1,
                                          child:Container(
                                            width: width(context)*0.33,
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                                            child: Column(
                                              //crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Container(
                                                      height: height(context)*0.03,
                                                      width: height(context)*0.03,
                                                      decoration: BoxDecoration(
                                                          color:Colors.green,
                                                          borderRadius: BorderRadius.circular(height(context)*0.017)
                                                      ),
                                                      child:Center(child: Icon(Icons.shopping_bag_outlined,size: height(context)*0.0180,color:Colors.white))

                                                  ),
                                                  ChangedLanguage(text:'MOP',style:TextStyle(color: Colors.grey)),
                                                  Container(
                                                    //width: width(context)*0.15,
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [

                                                        Text( MOP.toString()??'',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                                        Text("Kg",style: TextStyle(fontSize: 10),)
                                                      ],
                                                    ),
                                                  )
                                                ]
                                            ),
                                          )
                                      ),

                                      Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          elevation: 1,
                                          child:Container(
                                            width: width(context)*0.33,
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                                            child: Column(
                                              //crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Container(
                                                      height: height(context)*0.03,
                                                      width: height(context)*0.03,
                                                      decoration: BoxDecoration(
                                                          color:Colors.green,
                                                          borderRadius: BorderRadius.circular(height(context)*0.017)
                                                      ),
                                                      child:Center(child: Icon(Icons.shopping_bag_outlined,size: height(context)*0.0180,color:Colors.white))

                                                  ),
                                                  ChangedLanguage(text:'DAP',style:TextStyle(color: Colors.grey)),
                                                  Container(
                                                    //width: width(context)*0.15,
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [

                                                        Text( DAP.toString()??'',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                                        Text("Kg",style: TextStyle(fontSize: 10),)
                                                      ],
                                                    ),
                                                  )
                                                ]
                                            ),
                                          )
                                      ),
                                      //

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ):SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

