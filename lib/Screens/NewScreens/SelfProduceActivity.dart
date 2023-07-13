import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart' as path;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:translator/translator.dart';

import '../../constants/constants.dart';
import '../constant/Constant.dart';

class SelfProduce extends StatefulWidget {
  final email,phone;
  const SelfProduce({Key key, this.email, this.phone}) : super(key: key);

  @override
  State<SelfProduce> createState() => _SelfProduceState();
}

class _SelfProduceState extends State<SelfProduce> {
  //FirebaseStorage _storage = FirebaseStorage.instance;
  //FirebaseStorage _storage = FirebaseStorage.instance;
  File _photo;
  final ImagePicker _picker = ImagePicker();
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  String imageUrl = "";
  String imageUrl1 = "";
  /*Future<Uri>*/ /*uploadPic() async {

    //Get the file from the image picker and store it
    try{

    }catch()
    var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);


    Reference reference = _storage.ref(image.path);

     TaskSnapshot snapshot = await reference.putFile(File(image.path));

    final downloadUrl = await snapshot.ref.getDownloadURL();
    print(downloadUrl);


    // uploadTask.then((res) async {
    //   print(await res.ref.getDownloadURL());
    //   res.ref.getDownloadURL();
    // });


    // Waits till the file is uploaded then stores the download url
    //Uri location = (await uploadTask.future).downloadUrl;

    //returns the download url
    //return location;
  }*/
  DateTime selectedDate;
  Uint8List image1, image2;
  bool varietyValidate = true,
      quantityValidate = true,
      priceValidate = true,
      noteValidate = true;
  List<String> cropList = [];
  FocusNode cropFocusNode, weightNode = FocusNode();
  String cropValue,
      _setDate = '',
      weightType = 'kg',
      varietyHint = 'Variety of Product',
      varietyRequired = 'Variety is Required',
      api_key,
      phone_number,
      email,
      typeOfCrop,
      variety,
      note;
  CollectionReference sellProduce =
      FirebaseFirestore.instance.collection('Sell_Produce');

  int expectedQuantity, price;
  TextEditingController varietyController = TextEditingController(),
      quantityController = TextEditingController(),
      priceController = TextEditingController(),
      noteController = TextEditingController();

