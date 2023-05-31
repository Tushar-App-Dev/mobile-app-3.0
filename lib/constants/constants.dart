import 'package:flutter/material.dart';
import 'package:mmc_master/Screens/constant/Constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:translator/translator.dart';

const kMain = Color(0xff00ad59);
const kAccent = Color(0xff1ca800);
const kSecondary = Color(0xff626463);
const kWhite = Color(0xffffffff);

class ImageDialog extends StatelessWidget {
  final text;
  final onTap;

  const ImageDialog({Key key, @required this.text, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Container(
        width: 200,
        height: 280,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: height(context) * 0.05, bottom: height(context) * 0.035),
              height: height(context) * 0.08,
              width: height(context) * 0.08,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          ExactAssetImage('assets/images/mapmycrop_logo1.png'),
                      fit: BoxFit.cover)),
            ),
            Text(text),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 70,
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ).onTap(() {
                  Navigator.pop(context);
                }),
                Container(
                  width: 70,
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.orange),
                  child: Center(
                    child: Text(
                      'Okay',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ).onTap(onTap)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ImageDialog1 extends StatelessWidget {
  final text;

  const ImageDialog1({Key key, @required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Container(
        // decoration: BoxDecoration(
        //   color:Colors.grey,
        //   borderRadius: BorderRadius.circular(30),
        // ),

        width: 200,
        height: 280,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: height(context) * 0.05, bottom: height(context) * 0.035),
              height: height(context) * 0.08,
              width: height(context) * 0.08,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          ExactAssetImage('assets/images/mapmycrop_logo1.png'),
                      fit: BoxFit.cover)),
            ),
            Text(text),
            SizedBox(
              height: 25,
            ),
            Container(
              width: 70,
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.orange),
              child: Center(
                child: Text(
                  'Okay',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ).onTap(() {
              Navigator.pop(context);
            })
          ],
        ),
      ),
    );
  }
}

showWarningDialog(BuildContext context, text, onTap) async {
  await showDialog(
      context: context, builder: (_) => ImageDialog(text: text, onTap: onTap));
}

showInfoDialog(BuildContext context, text) async {
  await showDialog(context: context, builder: (_) => ImageDialog1(text: text));
}

class ChangedLanguage extends StatefulWidget {
  const ChangedLanguage({Key key, this.text, this.style, this.textAlign})
      : super(key: key);
  final text;
  final style;
  final textAlign;
  @override
  State<ChangedLanguage> createState() => _ChangedLanguageState();
}

class _ChangedLanguageState extends State<ChangedLanguage> {
  var finalResult = '';

  changedLanguage(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print('called with $language');
    GoogleTranslator translator = await GoogleTranslator();
    //print(translator);
    // print('The text is $text and the language is ${prefs.getString("language")}');
    // Using the Future API
    await translator.translate(text, to: prefs.getString('language')).then((result) {
      // print("Source: $text\nTranslated: $result");
      setState(() {
        finalResult = "$result";
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changedLanguage(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    // print(finalResult);
    return Text(
      finalResult,
      style: widget.style,
      textAlign: widget.textAlign,
    );
  }
}

changeLanguage(String text) async {
  final translator = GoogleTranslator();
  final input = text;
  String finalResult;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  translator
      .translate(input, from: 'en', to: prefs.getString('language'))
      .then((result) {
    // print("Source: $input\nTranslated: $result");
    // setState((){})
    finalResult = ' $result';
  });
  // print(finalResult);
  do {
    await Future.delayed(Duration(milliseconds: 10));
  } while (finalResult == null);
  return finalResult;
}
