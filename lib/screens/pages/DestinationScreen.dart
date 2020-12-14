import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/GmapLocations.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';

class DestinationScreen extends StatefulWidget {
  final String location;
  DestinationScreen({Key key, this.location}) : super(key: key);
  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Widget progressIndicator = CircularProgressIndicator();
  final Set<Marker> _markers = {};
  List<Position> _positions;
  Position current;
  Placemark destination;
  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  var SecretAPI = "AIzaSyBnbQl-ZV1hepUMo1R_aDZN_cKI0lZ_3uk";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: MyAppBar2(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _futureBuilder(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _goToTheDest();
        },
        label: Text(getTranslated(context, 'to_dest')),
        icon: Icon(Icons.map),
      ),
    );
  }

  Widget _futureBuilder() => FutureBuilder(
        future: Future.wait([GmapLocations.currentPosition(), GmapLocations.currentPositionFromString(widget.location)]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) return Center(child: progressIndicator);
          current = snapshot.data[0];
          destination = snapshot.data[1];
          _markersAdd();
          return GoogleMap(
            polylines: Set<Polyline>.of(polylines.values),
            mapToolbarEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            markers: _markers,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(current.latitude, current.longitude),
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationButtonEnabled: false,
          );
        },
      );

  Future<void> _goToTheDest() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(bearing: 192.8334901395799, target: LatLng(destination.position.latitude, destination.position.longitude), tilt: 59.440717697143555, zoom: 19.151926040649414)));
  }

  _markersAdd() async {
    _markers.add(Marker(markerId: MarkerId(current.toString()), position: LatLng(current.latitude, current.longitude), infoWindow: InfoWindow(title: " ${current.toString()}", snippet: "", onTap: () {}), onTap: () {}, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan)));
    _markers.add(Marker(markerId: MarkerId(destination.toString()), position: LatLng(destination.position.latitude, destination.position.longitude), infoWindow: InfoWindow(title: "${destination.name} ${destination.subLocality}", snippet: "${destination.administrativeArea}", onTap: () {}), onTap: () {}, icon: BitmapDescriptor.defaultMarker));
  }

  _createPolylines(Position start, Position destination) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      SecretAPI, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
  }
}
