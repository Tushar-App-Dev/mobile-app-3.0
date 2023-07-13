import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../Screens/constant/Constant.dart';
import '../constants/constants.dart';

class MandiPriceDta1 extends StatefulWidget {

  @override
  _MandiPriceDta1State createState() => _MandiPriceDta1State();
}
MandiModel MandiList;
MandiModel MandiList1;
class _MandiPriceDta1State extends State<MandiPriceDta1> {
  final FocusNode stateFocusMode = FocusNode();
  final FocusNode districtFocusMode = FocusNode();
  final FocusNode commodityFocusMode = FocusNode();
  String locality,state,commodity,stateValue,districtValue,commodityValue;
  List<String> states = [],commodities = [],districtList=[];
  Map<String,List<String>> districts = {};

  List<Records> mandiRecords = [] ;
  List<Records> mandiRecords1 = [] ;
  @override
  void initState() {
    fetchMarketData();
    super.initState();
  }


  /* Future<MandiModel>*/fetchMarketData() async {
    //print('entered');
    var url = 'https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=579b464db66ec23bdd0000013543f3705462452a677dbf4e7f0f03f8&format=json&limit=2000';
    // MandiList.clear();
    if(state!=null){
      url += '&filters[state]=$state';
    }
    if(locality!=null){
      url += '&filters[district]=$locality';
    }
    if(commodity!=null){
      url += '&filters[commodity]=$commodity';
    }

    if(MandiList==null) {
      print(url);
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonresponse = json.decode(response.body);
        //print('the mandi data is $jsonresponse');
        setState(() {
          MandiList = MandiModel.fromJson(jsonresponse);
        });
        //print(MandiList.records.length);
        ////print(jsonresponse);
        // //print(MandiList);

        //return MandiModel.fromJson(jsonresponse);
        //Health.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load album');
      }


      //print(MandiList.records);

    }
    commodities.clear();
    for (int i = 0; i < MandiList.records.length; i++) {
      if (!commodities.contains(MandiList.records[i].commodity)) {
        setState(() {
          commodities.add(MandiList.records[i].commodity);
        });
      }
      //states.clear();
      var tempState = MandiList.records[i].state;
      //print(MandiList.records[i].state);
      if (!states.contains(tempState)) {
        states.add(tempState);
      }
      // //print(i);
    }
    //print(states);

    for (int i = 0; i < MandiList.records.length; i++) {
      //print(MandiList.records[i].state);
      if (states.contains(MandiList.records[i].state) == false) {
        // //print('inside if ${MandiList.records[i].state}');
        setState(() {
          states.add(MandiList.records[i].state);
        });
      }
    }
    //districts.clear();
    //print(states);
    if (districts.isEmpty) {
      for (int i = 0; i < states.length; i++) {
        List<String> temp = [];
        for (int k = 0; k < MandiList.records.length; k++) {
          if (MandiList.records[k].state == states[i]) {
            if (!temp.contains(MandiList.records[k].district)) {
              temp.add(MandiList.records[k].district);
            }
          }
        }
        districts.addAll({states[i]: temp});
      }
    }
    newRecord();
    // //print(commodities);
    // //print(districts['Chattisgarh']);

