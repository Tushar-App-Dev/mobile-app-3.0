import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
     body: Column(
       mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment:CrossAxisAlignment.start,
       children: [
         Padding(
           padding: const EdgeInsets.all(15.0),
           child: Text(
             "Send Feedback",style: TextStyle(fontSize:20.0),),
         ),
         Padding(
           padding: const EdgeInsets.all(12.0),
           child: Container(
             padding: EdgeInsets.only(top: 8.0, bottom:8.0),
             child: TextFormField(
               style: new TextStyle(color: Colors.black),
               keyboardType: TextInputType.text,
               decoration: InputDecoration(
                   focusedBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.black),
                       borderRadius: BorderRadius.all(Radius.circular(10))),
                   enabledBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.black),
                       borderRadius: BorderRadius.all(Radius.circular(10))),
                   // hintText: 'Enter your product title',
                   labelStyle: TextStyle(color: Colors.black),
                   labelText: 'Add Your feedback here', floatingLabelBehavior: FloatingLabelBehavior.auto),
               onSaved: (String value) {

               },
             ),
           ),
         ),
       ],
     ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          color: Colors.green[800],
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              side: BorderSide(color: Colors.black)),
          padding: EdgeInsets.only(left: 50, right: 50),
          // color: Theme.of(context).buttonColor,
          textColor: Colors.black,
          child: Text('Submit Feedback'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
