import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mmc_master/Widgets/Loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Authentication/otpScreen.dart';
import '../../constants/constants.dart';
import '../../generated/l10n.dart';
import 'CropDetails.dart';

import 'package:http_parser/http_parser.dart';

class DiseaseDetectionActivity extends StatefulWidget {
  const DiseaseDetectionActivity({Key key}) : super(key: key);

  @override
  State<DiseaseDetectionActivity> createState() => _DiseaseDetectionActivityState();
}

class _DiseaseDetectionActivityState extends State<DiseaseDetectionActivity> {
  @override

  bool isLoading = false;

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        backgroundColor: Color(0xffECB34F),
        title: ChangedLanguage(text:
          S.of(context).disease,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            /*fontFamily: "Inter"*/
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/new_images/back.png')),
      ),
      body:Container(
        child:Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              height:size.height*0.30,
              width: size.width,
              child: Container(
                //width: 150,
                //height: 150,
                padding: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://camo.githubusercontent.com/2e6409aac9d5b37bd902588bff883ac4ecf1b97a3294cef0fdbe2d013e62cf07/68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f3830302f312a49624a465f366d52544d734739674c306a38757a35512e6a706567'),//AssetImage('assets/images/.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                    child: ChangedLanguage(text:'Submit picture of your crop related problems & get Solutions !',
                      style:TextStyle(color: Colors.white),//textAlign: TextAlign.center
                    )
                ),
              ),
            ),
            Positioned(
              top: size.height*0.18,
              left:size.width*0.05,
              width: size.width*0.90,
              //height: size.height*0.35,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10.0,
                      spreadRadius: 0.0,
                      offset: Offset(2.0, 5.0),
                    ),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 0.0,
                  margin: EdgeInsets.all(12.0),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color(0xffECB34F),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: IconButton(
                          iconSize: 30,
                          icon: const Icon(
                            FontAwesomeIcons.camera,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            getDisease(ImageSource.camera);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChangedLanguage(text:'Take Picture'),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color(0xffECB34F),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: IconButton(
                          iconSize: 30,
                          icon: const Icon(
                            FontAwesomeIcons.fileAlt,
                            color: Colors.white,
                          ),
                          onPressed: () async {

                            getDisease(ImageSource.gallery);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChangedLanguage(text:'Select from gallary'),
                      ),
                    ],
                  )
                ),
              ),
            ),
            // Visibility(
            //   visible:!isLoading,
            //   child: Positioned(
            //     top: size.height*0.60,
            //     left:size.width*0.05,
            //     width: size.width*0.90,
            //     height: size.height*0.08,
            //     child:Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children:  [
            //         ChangedLanguage(text:'Loading...', style: TextStyle(fontSize: 20),),
            //         SizedBox(width: 10,),
            //         Loading(),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  getDisease(ImageSource imageSource) async {
    var image = await ImagePicker().pickImage(source: imageSource);
    var imageBytes = await image.readAsBytes();
    var responseValue = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var api_key = prefs.getString('api_key');
    var request = http.MultipartRequest('POST', Uri.parse(
        'https://api.mapmycrop.com/ai/detect-disease?api_key=$api_key'));

    request.files.add(await http.MultipartFile.fromPath('image', image.path, contentType: MediaType("image", 'png')));
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) async {
      //print(value);
      setState(() {
        responseValue= value;
      });
      if(value.isNotEmpty){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CropDetails(data:responseValue,image:imageBytes)));
      }
    });
    /*if(responseValue.isNotEmpty){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CropDetails(data:responseValue)));
    }*/
  }
}
