import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/GmapLocations.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

class MapScreen extends StatefulWidget {
  final String location;
  MapScreen({Key key, this.location}) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Widget progressIndicator = CircularProgressIndicator();
  Placemark placemark;
  Position _position;
  final Set<Marker> _markers = {};


  CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: MyAppBar2(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:() {
                Navigator.of(context).pop();
              },
        label: Text(getTranslated(context, 'retour')),
        icon: Icon(Icons.arrow_back),
        backgroundColor: LightColor.blueLinkedin,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _futureBuilder(),
    );
  }
 
  Widget _futureBuilder() => FutureBuilder(
        future: GmapLocations.currentPositionFromString(this.widget.location),
        builder: (context, AsyncSnapshot<Placemark> snapshot) {
          if (!snapshot.hasData) return Center(child: progressIndicator);
          placemark = snapshot.data;
          _position = placemark.position;
          _markers.add(Marker(
              markerId: MarkerId(_position.toString()),
              position: LatLng(_position.latitude, _position.longitude),
              infoWindow: InfoWindow(
                  title: "${placemark.name}",
                  snippet: "${placemark.administrativeArea}",
                  onTap: () {}),
              onTap: () {},
              icon: BitmapDescriptor.defaultMarker));
          return GoogleMap(
            markers: _markers,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(_position.latitude, _position.longitude),
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationButtonEnabled: false,
          );
        },
      );
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
