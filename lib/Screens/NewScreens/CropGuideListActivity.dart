import 'package:cached_network_image/cached_network_image.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../WebViews/EbookWebview.dart';
import '../../constants/constants.dart';
import '../constant/Constant.dart';
class CropGuideListActivity extends StatefulWidget {
  final String title;
  const CropGuideListActivity({Key key, this.title}) : super(key: key);

  @override
  _CropGuideListActivityState createState() => _CropGuideListActivityState();
}

class _CropGuideListActivityState extends State<CropGuideListActivity> {
  List _searchResult = [];
  List _cropDetails = [];
  TextEditingController controller = new TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search here";

  var result = '';
  var result1 = '';
  var result2 = [];

  var data ;
  var dataList = [];

  // Get json result and convert it to model. Then add
  Future<Null> getCropDetails() async {
    /*var uri = Uri.parse("http://115.124.127.208/MMC/CropGuideFetchDataNew.php");
    var request = await http.MultipartRequest("POST", uri);
    request.fields['TYPE'] =widget.title;

    var response = await request.send();

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).transform(json.decoder).listen((value) async {
        final responseJson=value;
        print(responseJson);*/

    result = await DefaultAssetBundle.of(context).loadString(
      "assets/Csv/data.csv",
    );

    result1 = CsvToListConverter().convert(result, eol: "\n").toString();
    result2 = CsvToListConverter().convert(result, eol: "\n");
    print(result);
    for(int i = 1;i<result2.length;i++){
      data = {};
      data.addAll({result2[0][0]:result2[i][0]});
      data.addAll({result2[0][1]:result2[i][1]});
      data.addAll({result2[0][2]:result2[i][2]});
      data.addAll({result2[0][3]:result2[i][3]});
      data.addAll({result2[0][4]:result2[i][4]});
      data.addAll({result2[0][5]:result2[i][5]});
      data.addAll({result2[0][6]:result2[i][6]});
      if(data['Location']==widget.title){
        setState(() {
          _cropDetails.add(data);
        });
      }
      print(data);
      

    }
    //xprint(_cropDetails.contains('India'));
        /*setState(() {
          for (Map crop in responseJson) {
          _cropDetails.add(CropDetails.fromJson(crop));
          }
        });
      });*/
    }


  @override
  void initState() {
    super.initState();
    getCropDetails();
  }