    ////print('the final list is ${MandiList.records.length}');
  }

  newRecord(){
    mandiRecords.clear();
    commodities.clear();
    print(locality);
    setState((){


      if(state!=null && locality!=null &&commodity!=null){
        print('here in debug1');
        for(int i = 0;i<MandiList.records.length;i++){
          if(MandiList.records[i].state == state&&MandiList.records[i].district==locality&&MandiList.records[i].commodity==commodity){
            mandiRecords.add(MandiList.records[i]);

          }
          if(MandiList.records[i].state == state&&MandiList.records[i].district==locality){
            if(!commodities.contains(MandiList.records[i].commodity)){
              commodities.add(MandiList.records[i].commodity);
            }
          }
        }
      }else
      if(state!=null && locality!=null){ print('here in debug2');
      for(int i = 0;i<MandiList.records.length;i++){
        if(MandiList.records[i].state == state&&MandiList.records[i].district==locality){
          mandiRecords.add(MandiList.records[i]);
          if(!commodities.contains(MandiList.records[i].commodity)){
            commodities.add(MandiList.records[i].commodity);
          }
        }
      }
      }else if(state!=null&&locality==null&&commodity==null){ print('here in debug3');
      for(int i = 0;i<MandiList.records.length;i++){
        if(MandiList.records[i].state == state){
          mandiRecords.add(MandiList.records[i]);
          if(!commodities.contains(MandiList.records[i].commodity)){
            commodities.add(MandiList.records[i].commodity);
          }
        }

      }
      } else if(commodity!=null){ print('here in debug4');
      for(int i = 0;i<MandiList.records.length;i++){
        if(MandiList.records[i].commodity == commodity){
          mandiRecords.add(MandiList.records[i]);
          if(!commodities.contains(MandiList.records[i].commodity)){
            commodities.add(MandiList.records[i].commodity);
          }
        }
      }
      }else if (state!=null&&commodity!=null&&locality==null){
        print('here in debug5');
        for(int i = 0;i<MandiList.records.length;i++){
          if(MandiList.records[i].state == state&&MandiList.records[i].commodity==commodity){
            mandiRecords.add(MandiList.records[i]);
            /*if(!commodities.contains(MandiList.records[i].commodity)){
              commodities.add(MandiList.records[i].commodity);
            }*/
          }

        }
      }else{ print('here in debug6');
      for(int i = 0;i<MandiList.records.length;i++){

        mandiRecords.add(MandiList.records[i]);
        if(!commodities.contains(MandiList.records[i].commodity)){
          commodities.add(MandiList.records[i].commodity);
        }

      }

      }
    });
    print(mandiRecords);
  }
  Future<List<Records>> getMandiData()async{
    var url = 'https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=579b464db66ec23bdd0000013543f3705462452a677dbf4e7f0f03f8&format=json&limit=2000';
    var response = await http.get(Uri.parse(url));
    MandiList1 = MandiModel.fromJson(jsonDecode(response.body));
    mandiRecords1 = MandiList1.records;
    return mandiRecords1;

  }


  /// 'https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=579b464db66ec23bdd0000013543f3705462452a677dbf4e7f0f03f8&format=json&limit=1000${state==null?'':'&filters[state]=$state'}${locality==null?'':'&filters[district]=$locality'}&filters[commodity]=${commodity}'
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffECB34F),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: false,
            backgroundColor: Color(0xffECB34F),
            title: Text(
              "Mandi Rates",
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ChangedLanguage( text:
                  'Current Daily Price of Various Commodities from Various Markets (Mandi)',
                    //style: TextStyle(fontWeight:FontWeight.w600,fontSize: 16.0),
                  ),
                ),
                Container(height: height(context)*0.05,
                  // width: width(context),
                  width: width(context)*0.95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: themeColor,strokeAlign: StrokeAlign.outside),
                    borderRadius: BorderRadius.circular(8),

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: height(context)*0.05,
                        width: width(context)*0.35,
                        decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8))
                        ),
                        child: Center(child: Text('Select State',style: TextStyle(fontWeight: FontWeight.w600),)),
                      ),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            focusNode: stateFocusMode,
                            hint: Center(child:
                            FutureBuilder(future:changeLanguage(state==null?'Select state':state),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.white,child: Card(
                              child: SizedBox(
                                height: height(context)*0.014,
                                width: width(context)*0.5,
                              ),
                            )),)
                              // Text(state==null?'Select state':state)
                            ),
                            value: stateValue,
                            elevation: 25,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            items: states.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: FutureBuilder(future:changeLanguage(value),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor: Colors.white,child: Card(
                                              child: SizedBox(
                                                height: height(context)*0.014,
                                                width: width(context)*0.5,
                                              ),
                                            )),)
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String newvalue) {
                              // print(districts.toString().replaceAll('],', ']\n'));

                              setState(() {
                                locality = null;
                                commodity = null;
                                state = newvalue;
                                districtList = districts[newvalue];
                                // districtList.re
                              });
                              //fetchMarketData();
                              newRecord();
                              // print(districtList);
                              // //print(farmIdList);
                              //print(state);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Container(height: height(context)*0.05,
                   width: width(context)*0.95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: themeColor,strokeAlign: StrokeAlign.outside),
                    borderRadius: BorderRadius.circular(8),

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: height(context)*0.05,
                        width: width(context)*0.35,
                        decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8))
                        ),
                        child: Center(child: Text('Select District',style: TextStyle(fontWeight: FontWeight.w600),)),
                      ),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            focusNode: districtFocusMode,
                            hint: Center(child:
                            FutureBuilder(future:changeLanguage(locality==null?'Select district':locality),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.white,child: Card(
                              child: SizedBox(
                                height: height(context)*0.014,
                                width: width(context)*0.5,
                              ),
                            )),)
                              //Text(locality==null?'Select district':locality)
                            ),
                            value: districtValue,
                            elevation: 25,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            items: districtList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(
                                    child: FutureBuilder(future:changeLanguage(value),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.white,child: Card(
                                      child: SizedBox(
                                        height: height(context)*0.014,
                                        width: width(context)*0.5,
                                      ),
                                    )),)
                                ),
                              );
                            }).toList(),
                            onChanged: (String newvalue) {

                              setState(() {
                                commodity = null;
                                locality = newvalue;

                                // districtList = districts[state];
                              });
                              newRecord();
                              //fetchMarketData();
                              // //print(farmIdList);
                              //print(locality);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Container(height: height(context)*0.05,
                  width: width(context)*0.95,
                  // width: width(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: themeColor,strokeAlign: StrokeAlign.outside),
                    borderRadius: BorderRadius.circular(8),

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: height(context)*0.05,
                        width: width(context)*0.35,
                        decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8))
                        ),
                        child: Center(child: Text('Select Commodity',style: TextStyle(fontWeight: FontWeight.w600),)),
                      ),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            focusNode: commodityFocusMode,
                            hint: Center(child:
                            FutureBuilder(future:changeLanguage(commodity==null?'Select commodity':commodity),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.white,child: Card(
                              child: SizedBox(
                                height: height(context)*0.014,
                                width: width(context)*0.5,
                              ),
                            )),)
                              // Text(commodity==null?'Select commodity':commodity)
                            ),
                            value: commodityValue,
                            elevation: 25,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            items: commodities.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(
                                    child: FutureBuilder(future:changeLanguage(value),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.white,child: Card(
                                      child: SizedBox(
                                        height: height(context)*0.014,
                                        width: width(context)*0.5,
                                      ),
                                    )),)
                                )
                                ,
                              );
                            }).toList(),
                            onChanged: (String newvalue) {

                              setState(() {
                                commodity = newvalue;
                                //districtList = districts[state];
                              });
                              // fetchMarketData();
                              // //print(farmIdList);
                              newRecord();
                              //print(commodity);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25),

                Container(

                    padding:EdgeInsets.symmetric(horizontal: 10.0),
                    child:
                    MandiList!=null? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          Padding(
                              padding: const EdgeInsets.only(left: 10.0,right: 12.0,top: 10.0,bottom: 15.0),
                              child: Text('Updated Date : '+MandiList.updatedDate.toString().substring(0,10))

                            //Text('Updated Date : '+MandiList.updatedDate.toString().substring(0,10)),
                          ),
                          // SingleChildScrollView(scrollDirection: Axis.horizontal,
                          //     child: Text(snapshot.data.targetBucket.index
                          //     )
                          // ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children:[
                                      // Padding(
                                      //   padding: const EdgeInsets.only(left: 16.0,right: 12.0,top: 10.0,bottom: 10.0),
                                      //   child: Text(snapshot.data.limit),
                                      // ),
                                      Container(
                                          height:height(context)*0.6,
                                          width: width(context)*0.95,
                                          child: ListView.builder(
                                            itemCount: mandiRecords.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                margin: EdgeInsets.only(bottom: 10),
                                                decoration: BoxDecoration(border: Border.all(color: themeColor),borderRadius: BorderRadius.circular(12)),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children:[
                                                      Padding(
                                                          padding: const EdgeInsets.only(left: 15.0,top:8.0),
                                                          child: FutureBuilder(future:changeLanguage(mandiRecords[index].commodity),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                              baseColor: Colors.grey.shade300,
                                                              highlightColor: Colors.white,child: Card(
                                                            child: SizedBox(
                                                              height: height(context)*0.014,
                                                              width: width(context)*0.5,
                                                            ),
                                                          )),)


                                                        // Text( MandiList.records[index].commodity,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),)

                                                        // Text(MandiList.records[index].commodity,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),),
                                                      ),
                                                      //Container(height: height(context),)
                                                      Divider(color: themeColor,),

                                                      SizedBox(
                                                        width: width(context)*0.95,
                                                        child: Row(
                                                          children: [
                                                            Column(
                                                              children: [
                                                                SizedBox( width: width(context)*0.4,child: FutureBuilder(future:changeLanguage("Market Center"),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                    baseColor: Colors.grey.shade300,
                                                                    highlightColor: Colors.white,child: Card(
                                                                  child: SizedBox(
                                                                    height: height(context)*0.014,
                                                                    width: width(context)*0.5,
                                                                  ),
                                                                )),)),

                                                                SizedBox( width: width(context)*0.4,child: FutureBuilder(future:changeLanguage('State'),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                    baseColor: Colors.grey.shade300,
                                                                    highlightColor: Colors.white,child: Card(
                                                                  child: SizedBox(
                                                                    height: height(context)*0.014,
                                                                    width: width(context)*0.5,
                                                                  ),
                                                                )),)),
                                                                SizedBox( width: width(context)*0.4,child: FutureBuilder(future:changeLanguage('Market District'),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                    baseColor: Colors.grey.shade300,
                                                                    highlightColor: Colors.white,child: Card(
                                                                  child: SizedBox(
                                                                    height: height(context)*0.014,
                                                                    width: width(context)*0.5,
                                                                  ),
                                                                )),)),
                                                                SizedBox( width: width(context)*0.4,child: FutureBuilder(future:changeLanguage('Modal Price'),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                    baseColor: Colors.grey.shade300,
                                                                    highlightColor: Colors.white,child: Card(
                                                                  child: SizedBox(
                                                                    height: height(context)*0.014,
                                                                    width: width(context)*0.5,
                                                                  ),
                                                                )),)),
                                                                SizedBox( width: width(context)*0.4,child: FutureBuilder(future:changeLanguage('Minimum Price'),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                    baseColor: Colors.grey.shade300,
                                                                    highlightColor: Colors.white,child: Card(
                                                                  child: SizedBox(
                                                                    height: height(context)*0.014,
                                                                    width: width(context)*0.5,
                                                                  ),
                                                                )),)),
                                                                SizedBox( width: width(context)*0.4,child: FutureBuilder(future:changeLanguage('Maximum Price'),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                    baseColor: Colors.grey.shade300,
                                                                    highlightColor: Colors.white,child: Card(
                                                                  child: SizedBox(
                                                                    height: height(context)*0.014,
                                                                    width: width(context)*0.5,
                                                                  ),
                                                                )),))
                                                              ],
                                                            ),
                                                            VerticalDivider(color: themeColor,thickness: 2,),
                                                            Column(
                                                              crossAxisAlignment:CrossAxisAlignment.start,
                                                              children: [
                                                                FutureBuilder(future:changeLanguage(mandiRecords[index].market),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                    baseColor: Colors.grey.shade300,
                                                                    highlightColor: Colors.white,child: Card(
                                                                  child: SizedBox(
                                                                    height: height(context)*0.014,
                                                                    width: width(context)*0.5,
                                                                  ),
                                                                )),),
                                                                FutureBuilder(future:changeLanguage(mandiRecords[index].state),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                    baseColor: Colors.grey.shade300,
                                                                    highlightColor: Colors.white,child: Card(
                                                                  child: SizedBox(
                                                                    height: height(context)*0.014,
                                                                    width: width(context)*0.5,
                                                                  ),
                                                                )),),
                                                                FutureBuilder(future:changeLanguage(mandiRecords[index].district),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                    baseColor: Colors.grey.shade300,
                                                                    highlightColor: Colors.white,child: Card(
                                                                  child: SizedBox(
                                                                    height: height(context)*0.014,
                                                                    width: width(context)*0.5,
                                                                  ),
                                                                )),),
                                                                FutureBuilder(future:changeLanguage(mandiRecords[index].modalPrice),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                    baseColor: Colors.grey.shade300,
                                                                    highlightColor: Colors.white,child: Card(
                                                                  child: SizedBox(
                                                                    height: height(context)*0.014,
                                                                    width: width(context)*0.5,
                                                                  ),
                                                                )),),
                                                                FutureBuilder(future:changeLanguage(mandiRecords[index].minPrice),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                    baseColor: Colors.grey.shade300,
                                                                    highlightColor: Colors.white,child: Card(
                                                                  child: SizedBox(
                                                                    height: height(context)*0.014,
                                                                    width: width(context)*0.5,
                                                                  ),
                                                                )),),
                                                                FutureBuilder(future:changeLanguage(mandiRecords[index].maxPrice),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                    baseColor: Colors.grey.shade300,
                                                                    highlightColor: Colors.white,child: Card(
                                                                  child: SizedBox(
                                                                    height: height(context)*0.014,
                                                                    width: width(context)*0.5,
                                                                  ),
                                                                )),),

                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                     /* Padding(
                                                          padding: const EdgeInsets.only(left: 5.0),
                                                          child: Row(
                                                            children: [
                                                              SizedBox( width: width(context)*0.3,child: FutureBuilder(future:changeLanguage("Market Center"),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                  baseColor: Colors.grey.shade300,
                                                                  highlightColor: Colors.white,child: Card(
                                                                child: SizedBox(
                                                                  height: height(context)*0.014,
                                                                  width: width(context)*0.5,
                                                                ),
                                                              )),)),
                                                              //SizedBox(width: 20,),
                                                              VerticalDivider(color: themeColor,thickness: 2,),
                                                              SizedBox(width: 20,),

                                                              FutureBuilder(future:changeLanguage(mandiRecords[index].market),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                  baseColor: Colors.grey.shade300,
                                                                  highlightColor: Colors.white,child: Card(
                                                                child: SizedBox(
                                                                  height: height(context)*0.014,
                                                                  width: width(context)*0.5,
                                                                ),
                                                              )),)
                                                              //Text( MandiList.records[index].market,)
                                                            ],
                                                          )

                                                        // Text('Market Center   :   '+MandiList.records[index].market),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5.0),
                                                        child:  Row(
                                                          children: [
                                                            SizedBox( width: width(context)*0.3,child: FutureBuilder(future:changeLanguage('State'),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                baseColor: Colors.grey.shade300,
                                                                highlightColor: Colors.white,child: Card(
                                                              child: SizedBox(
                                                                height: height(context)*0.014,
                                                                width: width(context)*0.5,
                                                              ),
                                                            )),)),
                                                            // SizedBox(width: 20,),
                                                            Text(":"),
                                                            SizedBox(width: 20,),
                                                            FutureBuilder(future:changeLanguage(mandiRecords[index].state),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                baseColor: Colors.grey.shade300,
                                                                highlightColor: Colors.white,child: Card(
                                                              child: SizedBox(
                                                                height: height(context)*0.014,
                                                                width: width(context)*0.5,
                                                              ),
                                                            )),)
                                                            //Text( MandiList.records[index].state,)
                                                          ],),

                                                        //Text('Market State      :   '+MandiList.records[index].state),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5.0),
                                                        child: Row(
                                                          children: [
                                                            SizedBox( width: width(context)*0.3,child: FutureBuilder(future:changeLanguage('Market District'),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                baseColor: Colors.grey.shade300,
                                                                highlightColor: Colors.white,child: Card(
                                                              child: SizedBox(
                                                                height: height(context)*0.014,
                                                                width: width(context)*0.5,
                                                              ),
                                                            )),)),
                                                            Text(":"),
                                                            SizedBox(width: 20,),
                                                            FutureBuilder(future:changeLanguage(mandiRecords[index].district),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                baseColor: Colors.grey.shade300,
                                                                highlightColor: Colors.white,child: Card(
                                                              child: SizedBox(
                                                                height: height(context)*0.014,
                                                                width: width(context)*0.5,
                                                              ),
                                                            )),)
                                                            //Text( MandiList.records[index].district,)
                                                          ],),


                                                        //Text('Market District   :   '+MandiList.records[index].district),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5.0),
                                                        child: Row(
                                                          children: [
                                                            SizedBox( width: width(context)*0.3,child: FutureBuilder(future:changeLanguage('Modal Price'),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                baseColor: Colors.grey.shade300,
                                                                highlightColor: Colors.white,child: Card(
                                                              child: SizedBox(
                                                                height: height(context)*0.014,
                                                                width: width(context)*0.5,
                                                              ),
                                                            )),)),
                                                            Text(":"),
                                                            SizedBox(width: 20,),
                                                            FutureBuilder(future:changeLanguage(mandiRecords[index].modalPrice),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                baseColor: Colors.grey.shade300,
                                                                highlightColor: Colors.white,child: Card(
                                                              child: SizedBox(
                                                                height: height(context)*0.014,
                                                                width: width(context)*0.5,
                                                              ),
                                                            )),)
                                                            //Text( mandiRecords[index].modalPrice,)
                                                          ],),

                                                        //Text('Model Price        :   '+MandiList.records[index].modalPrice),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5.0),
                                                        child: Row(
                                                          children: [
                                                            SizedBox( width: width(context)*0.3,child: FutureBuilder(future:changeLanguage('Minimum Price'),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                baseColor: Colors.grey.shade300,
                                                                highlightColor: Colors.white,child: Card(
                                                              child: SizedBox(
                                                                height: height(context)*0.014,
                                                                width: width(context)*0.5,
                                                              ),
                                                            )),)),
                                                            Text(":"),
                                                            SizedBox(width: 20,),
                                                            //Text( mandiRecords[index].minPrice,)
                                                            FutureBuilder(future:changeLanguage(mandiRecords[index].minPrice),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                baseColor: Colors.grey.shade300,
                                                                highlightColor: Colors.white,child: Card(
                                                              child: SizedBox(
                                                                height: height(context)*0.014,
                                                                width: width(context)*0.5,
                                                              ),
                                                            )),)
                                                          ],),

                                                        //Text('Min Price             :   '+MandiList.records[index].minPrice),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5.0),
                                                        child:
                                                        Row(
                                                          children: [
                                                            SizedBox( width: width(context)*0.3,child: FutureBuilder(future:changeLanguage('Maximum Price'),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                baseColor: Colors.grey.shade300,
                                                                highlightColor: Colors.white,child: Card(
                                                              child: SizedBox(
                                                                height: height(context)*0.014,
                                                                width: width(context)*0.5,
                                                              ),
                                                            )),)),
                                                            Text(":"),
                                                            SizedBox(width: 20,),
                                                            FutureBuilder(future:changeLanguage(mandiRecords[index].maxPrice),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                                baseColor: Colors.grey.shade300,
                                                                highlightColor: Colors.white,child: Card(
                                                              child: SizedBox(
                                                                height: height(context)*0.014,
                                                                width: width(context)*0.5,
                                                              ),
                                                            )),)
                                                            //Text( mandiRecords[index].maxPrice,)
                                                          ],),
                                                        //Text('Max Price            :   '+MandiList.records[index].maxPrice),
                                                      ),*/
                                                    ]
                                                ),
                                              );
                                            },
                                          )

                                      ),
                                    ]
                                )
                              ],
                            ),
                          ),
                        ]
                    ) :Container(
                      height:height(context)*0.6,
                      width: width(context)*0.95,
                      child: ListView.builder(
                          itemCount: 8,
                          itemBuilder: (context,index){
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.white,
                              child: Card(
                                elevation: 2.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children:[
                                        Padding(
                                            padding: const EdgeInsets.only(left: 15.0,top:8.0),
                                            child: Text('')
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5.0,right: 8.0),
                                          child: Divider(color: Colors.blueGrey,),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 5.0),
                                            child: Row(
                                              children: [
                                                SizedBox( width: width(context)*0.3,child: Text('')),
                                                //SizedBox(width: 20,),
                                                Text(":"),
                                                SizedBox(width: 20,),

                                                //FutureBuilder(future:changeLanguage(mandiRecords[index].market),builder: (context,i)=> Text(i.hasData?i.data:''),)
                                                Text( '')
                                              ],
                                            )

                                          // Text('Market Center   :   '+MandiList.records[index].market),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5.0),
                                          child:  Row(
                                            children: [
                                              SizedBox( width: width(context)*0.3,child: FutureBuilder(future:changeLanguage('State'),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                  baseColor: Colors.grey.shade300,
                                                  highlightColor: Colors.white,child: SizedBox(
                                                height: height(context)*0.014,
                                                width: width(context)*0.5,
                                              )),)),
                                              // SizedBox(width: 20,),
                                              Text(":"),
                                              SizedBox(width: 20,),
                                              Text( '')
                                            ],),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5.0),
                                          child: Row(
                                            children: [
                                              SizedBox( width: width(context)*0.3,child: Text('')),
                                              Text(":"),
                                              SizedBox(width: 20,),
                                              Text('')
                                            ],),


                                          //Text('Market District   :   '+MandiList.records[index].district),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5.0),
                                          child: Row(
                                            children: [
                                              SizedBox( width: width(context)*0.3,child: FutureBuilder(future:changeLanguage('Modal Price'),builder: (context,i)=> i.hasData?Text(i.data,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.0),):Shimmer.fromColors(
                                                  baseColor: Colors.grey.shade300,
                                                  highlightColor: Colors.white,child: SizedBox(
                                                height: height(context)*0.014,
                                                width: width(context)*0.5,
                                              )),)),
                                              Text(":"),
                                              SizedBox(width: 20,),
                                              Text( '')
                                            ],),

                                          //Text('Model Price        :   '+MandiList.records[index].modalPrice),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5.0),
                                          child: Row(
                                            children: [
                                              SizedBox( width: width(context)*0.3,child: Text('')),
                                              Text(":"),
                                              SizedBox(width: 20,),
                                              Text( '')
                                            ],),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5.0),
                                          child:
                                          Row(
                                            children: [
                                              SizedBox( width: width(context)*0.3,child: Text('')),
                                              Text(":"),
                                              SizedBox(width: 20,),
                                              Text('')
                                            ],),
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    )
                ),
              ],
            ),
          ),
          floatingActionButton:IconButton(
            color: Colors.blueGrey,
            icon: Icon(Icons.refresh),
            onPressed:(){
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => super.widget));
            },
          ),
        ),
      ),
    );
  }
}

