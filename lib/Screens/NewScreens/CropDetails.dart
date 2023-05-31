import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mmc_master/Widgets/Loading.dart';
import 'package:mmc_master/constants/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:text_to_speech/text_to_speech.dart';

import '../../main.dart';
import '../constant/Constant.dart';
class CropDetails extends StatefulWidget {
  const CropDetails({Key key, this.data, this.image}) : super(key: key);
  final String data;
  final image;
  @override
  State<CropDetails> createState() => _CropDetailsState();
}

class _CropDetailsState extends State<CropDetails> {
  var data;
  String causes = '';
  String symptoms = '';
  String chemicalControl = '';
  String organicControl = '';
  String description = '';
  String firstHalf = '';
  String secondHalf = '';
  bool flag = true;
  String firstHalf1 = '';
  String secondHalf1 = '';
  bool flag1 = true;
  String firstHalf2 = '';
  String secondHalf2 = '';
  bool flag2 = true;
  String firstHalf3 = '';
  String secondHalf3 = '';
  bool flag3 = true;

  final String defaultLanguage = 'en-US';
  //String text = '';
  double volume = 1; // Range: 0-1
  double rate = 1.0; // Range: 0-2
  double pitch = 1.0;
  TextToSpeech tts = TextToSpeech();
  String language;
  String languageCode;
  List<String> languages = <String>[];
  List<String> languageCodes = <String>[];
  String voice;
  String translatedString = '';
  bool symptomsRunning = false;
  bool causeRunning = false;

  bool chemicalRunning = false;
  bool organicRunning = false;

  Future<void> speak(String text) async {
    print('the text in speak is $text');
    tts.setVolume(volume);
    tts.setRate(rate);
    if (languageCode != null) {
      tts.setLanguage(languageCode);
    }
    tts.setPitch(pitch);
    tts.speak(text);
    print(await tts.speak(text));
  }
  @override
  void initState() {
    // TODO: implement initState
    data = jsonDecode(widget.data);
    getDiseases(0);
    super.initState();
  }

