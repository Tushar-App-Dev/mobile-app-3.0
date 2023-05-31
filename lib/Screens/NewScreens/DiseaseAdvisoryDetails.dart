import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mmc_master/Model/DiseasAdvisoryModel.dart';
import 'package:mmc_master/constants/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:text_to_speech/text_to_speech.dart';

import '../constant/Constant.dart';

class DiseaseAdvisoryDetails extends StatefulWidget {
  final DiseaseAdvisoryModel data;
  const DiseaseAdvisoryDetails({Key key, this.data}) : super(key: key);

  @override
  State<DiseaseAdvisoryDetails> createState() => _DiseaseAdvisoryDetailsState();
}

class _DiseaseAdvisoryDetailsState extends State<DiseaseAdvisoryDetails> {
  final String defaultLanguage = 'en-US';
  //String text = '';
  double volume = 1; // Range: 0-1
  double rate = 1.0; // Range: 0-2
  double pitch = 1.0;
  TextToSpeech tts = TextToSpeech();
  String language;
  String languageCode;
  List<String> languages = <String>[];
  List<String> languageCodes = <String>[];
  String voice;
  String translatedString = '';
  bool symptomsRunning = false;
  bool causeRunning = false;
  bool preventionRunning = false;
  bool chemicalRunning = false;
  bool organicRunning = false;

  Future<void> speak(String text) async {
    print('the text in speak is $text');
    tts.setVolume(volume);
    tts.setRate(rate);
    if (languageCode != null) {
      tts.setLanguage(languageCode);
    }
    tts.setPitch(pitch);
    tts.speak(text);
    print(await tts.speak(text));
  }

  Future<void> initLanguages() async {
    /// populate lang code (i.e. en-US)
    languageCodes = await tts.getLanguages();

    /// populate displayed language (i.e. English)
    final List<String> displayLanguages = await tts.getDisplayLanguages();
    if (displayLanguages == null) {
      return;
    }

    languages.clear();
    for (final dynamic lang in displayLanguages) {
      languages.add(lang as String);
    }

    final String defaultLangCode = await tts.getDefaultLanguage();
    if (defaultLangCode != null && languageCodes.contains(defaultLangCode)) {
      languageCode = defaultLangCode;
    } else {
      languageCode = defaultLanguage;
    }
    language = await tts.getDisplayLanguageByCode(languageCode);

    /// get voice
    voice = await getVoiceByLang(languageCode);

    if (mounted) {
      setState(() {});
    }
  }

