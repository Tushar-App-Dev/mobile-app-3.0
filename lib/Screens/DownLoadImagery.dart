import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mmc_master/Screens/schedule_call.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Widgets/Loading.dart';

class DownLoadImagery extends StatefulWidget {
  const DownLoadImagery({Key key}) : super(key: key);

  @override
  _DownLoadImageryState createState() => _DownLoadImageryState();
}

class _DownLoadImageryState extends State<DownLoadImagery> {
  final Dio dio = Dio();
  bool loading = false;
  bool load = false;
  double progress = 0;
  String uid;
  var idValue;
  var startdate, enddate;
  final startdateController = TextEditingController();
  final enddateController = TextEditingController();
  // List<String> PolyIdList = [];
  List<String> FarmIdList = [];
  var _isFormVisible = false;
  bool _isDataUploaded = false;
  Future<HealthModel> futureData;
  var POLY_ID, START_DATE, END_DATE;
  GlobalKey<FormState> _key = new GlobalKey();
  String EmailDropDownValue;
  List<Map> PolyIdList=[];

  @override
  void initState() {
    fetchFarmData();
    super.initState();
  }

  void fetchFarmData() async {
    var data,polydata;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('userID');

    var uri =
    Uri.parse("https://app.mapmycrop.com/handler/data_manager.php"); //
    var request = new http.MultipartRequest("POST", uri);
    request.fields['uid'] = uid;
    request.fields['type'] = "GET";
    print(request);
    var response = await request.send();

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) async {
        data = jsonDecode(value);
        // print(data);
        var dataValue = data["DATA_VALUE"];
        setState(() {
          for (var i = 0; i < dataValue.length; i++) {
            polydata=dataValue[i];
            PolyIdList.add(polydata);
            print(PolyIdList);
          }
        });
      });
    }
  }

  Future<HealthModel> getImageryData() async {
    final response = await http.get(Uri.parse(
        'https://api.agromonitoring.com/agro/1.0/image/search?polyid=$POLY_ID&start=$START_DATE&end=$END_DATE&appid=ecca51ccd6bec9eacecb4749dfd3ec3f'));
    if (response.statusCode == 200) {
      final jsonresponse = json.decode(response.body);
      print(jsonresponse[0]);

      return HealthModel.fromJson(jsonresponse[0]);
      //Health.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<bool> saveImage(String url, String fileName) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Download") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/MMCApp";
          directory = Directory(newPath);
          print(directory.path);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      File saveFile = File(directory.path + "/$fileName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await dio.download(url, saveFile.path,
            onReceiveProgress: (value1, value2) {
              setState(() {
                progress = value1 / value2;
              });
            });
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  _save(String url, String name,) async {
    var response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 80,
        name: name);
    print(result);
    if(result['isSuccess']==true){
      Fluttertoast.showToast(
          msg: "File Downloaded", toastLength: Toast.LENGTH_LONG);
    }else{
      Fluttertoast.showToast(
          msg: "Problem Downloading File", toastLength: Toast.LENGTH_LONG);
    }
  }

  downloadFile(String imageUrl, String imagename) async {
    setState(() {
      load = true;
      progress = 0;
    });
    bool downloaded =
    await saveImage(imageUrl, '$imagename.png');
    if (downloaded) {
      Fluttertoast.showToast(
          msg: "File Downloaded", toastLength: Toast.LENGTH_LONG);
      print("File Downloaded");
    } else {
      print("Problem Downloading File");
    }
    setState(() {
      load = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          // physics: BouncingScrollPhysics(),
          child: Form(
            child: formUI(),
            key: _key,
          ),
        ),
      ),
    );
  }

  Widget formUI() {
    var scrWidth = MediaQuery
        .of(context)
        .size
        .width;
    var scrHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () { Navigator.pop(context); },
                      icon: Icon(FontAwesomeIcons.arrowLeft),
                    ),
                    Text(
                      'Download Imagery',
                      style: TextStyle(
                        fontFamily: 'Cardo',
                        fontSize: 23,
                        color: Color(0xff0C2551),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            ModalProgressHUD(
              inAsyncCall: _isDataUploaded,
              child: SingleChildScrollView(
                child: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Visibility(
                          visible: !_isFormVisible,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        width: 120.0,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.white))),
                                        height: 40.0,
                                        child: TextField(
                                          readOnly: true,
                                          controller: startdateController,
                                          style: new TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                            //hintText: 'Start Date',
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black),
                                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black),
                                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                                              // floatingLabelAlignment: FloatingLabelAlignment.start,
                                              label:Text('Start Date'),
                                              labelStyle:TextStyle(color: Colors.black)
                                          ),
                                          onTap: () async {
                                            var date = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2100));
                                            startdateController.text =
                                                date.toString().substring(0, 10);
                                            START_DATE = date.millisecondsSinceEpoch
                                                .toString()
                                                .substring(0, 10);
                                            print(START_DATE);
                                          },
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        width: 120.0,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.white))),
                                        height: 40.0,
                                        child: TextField(
                                          readOnly: true,
                                          controller: enddateController,
                                          style: new TextStyle(color: Colors.black),
                                          decoration:
                                          InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black),
                                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black),
                                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                                              //hintText: 'End Date',
                                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                                              label:Text('End Date'),
                                              labelStyle:TextStyle(color: Colors.black)
                                          ),
                                          onTap: () async {
                                            var date = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2100));
                                            enddateController.text =
                                                date.toString().substring(0, 10);
                                            END_DATE = date.millisecondsSinceEpoch
                                                .toString()
                                                .substring(0, 10);
                                            print(END_DATE);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                 margin: EdgeInsets.symmetric(horizontal: 40.0,vertical: 12.0),
                                    height: 50.0,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1.0, style: BorderStyle.solid),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                    ),
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton<String>(
                                      isDense: true,
                                      hint: new Text("Select Farm"),
                                      value: POLY_ID,
                                      onChanged: (String newValue) {
                                        setState(() {
                                          POLY_ID = newValue;
                                        });

                                        print(POLY_ID);
                                      },
                                      items: PolyIdList.map((Map map) {
                                        return new DropdownMenuItem<String>(
                                          value: map["ACTION"].toString(),
                                          // value: _mySelection,
                                          child: Row(
                                            children: <Widget>[
                                              // Image.asset(
                                              //   map["image"],
                                              //   width: 25,
                                              // ),
                                              Container(
                                                  margin: EdgeInsets.only(left: 10),
                                                  child: Text(map["NAME"])),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0,left: 20.0),
                          child: Divider(color:Colors.blueGrey),
                        ),
                        Visibility(
                          visible: !_isFormVisible,
                          child: Container(
                            padding:EdgeInsets.symmetric(horizontal: 10.0),
                            child:FutureBuilder<HealthModel>(
                              future: getImageryData(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Stack(
                                      children:[
                                        Column(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children:[
                                              Container(
                                                padding: EdgeInsets.only(top: 10, bottom: 10,left:30,right: 30),
                                                height: 70.0,
                                                child: TextFormField(
                                                  // validator: _validateFirstName,
                                                  readOnly: true,
                                                  keyboardType:
                                                  TextInputType.text,
                                                  textInputAction:
                                                  TextInputAction.next,
                                                  maxLines: 1,
                                                  style: new TextStyle(
                                                      color: Colors.black),
                                                  initialValue: DateTime.fromMillisecondsSinceEpoch(snapshot.data.dt*1000).toString(),//snapshot.data.dt.toString(),
                                                  decoration: InputDecoration(
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                              Colors.black),
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                              Colors.black),
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(10))),
                                                      labelStyle: TextStyle(color: Colors.black),
                                                      labelText: "DATE"),
                                                  onSaved: (String val) {
                                                    setState(() {
                                                    });
                                                  },
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(top: 10, bottom: 10,left:30,right: 30),
                                                height: 70.0,
                                                child: TextFormField(
                                                  // validator: _validateFirstName,
                                                  readOnly: true,
                                                  keyboardType:
                                                  TextInputType.text,
                                                  textInputAction:
                                                  TextInputAction.next,
                                                  maxLines: 1,
                                                  style: new TextStyle(
                                                      color: Colors.black),
                                                  initialValue: snapshot.data.type.toString(),
                                                  decoration: InputDecoration(
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                              Colors.black),
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                              Colors.black),
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(10))),
                                                      labelStyle: TextStyle(color: Colors.black),
                                                      labelText: "SATELLITE"),
                                                  onSaved: (String val) {
                                                    setState(() {
                                                    });
                                                  },
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(top: 10, bottom: 10,left:30,right: 30),
                                                height: 70.0,
                                                child: TextFormField(
                                                  // validator: _validateFirstName,
                                                  readOnly: true,
                                                  keyboardType:
                                                  TextInputType.text,
                                                  textInputAction:
                                                  TextInputAction.next,
                                                  maxLines: 1,
                                                  style: new TextStyle(
                                                      color: Colors.black),
                                                  initialValue: snapshot.data.dc.toString(),
                                                  decoration: InputDecoration(
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                              Colors.black),
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                              Colors.black),
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(10))),
                                                      labelStyle: TextStyle(color: Colors.black),
                                                      labelText: "DATA"),
                                                  onSaved: (String val) {
                                                    setState(() {
                                                    });
                                                  },
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(top: 10, bottom: 10,left:30,right: 30),
                                                height: 70.0,
                                                child: TextFormField(
                                                  // validator: _validateFirstName,
                                                  readOnly: true,
                                                  keyboardType:
                                                  TextInputType.text,
                                                  textInputAction:
                                                  TextInputAction.next,
                                                  maxLines: 1,
                                                  style: new TextStyle(
                                                      color: Colors.black),
                                                  initialValue: snapshot.data.sun.elevation.toString(),
                                                  decoration: InputDecoration(
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                              Colors.black),
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                              Colors.black),
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(10))),
                                                      labelStyle: TextStyle(color: Colors.black),
                                                      labelText: "CLOUD"),
                                                  onSaved: (String val) {
                                                    setState(() {
                                                    });
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: 10.0,),
                                              Text('Download Images:',style: TextStyle(fontSize: 20.0),),
                                              SizedBox(height: 10.0,),
                                              load?Loading():
                                              Container(
                                                margin:EdgeInsets.symmetric(horizontal:15.0,vertical: 5.0),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Flexible(
                                                          flex:1,
                                                          child:MaterialButton(
                                                            onPressed: () {
                                                              _save(snapshot.data.image.truecolor,'truecolor_image_${POLY_ID}');
                                                            },
                                                            child:Text('True Color'),
                                                            color: Colors.green,
                                                            minWidth:100,
                                                          )
                                                      ),
                                                      Flexible(
                                                          flex:1,
                                                          child:MaterialButton(
                                                            onPressed: () {
                                                              _save(snapshot.data.image.falsecolor,'falsecolor_image_${POLY_ID}');
                                                            },
                                                            child:Text('False Color'),
                                                            color: Colors.green,
                                                            minWidth:100,
                                                          )
                                                      ),
                                                      Flexible(
                                                          flex:1,
                                                          child:MaterialButton(
                                                            onPressed: () {
                                                              _save(snapshot.data.image.evi,'evi_image_${POLY_ID}');
                                                            },
                                                            child:Text('EVI'),
                                                            color: Colors.green,
                                                            minWidth:100,
                                                          )
                                                      ),
                                                    ]
                                                ),
                                              ),
                                              Container(
                                                margin:EdgeInsets.symmetric(horizontal:15.0,vertical: 5.0),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Flexible(
                                                          flex:1,
                                                          child:MaterialButton(
                                                            onPressed: () {
                                                              _save(snapshot.data.image.ndvi,'ndvi_image_${POLY_ID}');
                                                            },
                                                            child:Text('NDVI'),
                                                            color: Colors.green,
                                                            minWidth:100,
                                                          )
                                                      ),
                                                      Flexible(
                                                          flex:1,
                                                          child:MaterialButton(
                                                            onPressed: () {
                                                              _save(snapshot.data.image.evi2,'evi2_image_${POLY_ID}');
                                                            },
                                                            child:Text('EVI2'),
                                                            color: Colors.green,
                                                            minWidth:100,
                                                          )
                                                      ),
                                                      Flexible(
                                                          flex:1,
                                                          child:MaterialButton(
                                                            onPressed: () {
                                                              _save(snapshot.data.image.ndwi,'ndwi_image_${POLY_ID}');
                                                            },
                                                            child:Text('NDWI'),
                                                            color: Colors.green,
                                                            minWidth:100,
                                                          )
                                                      ),
                                                    ]
                                                ),
                                              ),
                                              Container(
                                                margin:EdgeInsets.symmetric(horizontal:15.0,vertical: 5.0),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Flexible(
                                                          flex:1,
                                                          child:MaterialButton(
                                                            onPressed: () {
                                                              _save(snapshot.data.image.dswi,'dswi_image_${POLY_ID}');
                                                            },
                                                            child:Text('DSWI'),
                                                            color: Colors.green,
                                                            minWidth:100,
                                                          )
                                                      ),
                                                      Flexible(
                                                          flex:1,
                                                          child:MaterialButton(
                                                            onPressed: () {
                                                              _save(snapshot.data.image.nri,'nri_image_${POLY_ID}');
                                                            },
                                                            child:Text('NRI'),
                                                            color: Colors.green,
                                                            minWidth:100,
                                                          )
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ]
                                        ),
                                      ]
                                  );
                                }
                                return Container(
                                  height: 50.0,
                                    width: 50.0,
                                    color: Colors.grey[100],
                                    child: Loading()
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        ClipPath(
          clipper: InnerClippedPart(),
          child: Container(
            color: Colors.orange, //Color(0xff0c2551),
            width: scrWidth,
            height: scrHeight,
          ),
        ),
      ],
    );
  }
}