  Widget _buildCropsList() {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GridView.builder(
        itemCount:_cropDetails.length,
        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing:4.0,
            mainAxisSpacing: 4.0,
          //childAspectRatio: 3 / 3.0,
        ),
        itemBuilder: (BuildContext context, int index){
          return /*GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>EbookWebView(url:_cropDetails[index]['Link'])));
            },
            child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
              Container(
                height: height(context) * 0.20,
                // width:width(context)*0.40,
                //margin: EdgeInsets.symmetric(horizontal:4.0,vertical:4.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Color(0xffECB34F), width: 1),
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage("${_cropDetails[index]['Path']}/${_cropDetails[index]['Image ']}"))),
                // child: Align(
                //     alignment: Alignment.bottomCenter,
                //     child: Padding(
                //       padding: const EdgeInsets.all(6.0),
                //       child: ChangedLanguage(text:
                //           data[index]['CropName']
                //       ),
                //     )),
              ),
              Positioned(
                bottom: 8,
                  child: ChangedLanguage(text:_cropDetails[index]['CropName']))
            ]),
          )*/GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>EbookWebView(url:_cropDetails[index]['Link'])));
            },
            child: Card(
              elevation:2,
              child:Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        height: height(context)*0.149,
                        width: width(context)*0.50,
                        fit: BoxFit.fill,
                        imageUrl: '${_cropDetails[index]['Path']}/${_cropDetails[index]['Image ']}',
                        //placeholder: (context, url) => new CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.network('https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?s=612x612&w=0&k=20&c=PM_optEhHBTZkuJQLlCjLz-v3zzxp-1mpNQZsdjrbns='),
                      )/*Image.network(
                              snapshot.data[index].pre.contains('https')?snapshot.data[index].pre+snapshot.data[index].folderName+snapshot.data[index].image1+'.'+snapshot.data[index].fileFormat:"https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?s=612x612&w=0&k=20&c=PM_optEhHBTZkuJQLlCjLz-v3zzxp-1mpNQZsdjrbns=",fit: BoxFit.fill,height:height(context)*0.145,width: width(context)*0.38,
                            )*/,
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ChangedLanguage(text:_cropDetails[index]['CropName'])),
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: ChangedLanguage(text:snapshot.data[index].name,textAlign: TextAlign.center),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
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

  Widget _buildSearchResults() {
    return new GridView.builder(
      itemCount:_searchResult.length,
      gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing:4.0,
        mainAxisSpacing: 4.0,
        //childAspectRatio: 3 / 3.0,
      ),
      itemBuilder: (BuildContext context, int index){
        return /*GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>EbookWebView(url:_cropDetails[index]['Link'])));
            },
            child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
              Container(
                height: height(context) * 0.20,
                // width:width(context)*0.40,
                //margin: EdgeInsets.symmetric(horizontal:4.0,vertical:4.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Color(0xffECB34F), width: 1),
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage("${_cropDetails[index]['Path']}/${_cropDetails[index]['Image ']}"))),
                // child: Align(
                //     alignment: Alignment.bottomCenter,
                //     child: Padding(
                //       padding: const EdgeInsets.all(6.0),
                //       child: ChangedLanguage(text:
                //           data[index]['CropName']
                //       ),
                //     )),
              ),
              Positioned(
                bottom: 8,
                  child: ChangedLanguage(text:_cropDetails[index]['CropName']))
            ]),
          )*/GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>EbookWebView(url:_searchResult[index]['Link'])));
          },
          child: Card(
            elevation:2,
            child:Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      height: height(context)*0.149,
                      width: width(context)*0.50,
                      fit: BoxFit.fill,
                      imageUrl: '${_searchResult[index]['Path']}/${_searchResult[index]['Image ']}',
                      //placeholder: (context, url) => new CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.network('https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?s=612x612&w=0&k=20&c=PM_optEhHBTZkuJQLlCjLz-v3zzxp-1mpNQZsdjrbns='),
                    )/*Image.network(
                              snapshot.data[index].pre.contains('https')?snapshot.data[index].pre+snapshot.data[index].folderName+snapshot.data[index].image1+'.'+snapshot.data[index].fileFormat:"https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?s=612x612&w=0&k=20&c=PM_optEhHBTZkuJQLlCjLz-v3zzxp-1mpNQZsdjrbns=",fit: BoxFit.fill,height:height(context)*0.145,width: width(context)*0.38,
                            )*/,
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: FutureBuilder(future:changeLanguage(_searchResult[index]['CropName']),builder: (context,i)=> Text(i.hasData?i.data:''),),//ChangedLanguage(text:_searchResult[index]['CropName'])
                   ),
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: ChangedLanguage(text:snapshot.data[index].name,textAlign: TextAlign.center),
                //   ),
                // ),
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

  Widget _buildSearchBox() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Card(
        child: new ListTile(
          leading: new Icon(Icons.search),
          title: new TextField(
            controller: controller,
            decoration: new InputDecoration(
                hintText: 'Search', border: InputBorder.none),
            onChanged: onSearchTextChanged,
          ),
          trailing: new IconButton(
            icon: new Icon(Icons.cancel),
            onPressed: () {
              controller.clear();
              onSearchTextChanged('');
            },
          ),
        ),
      ),
    );
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
                : _buildCropsList()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xffECB34F),
        leading: _isSearching ? const BackButton() : InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/new_images/back.png')
        ),
        title: _isSearching ? _buildSearchField() : ChangedLanguage(text:"${widget.title} Crop List"),
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
  }

  Widget _buildSearchField() {
    return Container(
      padding:EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
      child: CupertinoSearchTextField(
        controller: controller,
        //backgroundColor: Colors.white12,
        itemColor:Colors.transparent,
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
            _clearSearchQuery();
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

  void updateSearchQuery(String newQuery) {
    print(newQuery);
    _searchResult.clear();
    if (newQuery.isEmpty) {
      setState(() {});
      return;
    }
    // _cropDetails.map(cropDetail){
    //
    // }
    _cropDetails.forEach((cropDetail) {

      print(cropDetail);
      // print(cropDetail['Crop Name']);
      // print(cropDetail['Location']);
      if (cropDetail['CropName'].toLowerCase().contains(newQuery) || cropDetail['CropName'].toUpperCase().contains(newQuery.toUpperCase())||
          cropDetail['Location'].toLowerCase().contains(newQuery)){
        setState(() {
          _searchResult.add(cropDetail);
        });

      }
    });


    // setState(() {
    //   searchQuery = newQuery;
    // });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      controller.clear();
      updateSearchQuery("");
    });
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();

    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _cropDetails.forEach((cropDetail) {
      if (cropDetail['CropName'].toLowerCase().contains(text) ||
          cropDetail['Location'].toLowerCase().contains(text)) _searchResult.add(cropDetail);
    });

    setState(() {});
  }
}

class CropDetails {
  final String No;
  final String Location, CropName, Link,Path,Image;

  CropDetails({this.No, this.Location, this.CropName, this.Link, this.Path, this.Image});

  factory CropDetails.fromJson(Map<String, dynamic> json) {
    return new CropDetails(
      No: json['No'],
      Location: json['Location'],
      CropName: json['CropName'],
      Link: json['Link'],
      Path: json['Path'],
      Image: json['Image'],
    );
  }
}