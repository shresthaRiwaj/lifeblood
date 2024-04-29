import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapHomeScreen extends StatefulWidget {
  const MapHomeScreen({super.key});

  @override
  State<MapHomeScreen> createState() => _MapHomeScreenState();
}

class _MapHomeScreenState extends State<MapHomeScreen> {
  // Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _controller;
  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(27.700769, 85.300140), zoom: 14.4746);

  final List<Marker> _marker = [];
  List<Marker> _list = const [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(27.700769, 85.300140),
      infoWindow: InfoWindow(title: "My Position"),
    ),
    Marker(
      markerId: MarkerId('2'),
      position: LatLng(27.7025, 85.3414),
      infoWindow: InfoWindow(title: "Old-Baneshwor"),
    ),
  ];

  void _addLocationMarker(
    double lat,
    double lng,
    String title,
  ) {
    setState(() {
      _marker.add(
        Marker(
          markerId: MarkerId('$lat$lng'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: title,
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // _marker.addAll(_list);
    _addLocationMarker(
      27.7025,
      85.3414,
      "Baneshwor",
    );
    _addLocationMarker(27.6959, 85.3534, "KMC");
    _addLocationMarker(27.7360, 85.3303, "Teaching Hospital");
    _addLocationMarker(27.75292, 85.32524, "Grande Hospital");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
          compassEnabled: true,
          myLocationEnabled: true,
          // markers: Set<Marker>.of(_marker),
          onMapCreated: (controller) {
            setState(() {
              _controller = controller;
            });
          },
          markers: Set.from(_marker),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.location_disabled_outlined),
      //   onPressed: () async {
      //     GoogleMapController controller = await _controller.future;
      //     controller.animateCamera(
      //       CameraUpdate.newCameraPosition(
      //           CameraPosition(target: LatLng(27.7025, 85.3414), zoom: 14)),
      //     );
      //     setState(() {});
      //   },
      // ),
    );
  }
}
