import'package:flutter/material.dart';

import '../constant/Constant.dart';
class DetectedDiseaseDetails extends StatefulWidget {
  const DetectedDiseaseDetails({Key key}) : super(key: key);

  @override
  State<DetectedDiseaseDetails> createState() => _DetectedDiseaseDetailsState();
}

class _DetectedDiseaseDetailsState extends State<DetectedDiseaseDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disease Details'),
      ),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: height(context)*0.2,
                height: height(context)*0.2,

                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height(context)*0.5),
                  image: DecorationImage(
                    image: NetworkImage('https://images.pexels.com/photos/15022334/pexels-photo-15022334.jpeg'),
                    fit: BoxFit.fill,
                  )
                ),
              ),
            ),
            Center(child: Text('Crop name',textAlign: TextAlign.center,)),
            Center(child: Text('Disease name',textAlign: TextAlign.center,)),
            Text("Symptoms"),
            Text('The primary symptom of cotton leaf curl virus is the upward curling of leaves. Additionally, leaf veins can thicken and darken, and outgrowths (enactions) may form on the undersides of leaves, typically in the shape of leaves. Flowers may stay closed and then drop along with the bolls. If plants are infected early in the season, their growth will be stunted and yield will be reduced significantly.',textAlign: TextAlign.justify,)

          ],
        ),
      ),
    );
  }
}
