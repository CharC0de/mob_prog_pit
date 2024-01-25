import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({required this.location, super.key});
  final String location;
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  @override
  initState() {
    debugPrint(widget.location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Location'),
      ),
      body: Expanded(
        child: GoogleMap(
          onMapCreated: (controller) async {
            setState(() {
              mapController = controller;
            });
            await searchLocation();
          },
          markers: markers,
          initialCameraPosition: CameraPosition(
            target: LatLng(14.5995, 120.9842), // Manila coordinates
            zoom: 12.0,
          ),
        ),
      ),
    );
  }

  Future<void> searchLocation() async {
    String location = widget.location;
    List<Location> locations = await locationFromAddress(location);

    if (locations.isNotEmpty) {
      setState(() {
        markers.clear();
        markers.add(Marker(
          markerId: MarkerId('selected-location'),
          position: LatLng(locations[0].latitude, locations[0].longitude),
          infoWindow: InfoWindow(title: location),
        ));
      });

      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(locations[0].latitude, locations[0].longitude),
            zoom: 15.0,
          ),
        ),
      );
    } else {
      // Handle case where no location is found
      print('No location found for: $location');
    }
  }
}