  getDiseases(index) async {
    //print(widget.data);
    // var uri = Uri.parse("https://api.mapmycrop.com/diseases");
    // var request = http.MultipartRequest("GET", uri);
    // data = jsonDecode(widget.data);
    // var response = await request.send().timeout(const Duration(minutes: 2));
    // print(response.statusCode);
    //
    // if (response.statusCode == 200) {
    //   response.stream
    //       .transform(utf8.decoder)
    //       .transform(LineSplitter())
    //       .listen((value) async {
    //         setState(() {
    //           data = jsonDecode(value);
    //           causes = data["data"][2]['causes'];
    //           symptoms = data["data"][2]['symptoms'];
    //
    //         });
    //
    //
    //     //print(data["data"][0]['name']);
    //   });
    // }
    //
    // await Future.delayed(Duration(seconds: 1 ));

    if (data[index]['causes'] != null) {
      causes = await changeLanguage(data[index]['cause']);
    }
    // causes= data[index]['symptoms'];
    if (data[index]['symptoms'] != null) {
      symptoms = await changeLanguage(data[index]['symptoms']);
    }
    if (data[index]['organic_control'] != null) {
      organicControl = await changeLanguage(data[index]["organic_control"]);
    }
    if (data[index]['chemical_control'] != null) {
      chemicalControl = await changeLanguage(data[index]["chemical_control"]);
    }
//print(symptoms.length);
    if (causes.length > 103) {
      print('entered iff');
      setState(() {
        firstHalf = causes.substring(0, 103);
        //firstHalf1 = symptoms.substring(0, 103);
        // firstHalf2 = organicControl.substring(0, 103);
        // firstHalf3 = chemicalControl.substring(0, 103);
        //print(firstHalf);
        secondHalf = causes.substring(103, causes.length);
        // secondHalf1 = symptoms.substring(103, symptoms.length);
        // secondHalf2 = organicControl.substring(103, organicControl.length);
        // secondHalf3 = chemicalControl.substring(103, chemicalControl.length);
      });
    } else {
      setState(() {
        firstHalf = causes;
        // firstHalf1 = symptoms;
      });
      //secondHalf = "";
    }
    if (symptoms.length > 103) {
      print('entered iff');
      setState(() {
        /// firstHalf = causes.substring(0, 103);
        firstHalf1 = symptoms.substring(0, 103);
        // firstHalf2 = organicControl.substring(0, 103);
        // firstHalf3 = chemicalControl.substring(0, 103);
        //print(firstHalf);
        // secondHalf = causes.substring(103, causes.length);
        secondHalf1 = symptoms.substring(103, symptoms.length);
        // secondHalf2 = organicControl.substring(103, organicControl.length);
        // secondHalf3 = chemicalControl.substring(103, chemicalControl.length);
      });
    } else {
      setState(() {
        //firstHalf = causes;
        firstHalf1 = symptoms;
      });
      //secondHalf = "";
    }
    if (organicControl.length > 103) {
      print('entered iff');
      setState(() {
        /// firstHalf = causes.substring(0, 103);
        // firstHalf1 = symptoms.substring(0, 103);
        firstHalf2 = organicControl.substring(0, 103);
        // firstHalf3 = chemicalControl.substring(0, 103);
        //print(firstHalf);
        // secondHalf = causes.substring(103, causes.length);
        // secondHalf1 = symptoms.substring(103, symptoms.length);
        secondHalf2 = organicControl.substring(103, organicControl.length);
        // secondHalf3 = chemicalControl.substring(103, chemicalControl.length);
      });
    } else {
      setState(() {
        //firstHalf = causes;
        // firstHalf1 = symptoms;
        firstHalf2 = organicControl;
      });
      //secondHalf = "";
    }
    if (chemicalControl.length > 103) {
      print('entered iff');
      setState(() {
        /// firstHalf = causes.substring(0, 103);
        //firstHalf1 = symptoms.substring(0, 103);
        // firstHalf2 = organicControl.substring(0, 103);
        firstHalf3 = chemicalControl.substring(0, 103);
        //print(firstHalf);
        // secondHalf = causes.substring(103, causes.length);
        //secondHalf1 = symptoms.substring(103, symptoms.length);
        // secondHalf2 = organicControl.substring(103, organicControl.length);
        secondHalf3 = chemicalControl.substring(103, chemicalControl.length);
      });
    } else {
      setState(() {
        //firstHalf = causes;
        //firstHalf1 = symptoms;
        firstHalf3 = chemicalControl;
      });
      //secondHalf = "";
    }
    print('The first half is $firstHalf');
    print('The first1 half is $firstHalf1');
    print('The second half is $secondHalf');
    print('The second1 half is $secondHalf1');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        tts.stop();
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: false,
          backgroundColor: const Color(0xffECB34F),
          title: const ChangedLanguage(text:
          "Disease Details",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: "Inter",
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset('assets/new_images/back.png')),
        ),
        body: widget.data != null
            ? SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      getDiseases(0);
                    },
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 25),
                              height: height(context) * 0.1,
                              width: height(context) * 0.1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: MemoryImage(widget.image),
                                      fit: BoxFit.fill)),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    ChangedLanguage(text:'Crop  : ',
                                      style:
                                      const TextStyle(color: Colors.black),),
                                    ChangedLanguage(text:data[0]['crop_name']!=null?data[0]['crop_name']:data[0]['crop'],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold))
                                  ],),
                                  // RichChangedLanguage(text:
                                  //   //overflow: TextOverflow.ellipsis,
                                  //   //textAlign: TextAlign.end,
                                  //   softWrap: false,
                                  //   maxLines: 2,
                                  //   //textScaleFactor: 1,
                                  //   text: TextSpan(
                                  //     text: 'Crop  : ',
                                  //     style:
                                  //         const TextStyle(color: Colors.black),
                                  //     children: <TextSpan>[
                                  //       TextSpan(
                                  //           text: data[0]['crop_name']!=null?data[0]['crop_name']:data[0]['crop'],
                                  //           style: const TextStyle(
                                  //               color: Colors.black,
                                  //               fontWeight: FontWeight.bold)),
                                  //     ],
                                  //   ),
                                  // ),
                                  Row(
                                    children: [
                                      ChangedLanguage(text:'Diseases  : ',
                                        style:
                                        const TextStyle(color: Colors.black),),
                                      ChangedLanguage(text:data[0]['disease'],
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  /*RichChangedLanguage(text:
                                      //overflow: TextOverflow.ellipsis,
                                      //textAlign: TextAlign.end,
                                      softWrap: false,
                                      maxLines: 2,
                                      //textScaleFactor: 1,
                                      text: TextSpan(
                                        text: 'Diseases  : ',
                                        style:
                                            const TextStyle(color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: data[0]['disease'],
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),*/
                                  /*RichChangedLanguage(text:
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.end,
                                          //
                                          softWrap: true,
                                          maxLines: 1,
                                          textScaleFactor: 1,
                                          text: const TextSpan(
                                            text: 'Stage  : ',
                                            style: TextStyle(color: Colors.black),

                                            children:  <TextSpan>[
                                              TextSpan(
                                                  text: "Fruiting",
                                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)
                                              ),
                                            ],
                                          ),
                                        ),*/
                                  Row(
                                    children: [
                                      ChangedLanguage(text:'Confidence  : ',
                                        style:
                                        const TextStyle(color: Colors.black),),
                                      ChangedLanguage(text: data[0]['confidence']
                                          .toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  )
                                  /*RichChangedLanguage(text:
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.end,
                                      //
                                      softWrap: true,
                                      maxLines: 1,
                                      textScaleFactor: 1,
                                      text: TextSpan(
                                        text: 'Confidence  : ',
                                        style:
                                            const TextStyle(color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                              //text: "${(widget.confidence*100).toString().substring(0,6)}%",
                                              text: data[0]['confidence']
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),*/
                                  //ChangedLanguage(text:"View more -> ",style: TextStyle(color: Colors.orange),)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height(context) * 0.02,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: ChangedLanguage(text:"Nearest Predictions :",
                        //textAlign: //textAlign.start,
                        style: TextStyle(
                            color: Color(0XFF103E15),
                            fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: height(context) * 0.01,
                  ),
                  GestureDetector(
                    onTap: () {
                      getDiseases(1);
                    },
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Container(
                        // width: width(context) * 0.4,
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  ChangedLanguage(text:'Crop  : ',
                                    style: const TextStyle(color: Colors.black),),
                                  ChangedLanguage(text:data[1]['crop_name'],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))
                                ],),
                                /*RichChangedLanguage(text:
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.end,
                                    //
                                    softWrap: true,
                                    maxLines: 1,
                                    textScaleFactor: 1,
                                    text: TextSpan(
                                      text: 'Crop  : ',
                                      style: const TextStyle(color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: data[1]['crop_name'],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),*/
                                Row(children: [
                                  ChangedLanguage(text:'Diseases  : ',
                                    style: const TextStyle(color: Colors.black),),
                                  ChangedLanguage(text:data[1]['disease'],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))
                                ],),
                                /* RichChangedLanguage(text:
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.end,
                                    //
                                    softWrap: true,
                                    maxLines: 1,
                                    textScaleFactor: 1,
                                    text: TextSpan(
                                      text: 'Diseases  : ',
                                      style: const TextStyle(color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: data[1]['disease'],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),*/
                                Row(children: [
                                  ChangedLanguage(text:'Confidence  : ',
                                    style: const TextStyle(color: Colors.black),),
                                  ChangedLanguage(text:data[1]['confidence'].toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))
                                ],),
                              ],
                            ),
                            Container(
                              height: height(context) * 0.06,
                              width: height(context) * 0.06,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: MemoryImage(widget.image),
                                      fit: BoxFit.fill)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height(context) * 0.01,
                  ),
                  /* Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Container(
                      // width: width(context) * 0.4,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichChangedLanguage(text:
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.end,
                                //
                                softWrap: true,
                                maxLines: 1,
                                textScaleFactor: 1,
                                text: TextSpan(
                                  text: 'Crop  : ',
                                  style: const TextStyle(color: Colors.black),

                                  children:  <TextSpan>[
                                    TextSpan(
                                        text: data[index+2]['crop_name'],
                                        style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold)
                                    ),
                                  ],
                                ),
                              ),
                              RichChangedLanguage(text:
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.end,
                                //
                                softWrap: true,
                                maxLines: 1,
                                textScaleFactor: 1,
                                text: TextSpan(
                                  text: 'Diseases  : ',
                                  style: const TextStyle(color: Colors.black),

                                  children:  <TextSpan>[
                                    TextSpan(
                                        text: data[index+2]['disease'],
                                        style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold)
                                    ),
                                  ],
                                ),
                              ),
                              RichChangedLanguage(text:
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.end,
                                //
                                softWrap: true,
                                maxLines: 1,
                                textScaleFactor: 1,
                                text: TextSpan(
                                  text: 'Confidence  : ',
                                  style: const TextStyle(color: Colors.black),

                                  children:  <TextSpan>[
                                    TextSpan(
                                        text: data[index+2]['confidence'].toString(),
                                        style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold)
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: height(context) * 0.06,
                            width: height(context) * 0.06,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey
                            ),
                          )
                        ],
                      ),
                    ),
                  ),*/
                  Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height(context) * 0.04,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  [
                                ChangedLanguage(text:"Cause of disease :",textAlign: TextAlign.start,
                                    style: TextStyle(
                                      // color: Color(0xffECB34F),
                                        color: Color(0XFF103E15),
                                        fontWeight: FontWeight.w700)),
                                Icon(!causeRunning?Icons.mic_outlined:Icons.pause).onTap(()async{
                                  //translatedString = await changeLanguage(widget.data.preventiveMeasures, language);
                                  if(!causeRunning){
                                    setState(() {
                                      symptomsRunning = false;
                                      causeRunning = true;

                                      chemicalRunning = false;
                                      organicRunning = false;

                                    });
                                    speak(firstHalf + secondHalf);
                                  }else{
                                    setState((){
                                      causeRunning = false;
                                      tts.stop();
                                    });
                                  }
                                }),
                              ],
                            ),
                          ),
                          secondHalf.isEmpty
                              ? ChangedLanguage(text:firstHalf,textAlign: TextAlign.justify,)
                              : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ChangedLanguage(text:
                              flag
                                  ? (firstHalf + "...")
                                  : (firstHalf + secondHalf),
                                textAlign: TextAlign.justify,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    flag = !flag;
                                  });
                                },
                                child: ChangedLanguage(text:
                                flag ? "read more" : "show less",
                                  style:
                                  const TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 15,
                            thickness: 1,
                          ),
                          SizedBox(
                            height: height(context) * 0.04,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  [
                                ChangedLanguage(text:"Symptoms :",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xffECB34F),
                                        fontWeight: FontWeight.w700)),
                                Icon(!symptomsRunning?Icons.mic_outlined:Icons.pause).onTap(()async{
                                  //translatedString = await changeLanguage(widget.data.preventiveMeasures, language);
                                  if(!symptomsRunning){
                                    setState(() {
                                      symptomsRunning = true;
                                      causeRunning = false;

                                      chemicalRunning = false;
                                      organicRunning = false;

                                    });
                                    speak(firstHalf1 + secondHalf1);
                                  }else{
                                    setState((){
                                      symptomsRunning = false;
                                      tts.stop();
                                    });

                                  }


                                }),
                              ],
                            ),
                          ),
                          secondHalf1.isEmpty
                              ? Text(firstHalf1,textAlign: TextAlign.justify,)
                              : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                flag1
                                    ? (firstHalf1 + "...")
                                    : (firstHalf1 + secondHalf1),
                                textAlign: TextAlign.justify,
                                style:
                                const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    flag1 = !flag1;
                                  });
                                },
                                child: Text(
                                  flag1 ? "read more" : "show less",
                                  style:
                                  const TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 15,
                            thickness: 1,
                          ),
                          SizedBox(
                            height: height(context) * 0.04,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ChangedLanguage(text:"Organic Control :",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xffECB34F),
                                        fontWeight: FontWeight.w700)),
                                Icon(!organicRunning?Icons.mic_outlined:Icons.pause).onTap(()async{
                                  //translatedString = await changeLanguage(widget.data.preventiveMeasures, language);
                                  if(!organicRunning){
                                    setState(() {
                                      symptomsRunning = false;
                                      causeRunning = false;

                                      chemicalRunning = false;
                                      organicRunning = true;

                                    });
                                    speak(firstHalf2 + secondHalf2);
                                  }else{
                                    setState((){
                                      organicRunning = false;
                                      tts.stop();
                                    });

                                  }


                                }),
                              ],
                            ),
                          ),
                          secondHalf2.isEmpty
                              ? Text(firstHalf2,textAlign: TextAlign.justify,)
                              : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                flag2
                                    ? (firstHalf2 + "...")
                                    : (firstHalf2 + secondHalf2),
                                textAlign: TextAlign.justify,
                                style:
                                const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    flag2 = !flag2;
                                  });
                                },
                                child: Text(
                                  flag2 ? "read more" : "show less",
                                  style:
                                  const TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 15,
                            thickness: 1,
                          ),
                          SizedBox(
                            height: height(context) * 0.04,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  [
                                ChangedLanguage(text:"Chemical Control :",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xffECB34F),
                                        fontWeight: FontWeight.w700)),
                                Icon(!chemicalRunning?Icons.mic_outlined:Icons.pause).onTap(()async{
                                  //translatedString = await changeLanguage(widget.data.preventiveMeasures, language);
                                  if(!chemicalRunning){
                                    setState(() {
                                      symptomsRunning = false;
                                      causeRunning = false;

                                      chemicalRunning = true;
                                      organicRunning = false;

                                    });
                                    speak(firstHalf3 + secondHalf3);
                                  }else{
                                    setState((){
                                      chemicalRunning = false;
                                      tts.stop();
                                    });
                                  }
                                }),
                              ],
                            ),
                          ),
                          secondHalf3.isEmpty
                              ? Text(firstHalf3)
                              : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                flag3
                                    ? (firstHalf3 + "...")
                                    : (firstHalf3 + secondHalf3),
                                textAlign: TextAlign.justify,
                                style:
                                const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    flag3 = !flag3;
                                  });
                                },
                                child: Text(
                                  flag3 ? "read more" : "show less",
                                  style:
                                  const TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ))
            : Loading(),
      ),
    );
  }
}