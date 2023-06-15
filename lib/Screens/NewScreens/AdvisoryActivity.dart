import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../../Model/DiseasAdvisoryModel.dart';
import '../../constants/constants.dart';
import '../constant/Constant.dart';
import 'DiseaseAdvisoryDetails.dart';
class AdvisoryActivity extends StatefulWidget {
  const AdvisoryActivity({Key key}) : super(key: key);

  @override
  State<AdvisoryActivity> createState() => _AdvisoryActivityState();
}

class _AdvisoryActivityState extends State<AdvisoryActivity> {

  Future<List<DiseaseAdvisoryModel>>diseaseadvisory;
  List<DiseaseAdvisoryModel> advisory=[];
  var datavalue;
  bool _isSearching = false;
  TextEditingController controller = new TextEditingController();
  List _searchResult = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    diseaseadvisory=fetchDiseaseAdvisoryData();
  }


  Future<List<DiseaseAdvisoryModel>> fetchDiseaseAdvisoryData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var api_key = prefs.getString('api_key');
    //print(Icons.api);

    final response = await http
        .get(Uri.parse('https://api.mapmycrop.com/disease/all?api_key=$api_key'));
    if (response.statusCode == 200) {
      datavalue=jsonDecode(response.body);
      for(int i=0;i<datavalue.length;i++){
        advisory.add(DiseaseAdvisoryModel.fromJson(datavalue[i]));
      }
      //print(advisory);
      return advisory;
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xffECB34F),
        leading: _isSearching ? InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/new_images/back.png')
        ) : InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/new_images/back.png')
        ),
        title: _isSearching ? _buildSearchField() : ChangedLanguage(text:"Advisory"),
        actions: _buildActions(),
      ),
      // appBar:AppBar(
      //   title: ChangedLanguage(text:"${widget.title} Crop List"),
      //   backgroundColor: Color(0xffECB34F),
      //   // actions: [
      //   //   // Navigate to the Search Screen
      //   //   IconButton(
      //   //       onPressed: () => Navigator.of(context)
      //   //           .push(MaterialPageRoute(builder: (_) => const SearchPage())),
      //   //       icon: const Icon(Icons.search))
      //   // ],
      // ),
      body: _buildBody(),
      resizeToAvoidBottomInset: true,
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     centerTitle: false,
    //     backgroundColor: Color(0xffECB34F),
    //     title: _isSearching ? _buildSearchField() : ChangedLanguage(text:"Disease Advisory"),
    //     actions: _buildActions(),
    //     // title: ChangedLanguage(text:
    //     //   "Disease Advisory",
    //     //   style: TextStyle(
    //     //     color: Colors.white,
    //     //     fontSize: 15,
    //     //     fontFamily: "Inter",
    //     //     fontWeight: FontWeight.w600,
    //     //   ),
    //     // ),
    //     leading: InkWell(
    //         onTap: (){
    //           Navigator.pop(context);
    //         },
    //         child: Image.asset('assets/new_images/back.png')
    //     ),
    //   ),
    //   body: FutureBuilder<List<DiseaseAdvisoryModel>>(
    //     future: diseaseadvisory,
    //     builder: (context, snapshot) {
    //       print(snapshot.data);
    //       if (snapshot.hasData) {
    //         return GridView.builder(
    //           itemCount: snapshot.data.length,
    //           gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
    //               crossAxisCount: 2,
    //               crossAxisSpacing: 4.0,
    //               mainAxisSpacing: 4.0
    //           ),
    //           itemBuilder: (BuildContext context, int index){
    //             return GestureDetector(
    //               onTap: (){
    //                 Navigator.push(context, MaterialPageRoute(builder: (context)=>DiseaseAdvisoryDetails(data:snapshot.data[index])));
    //               },
    //               child: Card(
    //                 elevation:2,
    //                 child:Column(
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     Expanded(
    //                         child: Padding(
    //                           padding: const EdgeInsets.all(8.0),
    //                           child: ClipRRect(
    //                             borderRadius: BorderRadius.circular(10),
    //                             child: CachedNetworkImage(
    //                               imageUrl:snapshot.data[index].pre+snapshot.data[index].folderName+snapshot.data[index].image1+'.'+snapshot.data[index].fileFormat,
    //                                 height: height(context)*0.145,
    //                                 width:width(context)*0.48,
    //                                 fit: BoxFit.fill,
    //                                 errorWidget: (context, url, error) => Image.network(
    //                                   "https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?s=612x612&w=0&k=20&c=PM_optEhHBTZkuJQLlCjLz-v3zzxp-1mpNQZsdjrbns=",fit: BoxFit.fill,height: height(context)*0.145,width:width(context)*0.48,
    //                                 ),
    //                              )
    //                           ),
    //                         )
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: ChangedLanguage(text:snapshot.data[index].name,textAlign: TextAlign.center),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             );
    //           },
    //         );
    //       } else if (snapshot.hasError) {
    //         print(snapshot.error);
    //        // return ChangedLanguage(text:'${snapshot.error}');
    //       }
    //       // By default, show a loading spinner.
    //       return Center(child: const CircularProgressIndicator());
    //     },
    //   )
    // );
  }

  Widget _buildBody() {
    return new Column(
      children: <Widget>[
        // new Container(
        //     color: Theme.of(context).primaryColor, child: _buildSearchBox()),
        SizedBox(height: 5.0,),
        new Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ? _buildSearchResults()
                : _buildDiseaseList()),
      ],
    );
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      itemCount: _searchResult.length,
      gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0
      ),
      itemBuilder: (BuildContext context, int index){
        print(_searchResult[index].name);
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>DiseaseAdvisoryDetails(data:_searchResult[index])));
          },
          child: Card(
            elevation:2,
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl:_searchResult[index].pre+_searchResult[index].folderName+_searchResult[index].image1+'.'+_searchResult[index].fileFormat,
                            height: height(context)*0.145,
                            width:width(context)*0.48,
                            fit: BoxFit.fill,
                            errorWidget: (context, url, error) => Image.network(
                              "https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?s=612x612&w=0&k=20&c=PM_optEhHBTZkuJQLlCjLz-v3zzxp-1mpNQZsdjrbns=",fit: BoxFit.fill,height: height(context)*0.145,width:width(context)*0.48,
                            ),
                          )
                      ),
                    )
                ),
                Shimmer.fromColors(
                  baseColor: Colors.green,
                  highlightColor: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder(future:changeLanguage(_searchResult[index].name),builder: (context,i)=> Text(i.hasData?i.data:'',textAlign: TextAlign.center,),),//ChangedLanguage(text:_searchResult[index].name,),//textAlign: TextAlign.center
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    // return new ListView.builder(
    //   itemCount: _searchResult.length,
    //   itemBuilder: (context, i) {
    //     return new
    //     Card(
    //       child: new ListTile(
    //         leading: new CircleAvatar(
    //           backgroundImage: new NetworkImage(
    //             _searchResult[i].Path+'/'+_searchResult[i].Image,
    //           ),
    //         ),
    //         title: new ChangedLanguage(text:
    //             _searchResult[i].CropName + ' ' +_searchResult[i].Location),
    //       ),
    //       margin: const EdgeInsets.all(0.0),
    //     );
    //   },
    // );
  }
  // FutureBuilder<List<DiseaseAdvisoryModel>>(
  // future: diseaseadvisory,
  // builder: (context, snapshot) {
  // print(snapshot.data);
  // if (snapshot.hasData) {
  // return GridView.builder(
  // itemCount: snapshot.data.length,
  // gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
  // crossAxisCount: 2,
  // crossAxisSpacing: 4.0,
  // mainAxisSpacing: 4.0
  // ),
  // itemBuilder: (BuildContext context, int index){
  // return GestureDetector(
  // onTap: (){
  // Navigator.push(context, MaterialPageRoute(builder: (context)=>DiseaseAdvisoryDetails(data:snapshot.data[index])));
  // },
  // child: Card(
  // elevation:2,
  // child:Column(
  // crossAxisAlignment: CrossAxisAlignment.center,
  // children: [
  // Expanded(
  // child: Padding(
  // padding: const EdgeInsets.all(8.0),
  // child: ClipRRect(
  // borderRadius: BorderRadius.circular(10),
  // child: CachedNetworkImage(
  // imageUrl:snapshot.data[index].pre+snapshot.data[index].folderName+snapshot.data[index].image1+'.'+snapshot.data[index].fileFormat,
  // height: height(context)*0.145,
  // width:width(context)*0.48,
  // fit: BoxFit.fill,
  // errorWidget: (context, url, error) => Image.network(
  // "https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?s=612x612&w=0&k=20&c=PM_optEhHBTZkuJQLlCjLz-v3zzxp-1mpNQZsdjrbns=",fit: BoxFit.fill,height: height(context)*0.145,width:width(context)*0.48,
  // ),
  // )
  // ),
  // )
  // ),
  // Padding(
  // padding: const EdgeInsets.all(8.0),
  // child: ChangedLanguage(text:snapshot.data[index].name,textAlign: TextAlign.center),
  // ),
  // ],
  // ),
  // ),
  // );
  // },
  // );
  // } else if (snapshot.hasError) {
  // print(snapshot.error);
  // // return ChangedLanguage(text:'${snapshot.error}');
  // }
  // // By default, show a loading spinner.
  // return Center(child: const CircularProgressIndicator());
  // },
  // )
  Widget _buildDiseaseList() {
    return  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FutureBuilder<List<DiseaseAdvisoryModel>>(
          future: diseaseadvisory,
          builder: (context, snapshot) {
            // print(snapshot.data.);
            if (snapshot.hasData) {

              return GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0
                ),
                itemBuilder: (BuildContext context, int index){
                  print(snapshot.data[index].pre);
                  print("${snapshot.data[index].pre}${snapshot.data[index].folderName}${snapshot.data[index].image1}.${snapshot.data[index].fileFormat}");
                 // print(snapshot.data[index].pre+snapshot.data[index].folderName+snapshot.data[index].image1+'.'+snapshot.data[index].fileFormat);
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>DiseaseAdvisoryDetails(data:snapshot.data[index])));
                    },
                    child: Card(
                      elevation:2,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl:"${snapshot.data[index].pre}${snapshot.data[index].folderName}${snapshot.data[index].image1}.${snapshot.data[index].fileFormat}",
                                      //  "${snapshot.data[index].pre}${snapshot.data[index].folderName}+${snapshot.data[index].image1}.${snapshot.data[index].fileFormat}"
                                      height: height(context)*0.145,
                                      width:width(context)*0.48,
                                      fit: BoxFit.fill,
                                      errorWidget: (context, url, error) => Image.network(
                                        "https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?s=612x612&w=0&k=20&c=PM_optEhHBTZkuJQLlCjLz-v3zzxp-1mpNQZsdjrbns=",fit: BoxFit.fill,height: height(context)*0.145,width:width(context)*0.48,
                                      ),
                                    )
                                ),
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ChangedLanguage(text:snapshot.data[index].name),//textAlign: TextAlign.center
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              // return ChangedLanguage(text:'${snapshot.error}');
            }
            // By default, show a loading spinner.
            return GridView.builder(
              itemCount: 12,
              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0
              ),
              itemBuilder: (BuildContext context, int index){
                return GestureDetector(
                  onTap: (){
                   // Navigator.push(context, MaterialPageRoute(builder: (context)=>DiseaseAdvisoryDetails(data:snapshot.data[index])));
                  },
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.white,
                    child: Card(
                      elevation:2,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.black,
                                      highlightColor: Colors.white,
                                      child: Container(
                                        height: height(context)*0.145,
                                        width:width(context)*0.48,
                                      ),
                                    )
                                ),
                              )
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.black,
                            highlightColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ChangedLanguage(text:''),//textAlign: TextAlign.center
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        )
    );
    // return new ListView.builder(
    //   itemCount: _cropDetails.length,
    //   itemBuilder: (context, index) {
    //     return new Card(
    //       child: new ListTile(
    //         leading: new CircleAvatar(
    //           backgroundImage: new NetworkImage(
    //             "${_cropDetails[index].Path}/${_cropDetails[index].Image}",//"${data[index]['Path']}/${data[index]['Image']}"
    //           ),
    //         ),
    //         title: new ChangedLanguage(text:_cropDetails[index].CropName +
    //             ' ' +
    //             _cropDetails[index].Location),
    //       ),
    //       margin: const EdgeInsets.all(0.0),
    //     );
    //   },
    // );
  }
  Widget _buildSearchField() {
    return Container(
      padding:EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
      child: CupertinoSearchTextField(
        controller: controller,
        //backgroundColor: Colors.white12,
        itemColor:Colors.white,
        style: TextStyle(color: Colors.white, fontSize: 16.0),
        autofocus: true,
        placeholder:'Search...',
        placeholderStyle:TextStyle(color: Colors.white),
        onChanged: (query) => updateSearchQuery(query),
      ),
    );
    // return TextField(
    //   controller: controller,
    //   autofocus: true,
    //   cursorColor:Colors.white10,
    //   decoration: InputDecoration(
    //     hintText: "Search...",
    //     border: InputBorder.none,
    //     filled: true,
    //     fillColor:Colors.white10,
    //     hintStyle: TextStyle(color: Colors.white30),
    //   ),
    //   style: TextStyle(color: Colors.black, fontSize: 16.0),
    //   onChanged: (query) => updateSearchQuery(query),
    // );
  }

  void updateSearchQuery(String newQuery) {
    //print(newQuery);
    _searchResult.clear();
    if (newQuery.isEmpty) {
      setState(() {});
      return;
    }

    advisory.forEach((advisoryDetail) {
      //print(advisoryDetail.name);
      if (advisoryDetail.name.toLowerCase().contains(newQuery) ||
          advisoryDetail.name.toUpperCase().contains(newQuery.toUpperCase())){
        setState(() {
          _searchResult.add(advisoryDetail);
         });
        }
      }
    );
  }
  void _clearSearchQuery() {
    setState(() {
      controller.clear();
      updateSearchQuery("");
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (controller == null ||
                controller.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            //_clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }
  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }
}
