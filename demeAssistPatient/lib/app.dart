import 'package:demeassist_patient/screens/home.dart';
import 'package:demeassist_patient/screens/login.dart';
import 'package:demeassist_patient/screens/register.dart';
import 'package:demeassist_patient/screens/wrapper.dart';
import 'package:demeassist_patient/service/authService.dart';
import 'package:demeassist_patient/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demeassist_patient/models/user.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primaryViolet,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: Wrapper(),
        routes: {
          '/login': (context) => LoginPatient(),
          '/register': (context) => RegisterPatient(),
          '/patientHome': (context) => PatientHome()
        },
      ),
    );
  }
}
