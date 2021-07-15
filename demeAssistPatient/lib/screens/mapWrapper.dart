import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demeassist_patient/service/geolocatorService.dart';
import 'package:demeassist_patient/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:demeassist_patient/screens/patientMap.dart';

class MapWrapper extends StatefulWidget {
  @override
  _MapWrapperState createState() => _MapWrapperState();
}

class _MapWrapperState extends State<MapWrapper> {
  final geoService = GeolocatorService();
  double homeLat, homeLng;

  @override
  Widget build(BuildContext context) {
    return FutureProvider(
      create: (context) => geoService.getInitialLocation(),
      child: Scaffold(
        body: Consumer<Position>(
          builder: (context, position, widget) {
            FirebaseFirestore.instance
                .collection('LocationDetails')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .get()
                .then((value) {
              setState(() {
                this.homeLat = value.data()['home']['lat'];
                this.homeLng = value.data()['home']['lng'];
              });
            });
            return (position != null)
                ? PatientMap(
                    initialPosition: position,
                    homeLat: this.homeLat,
                    homeLng: this.homeLng,
                  )
                : Center(
                    child: SpinKitCubeGrid(
                      color: primaryViolet,
                    ),
                  );
          },
        ),
      ),
    );
  }
}