class HealthModel {
  int dt;
  String type;
  int dc;
  int cl;
  Sun sun;
  Images image;
  Images tile;
  Stats stats;
  Images data;

  HealthModel(
      {this.dt,
        this.type,
        this.dc,
        this.cl,
        this.sun,
        this.image,
        this.tile,
        this.stats,
        this.data});

  HealthModel.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    type = json['type'];
    dc = json['dc'];
    cl = json['cl'];
    sun = json['sun'] != null ? new Sun.fromJson(json['sun']) : null;
    image = json['image'] != null ? new Images.fromJson(json['image']) : null;
    tile = json['tile'] != null ? new Images.fromJson(json['tile']) : null;
    stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;
    data = json['data'] != null ? new Images.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dt'] = this.dt;
    data['type'] = this.type;
    data['dc'] = this.dc;
    data['cl'] = this.cl;
    if (this.sun != null) {
      data['sun'] = this.sun.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    if (this.tile != null) {
      data['tile'] = this.tile.toJson();
    }
    if (this.stats != null) {
      data['stats'] = this.stats.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Sun {
  double elevation;
  double azimuth;

  Sun({this.elevation, this.azimuth});

  Sun.fromJson(Map<String, dynamic> json) {
    elevation = json['elevation'];
    azimuth = json['azimuth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['elevation'] = this.elevation;
    data['azimuth'] = this.azimuth;
    return data;
  }
}

class Images {
  String truecolor;
  String falsecolor;
  String ndvi;
  String evi;
  String evi2;
  String nri;
  String dswi;
  String ndwi;

  Images(
      {this.truecolor,
        this.falsecolor,
        this.ndvi,
        this.evi,
        this.evi2,
        this.nri,
        this.dswi,
        this.ndwi});

  Images.fromJson(Map<String, dynamic> json) {
    truecolor = json['truecolor'];
    falsecolor = json['falsecolor'];
    ndvi = json['ndvi'];
    evi = json['evi'];
    evi2 = json['evi2'];
    nri = json['nri'];
    dswi = json['dswi'];
    ndwi = json['ndwi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['truecolor'] = this.truecolor;
    data['falsecolor'] = this.falsecolor;
    data['ndvi'] = this.ndvi;
    data['evi'] = this.evi;
    data['evi2'] = this.evi2;
    data['nri'] = this.nri;
    data['dswi'] = this.dswi;
    data['ndwi'] = this.ndwi;
    return data;
  }
}

class Stats {
  String ndvi;
  String evi;
  String evi2;
  String nri;
  String dswi;
  String ndwi;

  Stats({this.ndvi, this.evi, this.evi2, this.nri, this.dswi, this.ndwi});

  Stats.fromJson(Map<String, dynamic> json) {
    ndvi = json['ndvi'];
    evi = json['evi'];
    evi2 = json['evi2'];
    nri = json['nri'];
    dswi = json['dswi'];
    ndwi = json['ndwi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ndvi'] = this.ndvi;
    data['evi'] = this.evi;
    data['evi2'] = this.evi2;
    data['nri'] = this.nri;
    data['dswi'] = this.dswi;
    data['ndwi'] = this.ndwi;
    return data;
  }
}