class MandiModel {
  int created;
  int updated;
  String createdDate;
  String updatedDate;
  String active;
  String indexName;
  List<String> org;
  String orgType;
  String source;
  String title;
  String externalWsUrl;
  String visualizable;
  List<Field> field;
  int externalWs;
  String catalogUuid;
  List<String> sector;
  TargetBucket targetBucket;
  String desc;
  String message;
  String version;
  String status;
  int total;
  int count;
  String limit;
  String offset;
  List<Records> records;

  MandiModel(
      {this.created,
        this.updated,
        this.createdDate,
        this.updatedDate,
        this.active,
        this.indexName,
        this.org,
        this.orgType,
        this.source,
        this.title,
        this.externalWsUrl,
        this.visualizable,
        this.field,
        this.externalWs,
        this.catalogUuid,
        this.sector,
        this.targetBucket,
        this.desc,
        this.message,
        this.version,
        this.status,
        this.total,
        this.count,
        this.limit,
        this.offset,
        this.records});

  MandiModel.fromJson(Map<String, dynamic> json) {
    created = json['created'];
    updated = json['updated'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    active = json['active'];
    indexName = json['index_name'];
    org = json['org'].cast<String>();
    orgType = json['org_type'];
    source = json['source'];
    title = json['title'];
    externalWsUrl = json['external_ws_url'];
    visualizable = json['visualizable'];
    if (json['field'] != null) {
      field = new List<Field>();
      json['field'].forEach((v) {
        field.add(new Field.fromJson(v));
      });
    }
    externalWs = json['external_ws'];
    catalogUuid = json['catalog_uuid'];
    sector = json['sector'].cast<String>();
    targetBucket = json['target_bucket'] != null
        ? new TargetBucket.fromJson(json['target_bucket'])
        : null;
    desc = json['desc'];
    message = json['message'];
    version = json['version'];
    status = json['status'];
    total = json['total'];
    count = json['count'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['records'] != null) {
      records = new List<Records>();
      json['records'].forEach((v) {
        records.add(new Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['active'] = this.active;
    data['index_name'] = this.indexName;
    data['org'] = this.org;
    data['org_type'] = this.orgType;
    data['source'] = this.source;
    data['title'] = this.title;
    data['external_ws_url'] = this.externalWsUrl;
    data['visualizable'] = this.visualizable;
    if (this.field != null) {
      data['field'] = this.field.map((v) => v.toJson()).toList();
    }
    data['external_ws'] = this.externalWs;
    data['catalog_uuid'] = this.catalogUuid;
    data['sector'] = this.sector;
    if (this.targetBucket != null) {
      data['target_bucket'] = this.targetBucket.toJson();
    }
    data['desc'] = this.desc;
    data['message'] = this.message;
    data['version'] = this.version;
    data['status'] = this.status;
    data['total'] = this.total;
    data['count'] = this.count;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.records != null) {
      data['records'] = this.records.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Field {
  String name;
  String id;
  String type;

  Field({this.name, this.id, this.type});

  Field.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['type'] = this.type;
    return data;
  }
}

class TargetBucket {
  String field;
  String index;
  String type;

  TargetBucket({this.field, this.index, this.type});

  TargetBucket.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    index = json['index'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['field'] = this.field;
    data['index'] = this.index;
    data['type'] = this.type;
    return data;
  }
}

class Records {
  String state;
  String district;
  String market;
  String commodity;
  String variety;
  String arrivalDate;
  String minPrice;
  String maxPrice;
  String modalPrice;

  Records(
      {this.state,
        this.district,
        this.market,
        this.commodity,
        this.variety,
        this.arrivalDate,
        this.minPrice,
        this.maxPrice,
        this.modalPrice});

  Records.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    district = json['district'];
    market = json['market'];
    commodity = json['commodity'];
    variety = json['variety'];
    arrivalDate = json['arrival_date'];
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
    modalPrice = json['modal_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['district'] = this.district;
    data['market'] = this.market;
    data['commodity'] = this.commodity;
    data['variety'] = this.variety;
    data['arrival_date'] = this.arrivalDate;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['modal_price'] = this.modalPrice;
    return data;
  }
}

