import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                      title: const Text('MAP MY CROP',
                          style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: 'GothicA1',)
                      ),
                    leading:Image.asset("assets/images/mapmycrop_logo1.png"),
                  ),
                ),
                const SizedBox(height: 10.0,),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Terms and Conditions',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: 'GothicA1',color: Colors.green[900]),textAlign: TextAlign.justify,),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Welcome to Map My Crop!",textAlign: TextAlign.justify,style: TextStyle(fontFamily: 'GothicA1',color: Colors.grey),),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("These terms and conditions outline the rules and regulations for the use of Hardcastle Agrotech Solutions Private Limited’s Website, located at https://www.mapmycrop.com.\n\n"
                   "By accessing this website we assume you accept these terms and conditions. Do not continue to use Map My Crop if you do not agree to take all of the terms and conditions stated on this page.\n\n"
                    "The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: “Client”, “You” and “Your” refers to you, the person log on this website and compliant to the Company’s terms and conditions. “The Company”, “Ourselves”, “We”, “Our” and “Us”, refers to our Company. “Party”, “Parties”, or “Us”, refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client’s needs in respect of provision of the Company’s stated services, in accordance with and subject to, prevailing law of Netherlands. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same.",
                    textAlign: TextAlign.justify,style: TextStyle(fontFamily: 'GothicA1',color: Colors.grey),),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Cookies',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: 'GothicA1',color: Colors.green[900]),textAlign: TextAlign.justify,),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("We employ the use of cookies. By accessing Map My Crop, you agreed to use cookies in agreement with the Hardcastle Agrotech Solutions Private Limited’s Privacy Policy.\n\n"
                      "Most interactive websites use cookies to let us retrieve the user’s details for each visit. Cookies are used by our website to enable the functionality of certain areas to make it easier for people visiting our website. Some of our affiliate/advertising partners may also use cookies.",
                    style: TextStyle(fontFamily: 'GothicA1',color: Colors.grey),textAlign: TextAlign.justify,),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('License',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: 'GothicA1',color: Colors.green[900]),textAlign: TextAlign.justify,),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Unless otherwise stated, Hardcastle Agrotech Solutions Private Limited and/or its licensors own the intellectual property rights for all material on Map My Crop. All intellectual property rights are reserved. You may access this from Map My Crop for your own personal use subjected to restrictions set in these terms and conditions.\n\n"
                      "You must not:\n"
                      "• Republish material from Map My Crop\n"
                      "• Sell, rent or sub-license material from Map My Crop\n"
                      "• Reproduce, duplicate or copy material from Map My Crop\n"
                      "• Redistribute content from Map My Crop",
                      style: TextStyle(fontFamily: 'GothicA1',color: Colors.grey),textAlign: TextAlign.justify,),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("This Agreement shall begin on the date hereof. Our Terms and Conditions were created with the help of the Terms And Conditions Generator.\n\n"
                      "Parts of this website offer an opportunity for users to post and exchange opinions and information in certain areas of the website. Hardcastle Agrotech Solutions Private Limited does not filter, edit, publish or review Comments prior to their presence on the website. Comments do not reflect the views and opinions of Hardcastle Agrotech Solutions Private Limited,its agents and/or affiliates. Comments reflect the views and opinions of the person who post their views and opinions. To the extent permitted by applicable laws, Hardcastle Agrotech Solutions Private Limited shall not be liable for the Comments or for any liability, damages or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the Comments on this website.\n"
                      "Hardcastle Agrotech Solutions Private Limited reserves the right to monitor all Comments and to remove any Comments which can be considered inappropriate, offensive or causes breach of these Terms and Conditions.\n",
                    style: TextStyle(fontFamily: 'GothicA1',color: Colors.grey,),textAlign: TextAlign.justify,),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("You warrant and represent that:\n\n"
                      "• You are entitled to post the Comments on our website and have all necessary licenses and consents to do so;\n"
                      "• The Comments do not invade any intellectual property right, including without limitation copyright, patent or trademark of any third party;\n"
                      "• The Comments do not contain any defamatory, libelous, offensive, indecent or otherwise unlawful material which is an invasion of privacy\n"
                      "• The Comments will not be used to solicit or promote business or custom or present commercial activities or unlawful activity.\n\n"
                      "You hereby grant Hardcastle Agrotech Solutions Private Limited a non-exclusive license to use, reproduce, edit and authorize others to use, reproduce and edit any of your Comments in any and all forms, formats or media.",
                    style: TextStyle(fontFamily: 'GothicA1',color: Colors.grey),textAlign: TextAlign.justify,),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('iFrames',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: 'GothicA1',color: Colors.green[900]),textAlign: TextAlign.justify,),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Without prior approval and written permission, you may not create frames around our Webpages that alter in any way the visual presentation or appearance of our Website.",
                    style: TextStyle(fontFamily: 'GothicA1',color: Colors.grey),textAlign: TextAlign.justify,),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Content Liability',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: 'GothicA1',color: Colors.green[900]),textAlign: TextAlign.justify,),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("We shall not be hold responsible for any content that appears on your Website. You agree to protect and defend us against all claims that is rising on your Website. No link(s) should appear on any Website that may be interpreted as libelous, obscene or criminal, or which infringes, otherwise violates, or advocates the infringement or other violation of, any third party rights.",
                    style: TextStyle(fontFamily: 'GothicA1',color: Colors.grey),textAlign: TextAlign.justify,),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Your Privacy',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: 'GothicA1',color: Colors.green[900]),textAlign: TextAlign.justify,),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Please read Privacy Policy",
                    style: TextStyle(fontFamily: 'GothicA1',color: Colors.grey),textAlign: TextAlign.justify,),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Reservation of Rights',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: 'GothicA1',color: Colors.green[900]),textAlign: TextAlign.justify,),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("We reserve the right to request that you remove all links or any particular link to our Website. You approve to immediately remove all links to our Website upon request. We also reserve the right to amen these terms and conditions and it’s linking policy at any time. By continuously linking to our Website, you agree to be bound to and follow these linking terms and conditions.",
                    style: TextStyle(fontFamily: 'GothicA1',color: Colors.grey),textAlign: TextAlign.justify,),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Removal of links from our website',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: 'GothicA1',color: Colors.green[900]),textAlign: TextAlign.justify,),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("If you find any link on our Website that is offensive for any reason, you are free to contact and inform us any moment. We will consider requests to remove links but we are not obligated to or so or to respond to you directly.\n"
                    "We do not ensure that the information on this website is correct, we do not warrant its completeness or accuracy; nor do we promise to ensure that the website remains available or that the material on the website is kept up to date.",
                    style: TextStyle(fontFamily: 'GothicA1',color: Colors.grey),textAlign: TextAlign.justify,),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Disclaimer',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: 'GothicA1',color: Colors.green[900]),textAlign: TextAlign.justify,),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("To the maximum extent permitted by applicable law, we exclude all representations, warranties and conditions relating to our website and the use of this website. Nothing in this disclaimer will:\n"
                      "• limit or exclude our or your liability for death or personal injury;\n"
                      "• limit or exclude our or your liability for fraud or fraudulent misrepresentation;\n"
                      "• limit any of our or your liabilities in any way that is not permitted under applicable law; or\n"
                      "• exclude any of our or your liabilities that may not be excluded under applicable law.\n\n"
                    "The limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer: (a) are subject to the preceding paragraph; and (b) govern all liabilities arising under the disclaimer, including liabilities arising in contract, in tort and for breach of statutory duty.\n\n"
                    "As long as the website and the information and services on the website are provided free of charge, we will not be liable for any loss or damage of any nature.",
                    style: TextStyle(fontFamily: 'GothicA1',color: Colors.grey),textAlign: TextAlign.justify,),
                ),
              ],
            ),
          ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_back),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white, onPressed: () {
        Navigator.pop(context);
      },
      ),
    );
  }
}
