import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demeassist_patient/models/user.dart';
import 'package:demeassist_patient/screens/home.dart';
import 'package:demeassist_patient/screens/splashScreen.dart';
import 'package:demeassist_patient/service/geolocatorService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:background_location/background_location.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final geoService = GeolocatorService();
  String latitude = "waiting...";
  String longitude = "waiting...";
  @override
  void initState() {
    super.initState();
    () async {
      await BackgroundLocation.setAndroidNotification(
        title: "DemeAssist Patient is running in background",
        message: "Location data is been collected for tracking purpose",
        icon: "@mipmap/app_icon",
      );
      // await BackgroundLocation.setAndroidConfiguration(1000);
      await BackgroundLocation.startLocationService();
      BackgroundLocation.getLocationUpdates((location) {
        setState(() {
          this.latitude = location.latitude.toString();
          this.longitude = location.longitude.toString();
        });
        String uid = FirebaseAuth.instance.currentUser.uid;
        FirebaseFirestore.instance
            .collection('LocationDetails')
            .doc(uid)
            .update({
              'latitude': double.parse(latitude),
              'longitude': double.parse(longitude),
              'email': FirebaseAuth.instance.currentUser.email,
            })
            .then((value) => print('Value is updated'))
            .catchError((err) => print(err));
        print("""\n
                        Latitude:  $latitude
                        Longitude: $longitude
                      """);
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    if (user == null)
      return SplashScreen();
    else
      return Stack(
        children: [
          StreamBuilder<Position>(
            stream: geoService.getCurrentLocation(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text("");
              print("Lan " + snapshot.data.latitude.toString());
              print("Lon " + snapshot.data.longitude.toString());
              print(snapshot.data);
              return Text("");
            },
          ),
          PatientHome(),
        ],
      );
  }
}
