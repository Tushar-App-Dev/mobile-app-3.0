import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constant/Constant.dart';
import 'CropDetails.dart';

class AddCropDetails extends StatefulWidget {
  const AddCropDetails({Key key}) : super(key: key);

  @override
  State<AddCropDetails> createState() => _AddCropDetailsState();
}

class _AddCropDetailsState extends State<AddCropDetails> {
  final DateTime now = DateTime.now();
  var selectedDate = "select date";


  //print(formatted); // something like 2013-04-20

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = DateFormat.yMd('es').format(picked).toString().replaceAll('/', '-');
      });
      
      //print(DateFormat.yMd('es').format(now));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        backgroundColor: Color(0xffECB34F),
        title: Text(
        "Add Crop Details",
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
            child: Image.asset('assets/new_images/back.png')
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height(context)*0.1,
                  child: Center(child: Text('Select Level of infection in your field',textAlign: TextAlign.left,))
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    //alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: width(context)*0.25,
                        height: width(context)*0.25,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10) ,
                        ),
                        child: Column(
                          children: [
                            ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)), child: Image.asset('assets/images/cropguide.png',height: width(context)*0.2,width: width(context)*0.25,fit: BoxFit.cover,)),
                            Text('Low')
                          ],
                        ),
                      ),
                      Positioned(
                        top: 8,
                          right: 8,
                          child: Icon(Icons.check_circle,color: Colors.green,size:15))
                    ],
                  ),
                  Container(
                    width: width(context)*0.25,
                    height: width(context)*0.25,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10) ,
                    ),
                    child: Column(
                      children: [
                        ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)), child: Image.asset('assets/images/cropguide.png',height: width(context)*0.2,width: width(context)*0.25,fit: BoxFit.cover,)),

                        Text('Medium')
                      ],
                    ),
                  ),
                  Container(
                    width: width(context)*0.25,
                    height: width(context)*0.25,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10) ,
                    ),
                    child: Column(
                      children: [
                        ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)), child: Image.asset('assets/images/cropguide.png',height: width(context)*0.2,width: width(context)*0.25,fit: BoxFit.cover,)),
                        Text('Large')
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height:height(context)*0.02,),
              Container(
                width: width(context)*0.95,
                height: height(context)*0.15,
               //margin: EdgeInsets.symmetric(vertical: 12.0),
               // padding: EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Select the date of transpering for tomato'),
                        GestureDetector(
                          onTap: (){
                            _selectDate(context);

                          },
                          child: Container(
                            width: width(context)*0.26,
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 1,color: Colors.grey)
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_outlined,size: 12,color: Colors.orange,),
                                SizedBox(width: 5,),
                                Expanded(child: Text(selectedDate,style: TextStyle(fontSize: 12),))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height:height(context)*0.02,),
              Container(
                width: width(context)*0.95,
                height: height(context)*0.15,
               // padding: EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Enter Sowing Area for tomato'),
                        Container(
                          width: width(context)*0.25,
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(width: 1,color: Colors.grey)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                             Text("0.00",style: TextStyle(fontSize: 12),),
                              //SizedBox(width: 5,),
                              Text("acre",style: TextStyle(fontSize: 12),)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height:height(context)*0.01,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> Instructions()));
                },
                child: Container(
                  height: height(context)*0.050,
                  width: width(context)*0.30,
                  margin: EdgeInsets.only(top: 15,left: 8),
                  decoration: BoxDecoration(
                    color: Color(0xffECB34F),
                    borderRadius: BorderRadius.circular(5),

                  ),
                  child: Center(child: Text('Submit',style: TextStyle(color: Colors.white),)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class Instructions extends StatefulWidget {
  const Instructions({Key key}) : super(key: key);

  @override
  State<Instructions> createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions> {
  @override
  Widget build(BuildContext context) {

    // Get disease from provider
    // final _diseaseService = Provider.of<DiseaseService>(context);
    //
    // // Hive service
    // HiveService _hiveService = HiveService();
    //
    // // Data
    // final Classifier classifier = Classifier();
    // Disease _disease;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        backgroundColor: Color(0xffECB34F),
        title: Text(
         "Instructions",
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
      body: Container(
        height: height(context)*0.65,
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: height(context)*0.07),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 10,
          child: Column(
            children: [
              SizedBox(
                height: height(context)*0.06,
                  child: Center(child: Text('How to Take Pictures?',style: TextStyle(
                    color: Color(0xffECB34F),
                    fontWeight: FontWeight.w700
                  ),))
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    //alignment: Alignment.bottomRight,
                    children: [
                      Container(

                        height: height(context)*0.3,
                        width: width(context)*0.4,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)

                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(Icons.check_circle,color: Colors.green,size: 20,),
                        ),
                      )
                    ],
                  ),
                  Stack(
                    //alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: height(context)*0.3,
                        width: width(context)*0.4,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)

                        ),
                      ),
                      const Positioned(
                        bottom: 10,
                        right: 10,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Icon(Icons.check_circle,color: Colors.green,size: 20,),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: height(context)*0.03,),
              Text('Distance',style: TextStyle(
                  color: Color(0xffECB34F),
                  fontWeight: FontWeight.w700
              )),
              SizedBox(height: height(context)*0.015,),
              Text("Keep the camera close to the plant"),
              SizedBox(height: height(context)*0.05,),
              Row(
                children: [
                  Container(

                  ),

                ],
              ),
              SizedBox(height: height(context)*0.03,),
              // GestureDetector(
              //   onTap: () async {
              //
              //     double _confidence;
              //     await classifier.getDisease(ImageSource.gallery).then((value) {
              //
              //       print(value);
              //
              //       _confidence = value[0]['confidence'];
              //
              //     });
              //
              //     if (_confidence > 0.2) { //0.8
              //       //Set disease for Disease Service
              //       _diseaseService.setDiseaseValue(_disease);
              //
              //       // Save disease
              //       _hiveService.addDisease(_disease);
              //
              //       Navigator.push(context, MaterialPageRoute(builder: (context)=>const CropDetails()));
              //     }
              //     else {
              //       // Display unsure message
              //
              //     }
              //   },
              //   child: Container(
              //     height: height(context)*0.040,
              //     width: width(context)*0.25,
              //     margin: EdgeInsets.only(top: 15,left: 5),
              //     decoration: BoxDecoration(
              //       color: Color(0xffECB34F),
              //       borderRadius: BorderRadius.circular(5),
              //
              //     ),
              //     child: Center(child: Text('Submit',style: TextStyle(color: Colors.white),)),
              //   ),
              // ),
              SizedBox(height: height(context)*0.02,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> CropDetails()));
                },
                  child: Text("Skip")
              )
            ],
          ),
        ),
      ),
    );
  }
}