  Future<String> getVoiceByLang(String lang) async {
    final List<String> voices = await tts.getVoiceByLang(languageCode);
    if (voices != null && voices.isNotEmpty) {
      return voices.first;
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      initLanguages();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Color(0xffECB34F),
          title: ChangedLanguage(
            text: "Disease Advisory",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: "Inter",
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: InkWell(
              onTap: () {
                tts.stop();
                Navigator.pop(context);
              },
              child: Image.asset('assets/new_images/back.png')),
        ),
        body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: ChangedLanguage(
                  text: widget.data.name,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                )
                //Text(widget.data.name,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: /*CachedNetworkImage(
                    height:height(context)*0.15,
                    width: width(context)*0.38,
                    fit: BoxFit.fill,
                    imageUrl: widget.data.pre+widget.data.folderName+widget.data.image1+'.'+widget.data.fileFormat,
                    //placeholder: (context, url) => new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Image.network('https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?s=612x612&w=0&k=20&c=PM_optEhHBTZkuJQLlCjLz-v3zzxp-1mpNQZsdjrbns='),
                  ),*/
                    Image.network(widget.data.pre + widget.data.folderName + widget.data.image1 + '.' + widget.data.fileFormat,
                  fit: BoxFit.fill,
                  errorBuilder: (context, object, stacktrace) => Image.network(
                      'https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?s=612x612&w=0&k=20&c=PM_optEhHBTZkuJQLlCjLz-v3zzxp-1mpNQZsdjrbns='),
                  height: height(context) * 0.25,
                  width: width(context) * 0.90,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChangedLanguage(
                    text: 'Symptoms',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  // Text('Symptoms',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                  Row(
                    children: [
                      // Icons.volume_up_outlined : Icons.volume_off_outlined
                      Icon(!symptomsRunning ? Icons.mic_outlined : Icons.pause)
                          .onTap(() async {
                        translatedString =
                            await changeLanguage(widget.data.symptoms);
                        if (!symptomsRunning) {
                          setState(() {
                            symptomsRunning = true;
                            causeRunning = false;
                            preventionRunning = false;
                            chemicalRunning = false;
                            organicRunning = false;
                          });
                          speak(translatedString);
                        } else {
                          setState(() {
                            symptomsRunning = false;
                            tts.stop();
                          });
                        }
                      }),
                    ],
                  )
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: ChangedLanguage(
                  text: widget.data.symptoms,
                  textAlign:TextAlign.justify,
                  style: TextStyle(fontSize: 16),
                )

                //Text(widget.data.symptoms,textAlign: TextAlign.justify,style: TextStyle(fontSize: 16),),
                ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChangedLanguage(
                    text: 'Causes of Disease',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  //Text('Causes of Disease',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                  Icon(!causeRunning ? Icons.mic_outlined : Icons.pause)
                      .onTap(() async {
                    translatedString = await changeLanguage(widget.data.causes);
                    if (!causeRunning) {
                      setState(() {
                        symptomsRunning = false;
                        causeRunning = true;
                        preventionRunning = false;
                        chemicalRunning = false;
                        organicRunning = false;
                      });
                      speak(translatedString);
                    } else {
                      setState(() {
                        causeRunning = false;
                        tts.stop();
                      });
                    }
                  }),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: ChangedLanguage(
                  text: widget.data.causes,
                  textAlign:TextAlign.justify,
                  style: TextStyle(fontSize: 16),
                )
                //Text(widget.data.causes,textAlign: TextAlign.justify,style: TextStyle(fontSize: 16),),
                ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChangedLanguage(
                    text: 'Preventive Measures',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  //Text('Preventive Measures',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                  Icon(!preventionRunning ? Icons.mic_outlined : Icons.pause)
                      .onTap(() async {
                    translatedString =
                        await changeLanguage(widget.data.preventiveMeasures);
                    if (!preventionRunning) {
                      setState(() {
                        symptomsRunning = false;
                        causeRunning = false;
                        preventionRunning = true;
                        chemicalRunning = false;
                        organicRunning = false;
                      });
                      speak(translatedString);
                    } else {
                      setState(() {
                        preventionRunning = false;
                        tts.stop();
                      });
                    }
                  }),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: ChangedLanguage(
                  text: widget.data.preventiveMeasures,
                  textAlign:TextAlign.justify,
                  style: TextStyle(fontSize: 16),
                )
                //Text(widget.data.preventiveMeasures,textAlign: TextAlign.justify,style: TextStyle(fontSize: 16),),
                ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChangedLanguage(
                    text: 'Chemical Control',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  // Text('Chemical Control',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                  Icon(!chemicalRunning ? Icons.mic_outlined : Icons.pause)
                      .onTap(() async {
                    translatedString =
                        await changeLanguage(widget.data.chemicalControl);
                    if (!chemicalRunning) {
                      setState(() {
                        symptomsRunning = false;
                        causeRunning = false;
                        preventionRunning = false;
                        chemicalRunning = true;
                        organicRunning = false;
                      });
                      speak(translatedString);
                    } else {
                      setState(() {
                        chemicalRunning = false;
                        tts.stop();
                      });
                    }
                  }),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: ChangedLanguage(
                    text: widget.data.chemicalControl,
                    textAlign:TextAlign.justify,
                    style: TextStyle(fontSize: 16))
                //Text(widget.data.chemicalControl,textAlign: TextAlign.justify,style: TextStyle(fontSize: 16),),
                ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChangedLanguage(
                    text: 'Organic Control',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  // Text('Organic Control',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
                  Icon(!organicRunning ? Icons.mic_outlined : Icons.pause)
                      .onTap(() async {
                    translatedString =
                        await changeLanguage(widget.data.organicControl);
                    if (!organicRunning) {
                      setState(() {
                        symptomsRunning = false;
                        causeRunning = false;
                        preventionRunning = false;
                        chemicalRunning = false;
                        organicRunning = true;
                      });
                      speak(translatedString);
                    } else {
                      setState(() {
                        organicRunning = false;
                        tts.stop();
                      });
                    }
                  }),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: ChangedLanguage(
                    text: widget.data.organicControl,
                    textAlign:TextAlign.justify,
                    style: TextStyle(fontSize: 16))
                //Text(widget.data.organicControl,textAlign: TextAlign.justify,style: TextStyle(fontSize: 16),),
                ),
          ]),
        ),
      ),
    );
  }
  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      //Toast.show("Please Press again to exit", context, duration: Toast.LENGTH_LONG);
      Fluttertoast.showToast(
          msg: "Please Press again to exit", toastLength: Toast.LENGTH_LONG);
      return Future.value(false);
    }
    tts.stop();
    return Future.value(true);
  }
}