  getCrops() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    api_key = prefs.getString('api_key');
    phone_number = widget.phone;
    email = widget.email;
    // varietyHint = await changeLanguage("Variety of Product");
    // varietyRequired = await changeLanguage('Variety is Required');
    // var response = await http.get(Uri.parse("https://api.mapmycrop.com/farm/add-crop?api_key=$api_key&farm_id=33625bb0963543f996268d3fb83af221"));
    var response = await http
        .get(Uri.parse("https://api.mapmycrop.com/crop/?api_key=$api_key"));
    var cropData = jsonDecode(response.body);
    print(cropData);
    for (int i = 0; i < cropData.length; i++) {
      setState(() {
        cropList.add(cropData[i]['name']);
      });
    }
    //print(cropList);
  }
  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }
  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile1();
      } else {
        print('No image selected.');
      }
    });
  }


  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = path.basename(_photo.path);
    final destination = 'files/$fileName';
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');

      await ref.putFile(_photo);
      print('operation successfull ${ref.fullPath}');

      //   final storageRef = firebase_storage.FirebaseStorage.instance.ref();

      final imageUrl = await ref.getDownloadURL();
      print('ulpload successfull here '+imageUrl);
      setState(() {
        this.imageUrl = imageUrl;
      });

    } catch (e) {
      print('error occured');
    }

  }
  Future uploadFile1() async {
    if (_photo == null) return;
    final fileName = path.basename(_photo.path);
    final destination = 'files/$fileName';
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');

      await ref.putFile(_photo);
      print('operation successfull ${ref.fullPath}');

      //   final storageRef = firebase_storage.FirebaseStorage.instance.ref();

      final imageUrl = await ref.getDownloadURL();
      print('ulpload successfull here '+imageUrl);
      setState(() {
        imageUrl1 = imageUrl;
      });

    } catch (e) {
      print('error occured');
    }

  }
  /*Future uploadFile() async {
    if (_photo == null) return;
    final fileName = path.basename(_photo.path);
    final destination = '$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo).then((p0) => print(p0));
      print('operation successfull');

    } catch (e) {
      print('error occured');
    }
  }
*/
  void imageSelectorCamera(imageSource) async {
    var image = await ImagePicker().pickImage(source: imageSource);
    var imageBytes = await image.readAsBytes();
    print(imageBytes);
  }

  @override
  void initState() {
    // TODO: implement initState
    getCrops();
    super.initState();
  }

  Future<void> addSellProduce() {

    DateTime currentTime = DateTime.now();
    String stringTime = currentTime.toString();
    //print(stringTime.substring(0,stringTime.length-7));
    stringTime = stringTime.substring(0,stringTime.length-7);
    // Calling the collection to add a new user
    return sellProduce
        //adding to firebase collection
        .add({
      //Data added in the form of a dictionary into the document.
      'api_key': api_key,
      'crop': cropValue,
      'email': email??'Not specified',
      'phone': phone_number??'Not specified',
      'variety': varietyController.text,
      'quantity': quantityController.text+weightType,
      'price': priceController.text+"/kg",
      'note': noteController.text,
      'image1': imageUrl1,
      'image2': imageUrl,
      'updationTime': stringTime

    }).then((value) async {
      print("Sell produce data Added $value");
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: await changeLanguage('Produce added Successfully'),
        confirmBtnText:'Ok',
        onConfirmBtnTap:(){
          varietyController.clear();
          quantityController.clear();
          priceController.clear();
          noteController.clear();
          Navigator.pop(context);
        }
      );
    }).catchError((error) => print(" failed with this error $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xffECB34F),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/new_images/back.png')),
        title: const ChangedLanguage(
          text: "Add Produce",
           style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          /*fontFamily: "Inter"*/
          fontWeight: FontWeight.w600,
        ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChangedLanguage(
                    text: 'Type of Crop',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  //SizedBox(height: 15,),
                  Container(
                      margin: const EdgeInsets.only(bottom: 15, top: 5),
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          // side: BorderSide(
                          //     width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          focusNode: cropFocusNode,
                          menuMaxHeight: 400,
                          hint: const Center(
                              child: ChangedLanguage(text: 'Select Crop')),
                          value: cropValue,
                          elevation: 25,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: cropList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Center(
                                  child: ChangedLanguage(
                                text: value,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              )),
                            );
                          }).toList(),
                          onChanged: (String newvalue) {
                            setState(() {
                              // int index = cropList.indexOf(newvalue);
                              cropValue = newvalue;
                              //farm = farmIdList[index];
                            });
                          },
                        ),
                      )
                      //: Center(child: CircularProgressIndicator()),
                      ),
                  const ChangedLanguage(
                    text: 'Variety',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 10,
                    ),
                    height: 70.0,
                    child: CustomTextField(
                        //validator: _validateName,
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.text,
                        controller: varietyController,
                        hintText:
                            varietyValidate ? varietyHint : varietyRequired,
                        //varietyValidate?"Variety of Product":'Variety is Required',
                        hintStyle: varietyValidate
                            ? const TextStyle(color: Colors.black)
                            : const TextStyle(color: Colors.red)
                        // focusedBorder: OutlineInputBorder(
                        //     // borderSide: BorderSide(color: Colors.black),
                        //     borderRadius: BorderRadius.all(Radius.circular(10))),
                        // enabledBorder: OutlineInputBorder(
                        //     borderSide: BorderSide(color: Colors.black),
                        //     borderRadius: BorderRadius.all(Radius.circular(10))),
                        // hintText: _commentvalidate?'Comments':'Comment required',
                        //hintStyle: TextStyle(color: _commentvalidate?Colors.black:Colors.red),
                        // labelText: 'Comments',
                        // floatingLabelBehavior: FloatingLabelBehavior.auto
                        ),
                  ),
                  const ChangedLanguage(
                    text: "Expected Quantity",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: width(context) * 0.5,
                          child: CustomTextField(
                              //validator: _validateName,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.number,
                              controller: quantityController,
                              //hintText:"Quantity",
                              hintText: quantityValidate
                                  ? "Quantity"
                                  : 'Quantity is Required',
                              hintStyle: quantityValidate
                                  ? const TextStyle()
                                  : const TextStyle(color: Colors.red)
                              // focusedBorder: OutlineInputBorder(
                              //     // borderSide: BorderSide(color: Colors.black),
                              //     borderRadius: BorderRadius.all(Radius.circular(10))),
                              // enabledBorder: OutlineInputBorder(
                              //     borderSide: BorderSide(color: Colors.black),
                              //     borderRadius: BorderRadius.all(Radius.circular(10))),
                              // hintText: _commentvalidate?'Comments':'Comment required',
                              //hintStyle: TextStyle(color: _commentvalidate?Colors.black:Colors.red),
                              // labelText: 'Comments',
                              // floatingLabelBehavior: FloatingLabelBehavior.auto
                              ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              focusNode: weightNode,
                              hint: const Center(
                                  child:
                                      ChangedLanguage(text: 'Select Weight')),
                              value: weightType,
                              elevation: 25,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              items: ["kg", "gm"].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Center(
                                      child: ChangedLanguage(
                                    text: value,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  )),
                                );
                              }).toList(),
                              onChanged: (String newvalue) {
                                print(newvalue);
                                setState(() {
                                  weightType = newvalue;
                                  //print(weightType);
                                  // int index = cropList.indexOf(newvalue);
                                  //farm = farmIdList[index];
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  /* Row(
                    children: [
                      Text("Availability"),
                      Text('Available Days')
                    ],
                  ),*/
                  /*Row(
                    children: [
                      Container(
                        width: width(context)*0.4,
                        margin: EdgeInsets.only(left: 50.0, right: 30.0),
                        height: 70.0,
                        child: InkWell(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: TextFormField(
                            style: TextStyle(fontSize: 17, color: Colors.black),
                            textAlign: TextAlign.center,
                            enabled: false,
                            keyboardType: TextInputType.text,
                            controller: _dateController,
                            onChanged: (String val){
                              _setDate = val;
                              print('value of date is $_setDate');

                            },
                            onSaved: (String val) {
                              _setDate = val;
                            },
                            decoration: InputDecoration(
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                // labelText: 'Choose Date',
                                // floatingLabelBehavior: FloatingLabelBehavior.auto,
                                labelText: 'Choose Date',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: "Open Sans",
                                  fontWeight: FontWeight.w600,
                                ),
                                contentPadding: EdgeInsets.all(5)),
                          ),
                        ),
                      )
                      ,
                      Container(
                        width: width(context)*0.4,

                        // padding:
                        // EdgeInsets.only(top: 10, bottom: 10, left: 50, right: 50),
                        height: 70.0,
                        child: TextFormField(
                          //validator: _validateName,
                          style: new TextStyle(color: Colors.black),
                          keyboardType: TextInputType.text,
                          controller: varietyController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            // focusedBorder: OutlineInputBorder(
                            //   // borderSide: BorderSide(color: Colors.black),
                            //     borderRadius: BorderRadius.all(Radius.circular(10))),
                            // enabledBorder: OutlineInputBorder(
                            //     borderSide: BorderSide(color: Colors.black),
                            //     borderRadius: BorderRadius.all(Radius.circular(10))),
                            // hintText: _commentvalidate?'Comments':'Comment required',
                            //hintStyle: TextStyle(color: _commentvalidate?Colors.black:Colors.red),
                            // labelText: 'Comments',
                            // floatingLabelBehavior: FloatingLabelBehavior.auto
                          ),

                        ),
                      ),


                    ],
                  ),*/
                  const ChangedLanguage(
                    text: 'Price (per Kg)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 15),

                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    //height: 70.0,
                    child: CustomTextField(
                        //validator: _validateName,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.number,
                        controller: priceController,
                        // decoration: InputDecoration(
                        //   fillColor: Colors.white,
                        //   filled: true,
                        //hintText: "Type your price"
                        hintText: priceValidate
                            ? "Type your price"
                            : 'Price is Required',
                        hintStyle: priceValidate
                            ? const TextStyle()
                            : const TextStyle(color: Colors.red)
                        // focusedBorder: OutlineInputBorder(
                        //   // borderSide: BorderSide(color: Colors.black),
                        //     borderRadius: BorderRadius.all(Radius.circular(10))),
                        // enabledBorder: OutlineInputBorder(
                        //     borderSide: BorderSide(color: Colors.black),
                        //     borderRadius: BorderRadius.all(Radius.circular(10))),
                        // hintText: _commentvalidate?'Comments':'Comment required',
                        //hintStyle: TextStyle(color: _commentvalidate?Colors.black:Colors.red),
                        // labelText: 'Comments',
                        // floatingLabelBehavior: FloatingLabelBehavior.auto
                        // ),

                        ),
                  ),
                  const ChangedLanguage(
                    text: 'Note',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    height: 70.0,
                    child: CustomTextField(
                        //validator: _validateName,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.text,
                        controller: noteController,
                        // decoration: InputDecoration(
                        //   fillColor: Colors.white,
                        //   filled: true,
                        // hintText: 'Write something',
                        hintText: noteValidate
                            ? "Write something"
                            : 'Note is Required',
                        hintStyle: noteValidate
                            ? const TextStyle()
                            : const TextStyle(color: Colors.red)

                        // enabledBorder: OutlineInputBorder(
                        //     borderSide: BorderSide(color: Colors.black),
                        //     borderRadius: BorderRadius.all(Radius.circular(10))),
                        // hintText: _commentvalidate?'Comments':'Comment required',
                        //hintStyle: TextStyle(color: _commentvalidate?Colors.black:Colors.red),
                        // labelText: 'Comments',
                        // floatingLabelBehavior: FloatingLabelBehavior.auto
                        // ),

                        ),
                  ),
                  const ChangedLanguage(
                    text: 'Images',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          await imgFromCamera();
                         /* var image = await ImagePicker()
                              .pickImage(source: ImageSource.camera);
                          var imageBytes = await image.readAsBytes();
                          setState(() {
                            image1 = imageBytes;
                          });
                          print(imageBytes);*/
                          //uploadPic();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            child: SizedBox(
                              width: width(context) * 0.43,
                              height: width(context) * 0.33,
                              child: Column(
                                children: <Widget>[
                                  imageUrl1.isEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image.asset(
                                            "assets/images/addimage.png",
                                            width: width(context) * 0.33,
                                            height: width(context) * 0.2,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image.network(
                                            imageUrl1,
                                            width: width(context) * 0.33,
                                            height: width(context) * 0.2,
                                          ),
                                        ),
                                  const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: ChangedLanguage(
                                        text: "Image1",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          imgFromGallery();
                         /* var image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          var imageBytes = await image.readAsBytes();
                          print(imageBytes);
                          setState(() {
                            image2 = imageBytes;
                          });*/
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            child: Container(
                              width: width(context) * 0.43,
                              height: width(context) * 0.33,
                              child: Column(
                                children: <Widget>[
                                  imageUrl.isEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image.asset(
                                            "assets/images/addimage.png",
                                            width: width(context) * 0.33,
                                            height: width(context) * 0.2,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image.network(
                                            imageUrl,
                                            width: width(context) * 0.33,
                                            height: width(context) * 0.2,
                                          ),
                                        ),
                                  const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: ChangedLanguage(
                                        text: "Image2",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height(context) * 0.06)
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              print(
                  'variety : ${varietyController.text} \n quantity : ${quantityController.text} \nprice : ${priceController.text} \n note : ${noteController.text} \ncrop : $cropValue \n');
              if (varietyController.text == null ||
                  varietyController.text.isEmpty) {
                setState(() {
                  varietyValidate = false;
                  varietyController.text = '';
                });
              }
              if (quantityController.text == null ||
                  quantityController.text.isEmpty) {
                setState(() {
                  quantityValidate = false;
                  quantityController.text = '';
                });
              }
              if (priceController.text == null || priceController.text.isEmpty) {
                setState(() {
                  priceValidate = false;
                  priceController.text = '';
                });
              }
              if (noteController.text == null || noteController.text.isEmpty) {
                setState(() {
                  noteValidate = false;
                  noteController.text = '';
                });
              }
              if ((cropValue == null) &&
                  (noteController.text == null || noteController.text.isEmpty) &&
                  (priceController.text == null ||
                      priceController.text.isEmpty) &&
                  (quantityController.text == null ||
                      quantityController.text.isEmpty) &&
                  (varietyController.text == null ||
                      varietyController.text.isEmpty)) {
                print('error');
              } else {
                addSellProduce();
                FirebaseAnalytics.instance.logEvent(
                  name: "crop_added",
                  parameters: {
                    "content_type": "Activity_planned",
                    "api_key": api_key,
                    "variety": varietyController.text
                  },
                ).onError((error, stackTrace) => print('analytics error is $error'));
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              height: 45.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xffECB34F),
              ),
              //padding: const EdgeInsets.only(left: 91, right: 122, top: 20, bottom: 19, ),
              child:  Center(
                child: ChangedLanguage(text:
                "Add my Produce",
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
         /* Container(
            width: width(context)*0.98,
            height: height(context) * 0.06,
            color: const Color(0xffECB34F),
            child: const Center(
                child: ChangedLanguage(
              text: 'Add My Produce',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'San Fransisco',
                  fontSize: 25),
            )),
          ).onTap(() {
            print(
                'variety : ${varietyController.text} \n quantity : ${quantityController.text} \nprice : ${priceController.text} \n note : ${noteController.text} \ncrop : $cropValue \n');
            if (varietyController.text == null ||
                varietyController.text.isEmpty) {
              setState(() {
                varietyValidate = false;
                varietyController.text = '';
              });
            }
            if (quantityController.text == null ||
                quantityController.text.isEmpty) {
              setState(() {
                quantityValidate = false;
                quantityController.text = '';
              });
            }
            if (priceController.text == null || priceController.text.isEmpty) {
              setState(() {
                priceValidate = false;
                priceController.text = '';
              });
            }
            if (noteController.text == null || noteController.text.isEmpty) {
              setState(() {
                noteValidate = false;
                noteController.text = '';
              });
            }
            if ((cropValue == null) &&
                (noteController.text == null || noteController.text.isEmpty) &&
                (priceController.text == null ||
                    priceController.text.isEmpty) &&
                (quantityController.text == null ||
                    quantityController.text.isEmpty) &&
                (varietyController.text == null ||
                    varietyController.text.isEmpty)) {
              print('error');
            } else {
              addSellProduce();
            }
          })*/
        ],
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key key,
      this.controller,
      this.hintText,
      this.hintStyle,
      this.style,
      this.keyboardType, this.focusedBorder, this.enabledBorder, this.onSaved})
      : super(key: key);
  final controller, hintText, hintStyle, style, keyboardType,focusedBorder,enabledBorder,onSaved;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String newHintText = '';
  SharedPreferences prefs;
  changedLanguage() async {
    setState(() {
      newHintText = widget.hintText;
    });
    //print(text);
    prefs = await SharedPreferences.getInstance();
    // //print('called with $language');
    final translator = GoogleTranslator();
    //final input = text;

    ////print('The text is $text and the language is ${prefs.getString("language")}');
    // Using the Future API
    await translator
        .translate(widget.hintText, to: prefs.getString('language'))
        .then((result) {
      print(result);
      // //print("Source: $text\nTranslated: $result");
      setState(() {
        newHintText = "$result";
      });
    });
    ////print(finalResult);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('hello');
    changedLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //validator: _validateName,
      style: widget.style,
      keyboardType: widget.keyboardType,

      controller: widget.controller,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: newHintText,
          //varietyValidate?"Variety of Product":'Variety is Required',
          hintStyle: widget.hintStyle,
          focusedBorder: widget.focusedBorder,
          enabledBorder: widget.enabledBorder,
          // hintText: _commentvalidate?'Comments':'Comment required',
          //hintStyle: TextStyle(color: _commentvalidate?Colors.black:Colors.red),
          // labelText: 'Comments',
          // floatingLabelBehavior: FloatingLabelBehavior.auto
          ),
    );
  }
}
