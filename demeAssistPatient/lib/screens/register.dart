import 'package:demeassist_patient/service/authService.dart';
import 'package:demeassist_patient/utils/colors.dart';
import 'package:demeassist_patient/screens/verify.dart';
import 'package:flutter/material.dart';

class RegisterPatient extends StatefulWidget {
  @override
  _RegisterPatientState createState() => _RegisterPatientState();
}

class _RegisterPatientState extends State<RegisterPatient> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String email = "";
  String error = "";
  bool loading = false;
  List errors;

  final AuthService authService = AuthService();

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
          "REGISTER",
          style: TextStyle(
              color: primaryViolet,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              letterSpacing: 2),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            tooltip: "Login",
            icon: Icon(Icons.login),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'images/hands.png',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
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
                      height: 10,
                    ),
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.80,
                          child: TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter the password.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: "Password",
                                icon: Icon(Icons.vpn_key_outlined)),
                            obscureText: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            dynamic result = await authService.register(
                                _emailController.text,
                                _passwordController.text);
                            setState(() {
                              this.error = result;
                              this.loading = true;
                            });
                            if (this.error == "")
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => VerifyPatient(),
                                ),
                              );
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
                              "REGISTER",
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
                    ]),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                error,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
