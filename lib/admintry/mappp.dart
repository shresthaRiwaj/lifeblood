import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationPageSearch extends StatefulWidget {
  @override
  _LocationPageSearchState createState() => _LocationPageSearchState();
}

class _LocationPageSearchState extends State<LocationPageSearch> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(27.700769, 85.300140), zoom: 14.4746);

  List<Marker> _markers = [];
  List<Polyline> _polylines = [];
  List<String> _searchedPlaces = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _addCustomMarkers();
    super.initState();
  }

  

  void _addCustomMarkers() {
    _addMarker(
        27.68997, 85.3192, "Norvic hospital", "https://norvichospital.com/");
    _addMarker(
        27.745997, 85.343833, "Gangalal Hospital", "https://www.sgnhc.org.np/");
    _addMarker(27.75292, 85.32524, "Grande Hospital",
        "https://www.grandehospital.com/");
    _addMarker(27.7360, 85.3303, "Teaching Hospital",
        "https://www.teachinghospital.org/");
    _addMarker(27.6863, 85.3388, "Civil Hospital", "https://csh.gov.np/en");
    _addMarker(27.66242, 85.3028, "Nepal MediCiti Hospital",
        "https://www.nepalmediciti.com");
    _addMarker(
        27.71023, 85.32821, "Himal Hospital", "https://himalhospital.com/");
    _addMarker(27.70264, 85.33847, "Frontline Hospital",
        "https://frontlinehospital.com.np/");
    _addMarker(27.66844, 85.32042, "Patan Hospital",
        "https://www.pahs.edu.np/pahs-community/hospital/");
    _addMarker(28.23647, 83.99636, "Manipal Hospital",
        "https://manipalpokhara.edu.np/hospital/");
    _addMarker(27.61673, 85.54783, "Dhulikhel Hospital",
        "https://dhulikhelhospital.org/");
    _addMarker(27.66487, 84.41659, "BP Koirala Memorial Cancer Hospital",
        "https://bpkmch.org.np/");
    _addMarker(26.81549, 85.95386, "Janaki Medical College Teaching Hospital,",
        "https://janakimedicalcollege.edu.np/");
    _addMarker(28.05957, 81.61725, "Nepalgunj Medical College", "");
    _addMarker(27.63298, 85.5277, "Scheer Memorial Hospital",
        "https://scheermemorial.org/");
    _addMarker(27.87184, 83.55747, "United Mission Hospital,",
        "https://www.tansenhospital.org.np/about/");
    _addMarker(28.53493, 81.12013, "Tikapur Hospital",
        "https://tikapurhospital.gov.np/?language=ne");
  }

  void _addMarker(
      double latitude, double longitude, String title, String websiteUrl) {
    _markers.add(
      Marker(
        markerId: MarkerId(title),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(
          title: title,
          snippet: "Tap for details",
        ),
        onTap: () {
          _showMarkerDetailsDialog(title, websiteUrl);
        },
      ),
    );
  }

  void _showMarkerDetailsDialog(String title, String websiteUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text('Do you want to visit the website?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _launchWebsite(websiteUrl);
                Navigator.of(context).pop();
              },
              child: Text('Visit Website'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _searchLocation() async {
    String searchText = _searchController.text;
    List<Location> locations = await locationFromAddress(searchText);

    if (locations.isNotEmpty) {
      Location location = locations.first;
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(location.latitude, location.longitude),
          14.0,
        ),
      );

      String locationName = await _getLocationName(location);

      _searchedPlaces.add(locationName);

      // Create a copy of existing markers (custom markers)
      List<Marker> existingMarkers = List.from(_markers);

      setState(() {
        _markers.clear();
        _markers.addAll(existingMarkers); // Add back the custom markers

        _markers.add(
          Marker(
            markerId: MarkerId('searchedLocation'),
            position: LatLng(location.latitude, location.longitude),
            infoWindow: InfoWindow(title: locationName),
          ),
        );

        // Add polyline from searched location to custom markers
        for (Marker customMarker in existingMarkers) {
          _polylines.add(
            Polyline(
              polylineId: PolylineId(
                  'searchedLocationPolyline-${customMarker.markerId.value}'),
              color: Colors.blue,
              width: 5,
              points: [
                LatLng(location.latitude, location.longitude),
                customMarker.position,
              ],
            ),
          );
        }
      });
    }
  }

  Future<String> _getLocationName(Location location) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude ?? 0.0, location.longitude ?? 0.0);

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
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

  void _launchWebsite(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  void _showAllCustomMarkers() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Donation Centers'),
          content: Container(
            width: double.maxFinite,
            height: 300, // Adjust the height as needed
            child: ListView.builder(
              itemCount: _markers.length,
              itemBuilder: (context, index) {
                final marker = _markers[index];
                return ListTile(
                  title: Text(marker.infoWindow.title ?? ""),
                  subtitle: Text(marker.position.toString()),
                );
              },
            ),
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
          ElevatedButton(
            onPressed: _showAllCustomMarkers,
            child: Text('Donation Centers'),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _kGooglePlex,
              mapType: MapType.normal,
              compassEnabled: true,
              myLocationEnabled: true,
              markers: Set<Marker>.of(_markers),
              polylines: Set<Polyline>.of(_polylines),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showSearchedPlacesDialog();
            },
            child: Text('Searched Places'),
          ),
        ],
      ),
    );
  }

  void _showSearchedPlacesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Searched Places'),
          content: Container(
            width: double.maxFinite,
            height: 300, // Adjust the height as needed
            child: ListView.builder(
              itemCount: _searchedPlaces.length,
              itemBuilder: (context, index) {
                final place = _searchedPlaces[index];
                return ListTile(
                  title: Text(place),
                );
              },
            ),
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
}
