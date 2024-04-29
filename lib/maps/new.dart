import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  List<Marker> _markers = [];

  // Method to add a marker for a hospital
  void _addHospitalMarker(double lat, double lng) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('$lat$lng'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: 'Hospital',
            snippet: 'This is a hospital',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hospital Map')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
              37.7749, -122.4194), // Initial location (e.g., San Francisco)
          zoom: 12,
        ),
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });

          // Example: Adding hospital markers for San Francisco
          _addHospitalMarker(37.7749, -122.4194); // Example hospital
          // You can call a method to search for hospitals and add markers here
        },
        markers: Set.from(_markers),
      ),
    );
  }
}
