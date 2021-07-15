import 'package:demeassist_patient/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswprd extends StatefulWidget {
  @override
  _ForgotPasswprdState createState() => _ForgotPasswprdState();
}

class _ForgotPasswprdState extends State<ForgotPasswprd> {
  TextEditingController _emailController = TextEditingController();
  String email = "";
  bool clicked = false;
  final _formKey = GlobalKey<FormState>();
  bool isValidEmail(String email) {
    bool validEmailId = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return validEmailId == false ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: primaryViolet,
        ),
        backgroundColor: Colors.white10,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Forgot password".toUpperCase(),
          style: TextStyle(
              color: primaryViolet,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              letterSpacing: 2),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'images/forgotPassword.png',
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty || isValidEmail(email)) {
                              return 'Not a valid email.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            icon: Icon(
                              Icons.email_outlined,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              clicked = true;
                            });
                            FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email);
                          }
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.75,
                          decoration: BoxDecoration(
                            color: primaryViolet,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Change Password".toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                clicked
                    ? Text(
                        "Reset password has been sent to the email!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text("")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
