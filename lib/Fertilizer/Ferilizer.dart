import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Screens/constant/Constant.dart';

class FertilizerCalculator extends StatefulWidget {
  const FertilizerCalculator({Key key}) : super(key: key);

  @override
  State<FertilizerCalculator> createState() => _FertilizerCalculatorState();
}

class _FertilizerCalculatorState extends State<FertilizerCalculator> {

  int quantity=1;
  int _radioSelected1=1;
  String acre;
  bool _isFormVisible= true;
  bool _isButtonEnabled =false;
  bool _isDataUploaded = false;
  String crop,urea,mop,dap,ssp;
  var UREA,SSP,MOP,DAP;
  List<String> croplist = ['Bean','Brinjal','Capsicum & Chilli','Black & Green Gram',
    'Cabbage','Cotton','Cucumber','Ginger','Rice','Sugarcane','Turmeric','Chickpea & Gram','Maize','Melon','Millet','Okra','Onion','Peanut','Pigeon','Pea & Red'
    'Potato','Sorghum','Soyabean','Tomato' 'Wheat'];
  String cropDropDownValue;

  @override
  void initState() {
    // fetchfertilizerData();
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
        setState(() {
          for (int i = 0; i < data.length; i++) {
            crop = data[i]["CROP"];
            urea = data[i]["UREA"];
            ssp = data[i]["SSP"];
            mop = data[i]["MOP"];
            dap = data[i]["DAP"];
            print(crop);
            print(urea);
          }
        });
      });
    }
  }

  void calculateFertilizer(){
     setState(() {
       UREA=int.parse(urea)*quantity;
       SSP=int.parse(ssp)*quantity;
       MOP=int.parse(mop)*quantity;
       DAP=int.parse(dap)*quantity;
       // print(UREA);
     });
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
    double cardWidth = width(context) / 1.8;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Fertilizer Calculator',
        ),
        backgroundColor: Colors.green[800],
      ),
      body: Column(
        children: [
          Card(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 50.0,vertical: 10.0),
                height: 40.0,
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1.0, style: BorderStyle.solid),
                    borderRadius:
                    BorderRadius.all(Radius.circular(10.0)),
                  ),
                  color: Colors.green,
                ),
                child:DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    //focusNode: emailIDFocusNode,
                    hint: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Center(child: Text('Choose Crop',style: TextStyle(color: Colors.black),)),
                    ),
                    value: cropDropDownValue,
                    elevation: 25,
                    isExpanded: true,
                    // dropdownColor:Colors.lightGreen,
                    icon: Icon(Icons.arrow_drop_down_circle,color: Colors.white,),
                    items: croplist.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(
                            child: Text(
                              value,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,color: Colors.black),
                            )),
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
                )
            ),
          ),
          Card(
            margin: EdgeInsets.all(5),
            child: Container(
              width: double.infinity,
              height:height(context)*0.29,
              child: Stack(
                children: [
                  Column(
                    // textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Plot Size',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),),
                      ),
                       SizedBox(height: 10.0,),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green,
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
                          CircleAvatar(
                            backgroundColor: Colors.green,
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
                       Padding(
                         padding: EdgeInsets.fromLTRB(width(context)*0.58,5,0.0,0),
                         child: Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               Text(acre!=null?acre.toString():'Acre')
                             ]
                         ),
                       ),
                      SizedBox(height: 15.0,),
                      Padding(
                        padding: const EdgeInsets.only(right:17.0),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Radio(
                              value: 1,
                              groupValue: _radioSelected1,
                              activeColor: Colors.purple,
                              onChanged: (value) {
                                setState(() {
                                  _radioSelected1 = value as int;
                                  // _radioVal1 = 'Normal';
                                  acre='Acre';
                                  calculateAcreFertilizer();
                                  print(_radioSelected1);
                                });
                              },
                            ),
                            const Text("Acre"),
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
                            const Text("Hectare"),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: MaterialButton(
                          color: Colors.green,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              side: BorderSide(color: Colors.black)),
                          // padding: EdgeInsets.only(right: 50),
                          // color: Theme.of(context).buttonColor,
                          textColor: Colors.black,
                          child: const Text('Calculate'),
                          onPressed: () {
                            // Navigator.pop(context);
                            if (cropDropDownValue != null) {
                              // if(UREA!=null&&SSP!=null&&MOP!=null) {
                                _isFormVisible = false;
                                // _isDataUploaded = true;
                                if(_radioSelected1==2){
                                  calculateFertilizer();
                                }
                                else{
                                  setState(() {
                                    // UREA=int.parse(urea)*quantity;
                                    // SSP=int.parse(ssp)*quantity;
                                    // MOP=int.parse(mop)*quantity;
                                    // DAP=int.parse(dap)*quantity;
                                    double a=2.47105;
                                    UREA=(int.parse(urea)*quantity/a).round();
                                    SSP=(int.parse(ssp)*quantity/a).round();
                                    MOP=(int.parse(mop)*quantity/a).round();
                                    DAP=(int.parse(dap)*quantity/a).round();
                                  });
                                }
                              // }
                              // else{
                              //   // calculateAcreFertilizer();
                              //   setState(() {
                              //     // UREA=int.parse(urea)*quantity;
                              //     // SSP=int.parse(ssp)*quantity;
                              //     // MOP=int.parse(mop)*quantity;
                              //     // DAP=int.parse(dap)*quantity;
                              //     double a=2.47105;
                              //     UREA=(int.parse(urea)*quantity/a).round();
                              //     SSP=(int.parse(ssp)*quantity/a).round();
                              //     MOP=(int.parse(mop)*quantity/a).round();
                              //     DAP=(int.parse(dap)*quantity/a).round();
                              //   });
                              //  }
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please select crop from Dropdown button'),
                                  ));
                            }
                            setState(() {
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Visibility(
                    visible: !_isFormVisible,
                    child: Card(
                      margin: EdgeInsets.all(5),
                      child: Container(
                        width: double.infinity,
                        height:height(context)*0.12,
                        child: Stack(
                          children: [
                            Column(
                              // textDirection: TextDirection.rtl,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('UREA/SSP/MOP/DAP'),
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                   Column(
                                     children: [
                                       Padding(
                                         padding: const EdgeInsets.all(4.0),
                                         child: Text('Urea',style: TextStyle(fontWeight:FontWeight.bold),),
                                       ),
                                       Text(UREA.toString()+' kg',style: TextStyle(fontSize:16.0))
                                     ],
                                   ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text('SSP',style: TextStyle(fontWeight:FontWeight.bold)),
                                        ),
                                        Text(SSP.toString()+' kg',style: TextStyle(fontSize:16.0))
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text('MOP',style: TextStyle(fontWeight:FontWeight.bold)),
                                        ),
                                        Text(MOP.toString()+' kg',style: TextStyle(fontSize:16.0))
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text('DAP',style: TextStyle(fontWeight:FontWeight.bold)),
                                        ),
                                        Text(DAP.toString()+' kg',style: TextStyle(fontSize:16.0))
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
