import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mmc_master/WebViews/EbookWebview.dart';
import 'package:mmc_master/Widgets/Loading.dart';

import 'constant/Constant.dart';


class CsvToList extends StatefulWidget {
  final String title;
  const CsvToList({Key key, this.title}) : super(key: key);

  @override
  _CsvToListState createState() => _CsvToListState();
}

class _CsvToListState extends State<CsvToList> {
  // List<List<dynamic>> data = [];
   var data;
   static List<CropModel> crops = [];
  String No,CropName,Link,Location;
   bool imageReady = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _loadCSV();
    fetchCropGuideData();
  }

  void fetchCropGuideData() async {
    var datavalue;
    var uri = Uri.parse("http://115.124.127.208/MMC/CropGuideFetchDataNew.php");
    var request = await http.MultipartRequest("POST", uri);
    request.fields['TYPE'] =widget.title;

    var response = await request.send();

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).transform(json.decoder).listen((value) async {
        setState(() {
          data = value;
        });
        print(data);
      });
    }
  }

   checkImageValidity(String url1) async {
     var url = Uri.parse(url1);
     http.Response response = await http.get(url);
     print(response.statusCode);
     try {
       if (response.statusCode == 200) {
         setState(() {
           imageReady = true; // It's valid
         });
       }
       else{
         setState(() {
           imageReady = false;
         });
       }
     } catch (e) {
       // TODO nothing special to do here
     }
   }

  @override
  Widget build(BuildContext context) {
    final screenHeight = height(context);
    return Container(
      color: Color(0xffECB34F),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
            appBar:AppBar(
              title: Text("${widget.title} Crop List"),
              backgroundColor: Color(0xffECB34F),
              // actions: [
              //   // Navigate to the Search Screen
              //   IconButton(
              //       onPressed: () => Navigator.of(context)
              //           .push(MaterialPageRoute(builder: (_) => const SearchPage())),
              //       icon: const Icon(Icons.search))
              // ],
            ),
            body: data!=null?GridView.builder(
              itemCount:data.length,
              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0
              ),
              itemBuilder: (BuildContext context, int index){
                var url="${data[index]['Path']}/${data[index]['Image']}";
                var path=url.toString().replaceAll(' ', '');
                //checkImageValidity(url);
                return GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => CropGuideDashboard()));
                  },
                  child: Stack(children: [
                    Container(
                      height: height(context) * 0.20,
                      // width:width(context)*0.40,
                      decoration: BoxDecoration(
                        //color: Colors.black,//Color(color),
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(path))),
                      // child: Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(6.0),
                      //       child: Text(
                      //           data[index]['CropName']
                      //       ),
                      //     )),
                    ),
                  ]),
                );
                //     :GestureDetector(
                // onTap: () {
                // // Navigator.push(
                // //     context,
                // //     MaterialPageRoute(
                // //         builder: (context) => CropGuideDashboard()));
                // },
                // child: Stack(children: [
                // Container(
                // height: height(context) * 0.20,
                // // width:width(context)*0.40,
                // decoration: BoxDecoration(
                // //color: Colors.black,//Color(color),
                // borderRadius: BorderRadius.circular(8.0),
                // image: DecorationImage(
                // fit: BoxFit.fill,
                // image: NetworkImage("https://img.icons8.com/bubbles/256/no-image.png"))),
                // child: Align(
                // alignment: Alignment.bottomCenter,
                // child: Padding(
                // padding: const EdgeInsets.all(6.0),
                // child: Text(
                // data[index]['CropName']
                // ),
                // )),
                // ),
                // ]),
                // );
              },
            ):Loading()
            // ListView.builder(
            //   itemCount: data.length,
            //   itemBuilder: (_, index) {
            //     return Card(
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(2.0),
            //       ),
            //       margin: EdgeInsets.symmetric(horizontal:15,vertical: 1.0),
            //       //shadowColor: Colors.grey,
            //       elevation: 0.5,
            //       child: ListTile(
            //         leading: Container(
            //           height: 30.0,
            //           width: 30.0,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(30.0),
            //             color: Colors.green[800],
            //             image:  DecorationImage(
            //               image: NetworkImage("${data[index]['Path']}/${data[index]['Image']}"),
            //               fit: BoxFit.fill, //fitHeight,
            //             ),
            //           ),
            //         ),
            //         title: Container(
            //             margin:
            //             const EdgeInsets.symmetric(horizontal: 10.0),
            //             child: Text(data[index]['CropName'])),
            //         //subtitle:Container(margin:EdgeInsets.symmetric(horizontal:10.0),child: Text(idValue[index]['DESCRIPTION'])),
            //         trailing:Icon(
            //           Icons.arrow_forward_ios,
            //           size: screenHeight * 0.02,
            //           color: Color(0xffECB34F),
            //         ),
            //         onTap: () {
            //           Navigator.push(context, MaterialPageRoute(builder: (context)=>EbookWebView(url:data[index]['Link'])));
            //         },
            //       ),
            //     );
            //   },
            // ):Loading()
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  var data;
  var cropName;
  bool croplist=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void SearchCrop() async {
    var uri = Uri.parse("http://115.124.127.208/MMC/CropSearch.php");
    var request = await http.MultipartRequest("POST", uri);
    request.fields['CropName'] =cropName;
    var response = await request.send();
    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).transform(json.decoder).listen((value) async {
        data = value;
        print(data);
        if(data!=null) {
          setState(() {
            croplist = true;
          });
        }
        else{
          setState(() {
            croplist = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Color(0xffECB34F),
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Address',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    left: 15,
                    top: 15,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed:(){SearchCrop();},
                    iconSize: 30,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    cropName = val;
                  });
                },
              ),
            ),
          )),
      body:data!=null ?ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>EbookWebView(url:data[index]['Link'])));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
              ),
              //shadowColor: Colors.grey,
              elevation: 0.5,
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
                title: Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(data[index]['CropName'])),
                //subtitle:Container(margin:EdgeInsets.symmetric(horizontal:10.0),child: Text(idValue[index]['DESCRIPTION'])),
                onTap: () {
                },
              ),
            ),
          );
        },
      ):Loading()
    );
  }
}

class CropModel {
  final String No;
  final String Location;
  final String CropName;
  final String Link;

  CropModel(
      {
        this.No,
        this.Location,
        this.CropName,
        this.Link,
      });

  factory CropModel.fromJson(Map<String, dynamic> json) {
    return CropModel(
      No: json['No'],
      Location: json['Location'],
      CropName: json['CropName'],
      Link: json['Link'],
    );
  }
}