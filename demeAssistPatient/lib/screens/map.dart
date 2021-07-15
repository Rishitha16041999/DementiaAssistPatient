import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demeassist_patient/service/geolocatorService.dart';
import 'package:demeassist_patient/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:demeassist_patient/models/direction.dart';
import 'package:demeassist_patient/models/user.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder/geocoder.dart';

class Map extends StatefulWidget {
  final Position initialPosition;
  double homeLat, homeLng;
  Map({this.initialPosition, this.homeLat, this.homeLng});
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  final GeolocatorService geoService = GeolocatorService();
  Completer<GoogleMapController> _controller = Completer();

  BitmapDescriptor customIcon;

  String latitude;

  double homeLat, homeLng;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  LatLng source;
  @override
  void initState() {
    geoService.getCurrentLocation().listen((position) {
      centerScreen(position);
    });
    getDirection();
    print("home lat lng " + widget.homeLat.toString());
    super.initState();
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
          "MAPS",
          style: TextStyle(
            color: primaryViolet,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            letterSpacing: 2,
          ),
        ),
      ),
      body: StreamBuilder<Position>(
        stream: geoService.getCurrentLocation(),
        builder: (context, snapshot) {
          // if (!snapshot.hasData)
          //   return Center(
          //     child: SpinKitCubeGrid(
          //       color: primaryViolet,
          //     ),
          //   );
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.initialPosition.latitude,
                  widget.initialPosition.longitude),
              zoom: 18.0,
            ),
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await saveCurrentLocation(widget.initialPosition.latitude,
              widget.initialPosition.longitude);
        },
        child: Icon(Icons.location_pin),
        backgroundColor: primaryViolet,
        tooltip: "Set Current Location as Home",
      ),
    );
  }

  getDirection() async {
    await getPlaceDirection();
  }

  getPlaceDirection() async {
    var srcLatLng = LatLng(widget.homeLat, widget.homeLng);
    var destLatLng = LatLng(
        widget.initialPosition.latitude, widget.initialPosition.longitude);
    String directionURL =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${srcLatLng.latitude}, ${srcLatLng.longitude}&destination=${destLatLng.latitude}, ${destLatLng.longitude}&key=AIzaSyBEOELGvFI8GJoiLzj3d6sGX_KqY1cJk48";
    var response = await geoService.getRequest(directionURL);
    if (response == "failed") return null;
    DirectionModel directionModel = DirectionModel();
    directionModel.encodedPoints =
        response['routes'][0]['overview_polyline']['points'];
    directionModel.durationValue =
        response['routes'][0]['legs'][0]['duration']['value'];
    directionModel.distanceValue =
        response['routes'][0]['legs'][0]['distance']['value'];
    directionModel.distanceText =
        response['routes'][0]['legs'][0]['distance']['text'];
    directionModel.distanceText =
        response['routes'][0]['legs'][0]['duration']['text'];
    print(directionModel.encodedPoints);
  }

  Future<DirectionModel> getLocationDirection(
      LatLng source, LatLng dest) async {
    String directionURL =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${source.latitude}, ${source.longitude}&destination=${dest.latitude}, ${dest.longitude}&key=AIzaSyBEOELGvFI8GJoiLzj3d6sGX_KqY1cJk48";
    var response = await geoService.getRequest(directionURL);
    if (response == "failed") return null;
    DirectionModel directionModel = DirectionModel();
    directionModel.encodedPoints =
        response['routes'][0]['overview_polyline']['points'];
    directionModel.durationValue =
        response['routes'][0]['legs'][0]['duration']['value'];
    directionModel.distanceValue =
        response['routes'][0]['legs'][0]['distance']['value'];
    directionModel.distanceText =
        response['routes'][0]['legs'][0]['distance']['text'];
    directionModel.distanceText =
        response['routes'][0]['legs'][0]['duration']['text'];
    return directionModel;
  }

  _createMarker(double lat, double lng) {
    return <Marker>[
      Marker(
        markerId: MarkerId('patient'),
        position: LatLng(lat, lng),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "Patient Home"),
      ),
    ].toSet();
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: LatLng(widget.homeLat, widget.homeLng),
          icon: BitmapDescriptor.defaultMarker));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: LatLng(widget.initialPosition.latitude,
              widget.initialPosition.longitude),
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  setPolylines() async {
    PolylineResult result = await polylinePoints?.getRouteBetweenCoordinates(
        "AIzaSyBEOELGvFI8GJoiLzj3d6sGX_KqY1cJk48",
        PointLatLng(widget.homeLat, widget.homeLng),
        PointLatLng(
            widget.initialPosition.latitude, widget.initialPosition.longitude));
    print(result);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);
      _polylines.add(polyline);
    });
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
        .update({
          'home': {'lat': lat, 'lng': lng, 'address': extractedAddress}
        })
        .then((value) => print("Home location is updated"))
        .catchError((err) => print('Error ' + err));
  }

  Future<void> centerScreen(Position position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18.0,
        ),
      ),
    );
  }
}
