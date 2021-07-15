import 'dart:async';

import 'package:demeassist_patient/screens/home.dart';
import 'package:demeassist_patient/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VerifyPatient extends StatefulWidget {
  @override
  _VerifyPatientState createState() => _VerifyPatientState();
}

class _VerifyPatientState extends State<VerifyPatient> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      emailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> emailVerified() async {
    this.user = this.auth.currentUser;
    await this.user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PatientHome(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.50,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('images/verify.png')),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 30,
                    right: 1,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => PatientHome()),
                      ),
                      child: Container(
                        child: Icon(
                          Icons.arrow_right_rounded,
                          color: primaryViolet,
                          size: 60,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    // padding: const EdgeInsets.only(top: 50),
                    padding: EdgeInsets.all(50),
                    child: Text(
                      "An email has been\nsent.Please check \nthe inbox.",
                      style: TextStyle(
                          color: primaryViolet,
                          fontSize: 25,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SpinKitCubeGrid(
                    color: primaryViolet,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // IconButton(
                  //     icon: Icon(Icons.mail),
                  //     onPressed: () {
                  //       user.sendEmailVerification();
                  //     }),
                  // Container(
                  //   width: MediaQuery.of(context).size.width * .27,
                  //   child: Divider(
                  //     thickness: 2,
                  //     color: primaryViolet,
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
