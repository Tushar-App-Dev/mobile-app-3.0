import 'package:flutter/material.dart';
import 'package:mmc_master/Authentication/LoginPageActivity.dart';
import 'package:mmc_master/Screens/NewScreens/ContactUsActivity.dart';
import 'package:mmc_master/Screens/NewScreens/PrivacyPolicyAcivity.dart';
import 'package:mmc_master/Screens/NewScreens/TermsAndConditionActivity.dart';
import 'package:provider/src/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Authentication/ForgtPasswordActivity.dart';
import '../ChangeLanguageNotifier.dart';
import '../constants/constants.dart';
import '../generated/l10n.dart';

class Setting extends StatefulWidget {
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        backgroundColor: const Color(0xffECB34F),
        title:  ChangedLanguage(text:
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: "Inter",
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/new_images/back.png')),
      ),

        body: SafeArea(
          bottom: true,
          child: LayoutBuilder(
              builder:(builder,constraints)=> SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ChangedLanguage(text:
                              S.of(context).General,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ),
                        ListTile(
                            title: ChangedLanguage(text:S.of(context).Language),
                            leading: Image.asset('assets/icon/language.png',color: Colors.black,),
                            onTap: () =>{
                            }
                        ),

                        ListTile(
                          title: ChangedLanguage(text:S.of(context).notifi),
                          leading: Image.asset('assets/icon/notifications.png',color: Colors.black,),
                          onTap: () => {},
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0,right: 10),
                          child: Divider(color:Colors.grey,thickness: 2,),
                        ),
                        ListTile(
                          title: ChangedLanguage(text:S.of(context).Terms),
                          leading: Image.asset('assets/icon/legal.png',color: Colors.black,),
                          onTap: () =>
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const TermsAndConditionActivity())),
                        ),
                        ListTile(
                          title: ChangedLanguage(text:S.of(context).Privacy),
                          leading: const Icon(Icons.account_circle_sharp,color: Colors.black,),
                          onTap: () =>
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const PrivacyPolicyActivity())),
                        ),
                        ListTile(
                          title: ChangedLanguage(text:'Contact'),
                          leading: Image.asset('assets/icon/about_us.png',color: Colors.black,),
                          onTap: () async{
                            await launch('tel://7066006625');
                          }
                              // Navigator.of(context).push(
                              // MaterialPageRoute(builder: (_) => const ContactUsActivity())),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0,right: 10),
                          child: Divider(color:Colors.grey,thickness: 2,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: ChangedLanguage(text:
                              S.of(context).Account,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ),
                        ListTile(
                          title: ChangedLanguage(text:S.of(context).password),
                          leading: Image.asset('assets/icon/change_pass.png',color: Colors.black,),
                          onTap: () =>{},
                              // Navigator.of(context).push(
                              // MaterialPageRoute(builder: (context) => const ForgtPasswordActivity())
                              // ),
                        ),
                        ListTile(
                          title: ChangedLanguage(text:"Logout"),
                          leading: Image.asset('assets/icon/sign_out.png',color: Colors.black,),
                          onTap: () async {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.confirm,
                                title:await changeLanguage('Are You Sure?'),
                                text:await changeLanguage('Do you want to logout'),
                                confirmBtnText: await changeLanguage('Yes'),
                                cancelBtnText: await changeLanguage('No'),
                                confirmBtnColor: Colors.green,
                                //customAsset: 'assets/new_images/logo.png',
                                onCancelBtnTap: () {
                                  Navigator.pop(context);
                                },
                                onConfirmBtnTap: () async {
                                  SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                                  prefs.setBool('_isLoggedIn', false);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                          const LoginPageActivity()));
                                });
                            // SharedPreferences prefs = await SharedPreferences.getInstance();
                            // prefs.setBool('_isLoggedIn', false);
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (BuildContext context) => const LoginPageActivity()));
                            },
                        ),

                      ],
                    ),
                  ),
                ),
              )
          ),
        ),
    );
  }
  void _showlangDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  Center(
              child: ChangedLanguage(text:
                S.of(context).change,
                style: const TextStyle(
                  color: Color(0xcc000000),
                  fontSize: 17,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            //ChangedLanguage(text:S.of(context).change), //ChangedLanguage(text:"Change app language"),
            actions: <Widget>[
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 200.0,
                      child: MaterialButton(
                        onPressed: () async {
                          context
                              .read<LanguageChangeProvider>()
                              .changeLocale("hi");
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          prefs.setString('language', "hi");
                          Navigator.pop(context);
                          print(Localizations.localeOf(context).toString());
                        },
                        child: ChangedLanguage(text:
                          S.of(context).Hindi, //ChangedLanguage(text:"Hindi",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        color: const Color(0xffECB34F),
                      ),
                    ),
                    SizedBox(
                      width: 200.0,
                      child: MaterialButton(
                        onPressed: () async {
                          context
                              .read<LanguageChangeProvider>()
                              .changeLocale("en");
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          prefs.setString('language', "en");
                          Navigator.pop(context);
                          // print(Localizations.localeOf(context).toString());
                        },
                        child: ChangedLanguage(text:
                          S.of(context).English, //ChangedLanguage(text:"English",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        color: const Color(0xfff7941e),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}