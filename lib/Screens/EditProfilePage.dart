import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String username;
  final String email;
  final String phone;
  const EditProfilePage({Key key, this.username, this.email, this.phone}) : super(key: key);
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  bool _isEditingText = false;
  TextEditingController _editingController;
  String initialText = "Initial Text";
  bool showPassword = false;
  String uid,email,phone,username;
  var dataValue;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: initialText);
    //fetchUserData();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title:  Text(
          "Edit Profile",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.grey),
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                "https://p.kindpng.com/picc/s/668-6689202_avatar-profile-hd-png-download.png",
                              ))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.green,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              TextFormField(
                readOnly: true,
                //cursorColor: Theme.of(context).cursorColor,
                initialValue:widget.username,
                //maxLength: 20,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                readOnly: true,
                //cursorColor: Theme.of(context).cursorColor,
                initialValue:widget.email !=null ? widget.email:'',
                //maxLength: 20,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                //readOnly: true,
                //cursorColor: Theme.of(context).cursorColor,
                initialValue:widget.phone != null ?widget.phone:phone,
                //maxLength: 20,
                decoration: InputDecoration(
                  labelText: 'Mobile No',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                //readOnly: true,
                //cursorColor: Theme.of(context).cursorColor,
                initialValue:' ',
                //maxLength: 20,
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(
                    color:Colors.grey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                //readOnly: true,
                //cursorColor: Theme.of(context).cursorColor,
                initialValue:' ',
                //maxLength: 20,
                decoration: InputDecoration(
                  labelText: 'City',
                  labelStyle: TextStyle(
                    color:Colors.grey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                //readOnly: true,
                //cursorColor: Theme.of(context).cursorColor,
                initialValue:' ',
                //maxLength: 20,
                decoration: InputDecoration(
                  labelText: 'State',
                  labelStyle: TextStyle(
                    color:Colors.grey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                //readOnly: true,
                //cursorColor: Theme.of(context).cursorColor,
                initialValue:'',
                //maxLength: 20,
                decoration: InputDecoration(
                  labelText: 'Country',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      Navigator.pop(context);
                      },
                    child: Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0,),
      child: TextField(
                   decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                      labelText: labelText,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: placeholder,
                      hintStyle: TextStyle(
                      fontSize: 16,
                      //fontWeight: FontWeight.bold,
                      color: Colors.black,
            )),
      ),
    );
  }
}