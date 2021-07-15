import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demeassist_patient/models/user.dart';
import 'package:demeassist_patient/screens/imageScection.dart';
import 'package:demeassist_patient/screens/info.dart';
import 'package:demeassist_patient/screens/mapWrapper.dart';
import 'package:demeassist_patient/screens/medicineRemainder.dart';
import 'package:demeassist_patient/screens/videoSection.dart';
import 'package:demeassist_patient/screens/wrapper.dart';
import 'package:demeassist_patient/service/authService.dart';
import 'package:demeassist_patient/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:timezone/data/latest.dart' as tz;

class PatientHome extends StatefulWidget {
  @override
  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  final AuthService authService = AuthService();
  String email = FirebaseAuth.instance.currentUser.email;
  String uid = FirebaseAuth.instance.currentUser.uid;

  int hr, mins;
  String name, dosage, type, takeMedicine;
  FlutterLocalNotificationsPlugin fltrNotification;

  String userID;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();

    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings = new InitializationSettings(
        android: androidInitilize, iOS: iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
    FirebaseFirestore.instance
        .collection('PatientDetails')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) => {
              FirebaseFirestore.instance
                  .collection('MedicineRemainder')
                  .doc(value.docs[0]['uid'])
                  .collection('Medicines')
                  .where('email',
                      isEqualTo: FirebaseAuth.instance.currentUser.email)
                  .get()
                  .then((value) => {
                        setState(() {
                          hr = value.docs[0]['time']['hr'];
                          mins = value.docs[0]['time']['min'];
                          name = value.docs[0]['name'];
                          dosage = value.docs[0]['dosage'];
                          takeMedicine = value.docs[0]['takeMedicine'];
                          type = value.docs[0]['type'];
                        })
                      })
                  .then((value) => alarmNotification(
                      hr, mins, name, dosage, takeMedicine, type)),
            });

    // .then((value) => print(hr.toString() + ":" + mins.toString()));
  }

  alarmNotification(int hr, int min, String name, dosage, takeMedicine, type) {
    _showNotification(hr, min, name, dosage, takeMedicine, type);
  }

  Future _showNotification(
      int hr, int min, String name, dosage, takeMedicine, type) async {
    var time = Time(hr, min - 1, 0);
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 4',
      'CHANNEL_NAME 4',
      "CHANNEL_DESCRIPTION 4",
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await fltrNotification.showDailyAtTime(
      0,
      'Time to take the medicine $name. Medicine type $type. Dosgae $dosage',
      '$takeMedicine', //null
      time,
      platformChannelSpecifics,
      payload: name,
    );
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
          "HOME",
          style: TextStyle(
            color: primaryViolet,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageSection(),
                ),
              );
            },
            tooltip: "View images",
            icon: FaIcon(
              FontAwesomeIcons.image,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoSection(),
                ),
              );
            },
            tooltip: "Logout",
            icon: FaIcon(
              FontAwesomeIcons.playCircle,
            ),
          ),
          IconButton(
            onPressed: () async {
              await authService.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Wrapper(),
                ),
              );
            },
            tooltip: "Logout",
            icon: FaIcon(FontAwesomeIcons.signOutAlt),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('PatientDetails')
            .where('email', isEqualTo: email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: SpinKitCubeGrid(
                color: primaryViolet,
              ),
            );
          else
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot patientDetails =
                    snapshot.data.documents[index];
                return Container(
                  child: patientDetails.exists
                      ? Container(
                          child: Column(
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                    ),
                                    CircleAvatar(
                                      radius: 100,
                                      backgroundImage: NetworkImage(
                                          patientDetails['imageURL']),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                    ),
                                    Text(
                                      patientDetails['patientName'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 50),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                    Text(
                                      patientDetails['age'].toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                    Text(
                                      patientDetails['gender'].toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                    Text(
                                      patientDetails['mobile'].toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                    FirebaseAuth
                                            .instance.currentUser.emailVerified
                                        ? Container(
                                            child: Text(
                                              'Email Verified',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.green),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: ButtonTheme(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              child: RaisedButton.icon(
                                                icon: FaIcon(
                                                  FontAwesomeIcons.telegram,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      context, '/resendMail');
                                                },
                                                label: Text(
                                                  "Send another email",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 19,
                                                  ),
                                                ),
                                                color: primaryViolet,
                                              ),
                                            ),
                                          ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.10,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                );
              },
            );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Info(),
                ),
              );
            },
            child: FaIcon(
              FontAwesomeIcons.infoCircle,
            ),
            backgroundColor: primaryViolet,
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RemainderResult(),
                ),
              );
            },
            child: FaIcon(
              FontAwesomeIcons.clock,
            ),
            backgroundColor: primaryViolet,
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            onPressed: () async {
              await saveCurrentLocation(11.0575449, 77.0624376);
            },
            backgroundColor: primaryViolet,
            child: FaIcon(FontAwesomeIcons.heart),
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapWrapper(),
                ),
              );
            },
            backgroundColor: primaryViolet,
            child: FaIcon(FontAwesomeIcons.map),
          ),
        ],
      ),
    );
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Time to take medicine $payload"),
      ),
    );
  }

  saveCurrentLocation(double lat, double lng) async {
    final coordinates = Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    var first = addresses.first;
    String extractedAddress = '${first.addressLine} ';
    UserModel user = UserModel();
    user.address = extractedAddress;
    await FirebaseFirestore.instance
        .collection('LocationDetails')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({
          'home': {'lat': lat, 'lng': lng, 'address': extractedAddress}
        })
        .then((value) => print("Home location is updated"))
        .catchError((err) => print('Error ' + err));
  }
}
