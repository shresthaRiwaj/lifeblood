import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class LocationSearch extends StatefulWidget {
  @override
  _LocationSearchState createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(27.700769, 85.300140), zoom: 14.4746);

  List<Marker> _markers = [];
  List<String> _searchedPlaces = []; // List to store searched places

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _markers.addAll(_getDefaultMarkers());
    super.initState();
  }

  List<Marker> _getDefaultMarkers() {
    return [
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(27.700769, 85.300140),
        infoWindow: InfoWindow(title: "My Position"),
      ),
      Marker(
        markerId: MarkerId('2'),
        position: LatLng(27.7025, 85.3414),
        infoWindow: InfoWindow(title: "Donation Center 1"),
      ),
      Marker(
        markerId: MarkerId('3'),
        position: LatLng(27.7050, 85.3450),
        infoWindow: InfoWindow(title: "Donation Center 2"),
      ),
    ];
  }

  Future<void> _searchLocation() async {
    String searchText = _searchController.text;
    List<geocoding.Location> locations =
        await geocoding.locationFromAddress(searchText);

    if (locations.isNotEmpty) {
      geocoding.Location location = locations.first;
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(location.latitude, location.longitude),
          14.0,
        ),
      );

      String locationName = await _getLocationName(location);

      // Store searched places in the list
      _searchedPlaces.add(locationName);

      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('searchedLocation'),
            position: LatLng(location.latitude, location.longitude),
            infoWindow: InfoWindow(title: locationName),
          ),
        );
      });
    }
  }

  Future<String> _getLocationName(geocoding.Location location) async {
    List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
        location.latitude ?? 0.0, location.longitude ?? 0.0);

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];

      // Concatenate address components for a more meaningful name
      String locationName = [
        placemark.name,
        placemark.locality,
        placemark.subLocality,
        placemark.administrativeArea,
        placemark.country,
      ].where((part) => part != null && part.isNotEmpty).join(', ');

      return locationName;
    }

    return "Location Name";
  }

  // Function to display information about the selected marker
  void _showMarkerInfo(MarkerId markerId) {
    Marker marker = _markers.firstWhere((marker) => marker.markerId == markerId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(marker.infoWindow.title ?? ""),
          content: Text("You can add more information here."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter location or center name',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _searchLocation,
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _kGooglePlex,
              mapType: MapType.normal,
              compassEnabled: true,
              myLocationEnabled: true,
              markers: Set<Marker>.of(_markers),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (LatLng position) {
                // Check if tapped position corresponds to any marker
                MarkerId? tappedMarkerId;
                for (Marker marker in _markers) {
                  final double distance = calculateDistance(
                    marker.position.latitude,
                    marker.position.longitude,
                    position.latitude,
                    position.longitude,
                  );
                  if (distance < 50.0) {
                    tappedMarkerId = marker.markerId;
                    break;
                  }
                }

                if (tappedMarkerId != null) {
                  // Display information about the tapped marker
                  _showMarkerInfo(tappedMarkerId);
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Display searched places in a dialog
              _showSearchedPlacesDialog();
            },
            child: Text('Searched Places'),
          ),
        ],
      ),
    );
  }

  // Function to show the searched places in a dialog
  void _showSearchedPlacesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Searched Places'),
          content: Column(
            children: _searchedPlaces
                .map((place) => ListTile(
                      title: Text(place),
                    ))
                .toList(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Function to calculate distance between two points
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Earth radius in kilometers
    final double dLat = radians(lat2 - lat1);
    final double dLon = radians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(radians(lat1)) * cos(radians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final double distance = R * c;
    return distance;
  }

  // Function to convert degrees to radians
  double radians(double degrees) {
    return degrees * (pi / 180.0);
  }
}
