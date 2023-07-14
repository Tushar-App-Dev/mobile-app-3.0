import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';

class ScoutingActivityList extends StatefulWidget {
  @override
  _ScoutingActivityListState createState() => _ScoutingActivityListState();
}

class _ScoutingActivityListState extends State<ScoutingActivityList> {
  List data = [];
  var idValue, startdate, enddate;
  final startdateController = TextEditingController();
  final enddateController = TextEditingController();
  String uid, api_key;
  int selectedpage = 0;
  List<String> nameList = [];
  List<String> idList = [];
  List farmData =  [];
  List farmCoords= [];
  List note_type=[];
  List comments=[];
  List attachment=[];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    note_type.clear();
    comments.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      api_key = prefs.getString('api_key');
      print(api_key);
    });
    var response = await http
        .get(Uri.parse('https://api.mapmycrop.com/farm/?api_key=$api_key'));
    // print(response.statusCode);
    // print(response.body);
    var data = await jsonDecode(response.body);
    // print(data[0]['id']);
    // print(data[0]['name']);
    //farmData = data.map((e)=> FarmDetails.fromJson(e)).toList();
    //print(data);
    for (int i = 0; i < data.length; i++) {
      setState(() {
        idList.add(data[i]['id']);
        // nameList.add(data[i]['name']);
        // farmCoords.add(jsonDecode(data['features'][i]['geometry']['coordinates'][0].toString()));
      });
    }
    print(idList);
    // //print('the farm data is \n $farmData ');
    // // print(idList);
    // // print(nameList);
    //
    // //  });

    for(int i=0;i<idList.length;i++){
      var response1 = await http.get(Uri.parse(
          "https://api.mapmycrop.com/scouting/${idList[i]}?api_key=$api_key"));
      //print('https://api.mapmycrop.com/scouting/"${idList[i]}"?api_key=$api_key');
      //print(response.body);
      var data1 = jsonDecode(response1.body);
      //eventList = data;
      print(data1);
      for (int i = 0; i < data1.length; i++) {
        setState(() {
          note_type.add(data1[i]['note_type']);
          // note_type.add(data1[i]['comments']);
          // attachment.add(data1[i]['attachment']);
        });
      }
       //print(note_type);
      //var coordinates='[${cords.toString().replaceAll('[[[', '').replaceAll(']]]', '')}]';
    }
    //[LatLng(37.423411271013045, -122.08410512655972)]
    //print(coordinates);
    // List<LatLng> formattedList = [];
    // formattedList.clear();
    // var formattedlatlong;
    // var LatLngArray = jsonDecode(coordinates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.0,
        backgroundColor: Color(0xffECB34F),
        title: Text(
          "Scouting List",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: "Inter",
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
      body: note_type.isNotEmpty
          ? ListView.builder(
        itemCount: note_type.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:10.0),
                child: ListTile(
                  leading: Container(
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.green[800],
                      image: const DecorationImage(
                        image: AssetImage('assets/icon/plantimg.jpg'),
                        fit: BoxFit.fitWidth, //fitHeight,
                      ),
                    ),
                  ),
                  title: Text(note_type[index]),
                  //subtitle:Text(nameList[index]),
                  trailing: IconButton(
                    onPressed: () async {
                    },
                    icon: const Icon(Icons.delete,color: Colors.redAccent,),
                  ),
                ),
              ),
              Divider(), //                           <-- Divider
            ],
          );
        },
      )
      // ListView.builder(
      //         itemCount: nameList.length,
      //         itemBuilder: (BuildContext context, int index) => Container(
      //               margin: const EdgeInsets.symmetric(horizontal: 11.0),
      //               //padding: const EdgeInsets.all(3.0),
      //               child: Card(
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(10.0),
      //                 ),
      //                 shadowColor: Colors.grey,
      //                 elevation: 0.0,
      //                 child: ListTile(
      //                   leading: Container(
      //                     height: 30.0,
      //                     width: 30.0,
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(30.0),
      //                       color: Colors.green[800],
      //                       image: const DecorationImage(
      //                         image: AssetImage('assets/icon/plantimg.jpg'),
      //                         fit: BoxFit.fitWidth, //fitHeight,
      //                       ),
      //                     ),
      //                   ),
      //                   title: Container(
      //                       margin:
      //                           const EdgeInsets.symmetric(horizontal: 10.0),
      //                       child: Text(nameList[index])),
      //                   //subtitle:Container(margin:EdgeInsets.symmetric(horizontal:10.0),child: Text(idValue[index]['DESCRIPTION'])),
      //                   trailing: IconButton(
      //                     onPressed: () async {
      //                       //Navigator.pop(context);
      //                       setState(() {
      //                         idList.removeAt(index);
      //                         nameList.removeAt(index);}
      //                       );
      //                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Farm removed succesfully')));
      //                     },
      //                     icon: const Icon(Icons.delete,color: Colors.redAccent,),
      //                   ),
      //                   onTap: () {
      //                   },
      //                 ),
      //               ),
      //             ))
          : const Align(
        alignment: Alignment.center,
        child: Text(
          "No Scouting Found",
          //"First Create Your Farm ",
          style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
      ),
    );
  }
}

class FarmDetails {
  String type;
  List<Features> features;

  FarmDetails({this.type, this.features});

  FarmDetails.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) { features.add(new Features.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.features != null) {
      data['features'] = this.features.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Features {
  String type;
  Geometry geometry;
  Properties properties;

  Features({this.type, this.geometry, this.properties});

  Features.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    geometry = json['geometry'] != null ? new Geometry.fromJson(json['geometry']) : null;
    properties = json['properties'] != null ? new Properties.fromJson(json['properties']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    if (this.properties != null) {
      data['properties'] = this.properties.toJson();
    }
    return data;
  }
}

class Geometry {
  String type;
  List<List> coordinates;

  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null) {
      coordinates = <List>[];
      json['coordinates'].forEach((v) { coordinates.add(jsonDecode(v.toString())); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates.map((v) => jsonDecode(v.toString())).toList();
    }
    return data;
  }
}


Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}


class Properties {
  String id;
  int userId;
  int companyId;
  List<double> bbox;
  String name;
  String description;
  double area;
  String country;
  String state;

  Properties({this.id, this.userId, this.companyId, this.bbox, this.name, this.description, this.area, this.country, this.state});

  Properties.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    companyId = json['company_id'];
    bbox = json['bbox'].cast<double>();
    name = json['name'];
    description = json['description'];
    area = json['area'];
    country = json['country'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['company_id'] = this.companyId;
    data['bbox'] = this.bbox;
    data['name'] = this.name;
    data['description'] = this.description;
    data['area'] = this.area;
    data['country'] = this.country;
    data['state'] = this.state;
    return data;
  }
}