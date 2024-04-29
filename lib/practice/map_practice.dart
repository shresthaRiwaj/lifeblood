// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   GoogleMapController mapController;
//   TextEditingController locationController = TextEditingController();
//   Set<Marker> _markers = {};

//   @override
//   void dispose() {
//     mapController.dispose();
//     locationController.dispose();
//     super.dispose();
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   Future<void> _searchAndShowHospitals(String location) async {
//     List<Location> locations = await locationFromAddress(location);
//     if (locations != null && locations.isNotEmpty) {
//       Location location = locations.first;
//       PlacesSearchResponse response = await GooglePlacesFlutter(
//         apiKey: "YOUR_API_KEY",
//         language: "en",
//       ).search.getNearbyPlaces(location.lat, location.lng, 5000, "hospital");

//       setState(() {
//         _markers.clear();
//         for (Place place in response.results) {
//           _markers.add(
//             Marker(
//               markerId: MarkerId(place.placeId),
//               position: LatLng(place.geometry.location.lat,
//                   place.geometry.location.lng),
//               infoWindow: InfoWindow(
//                 title: place.name,
//                 snippet: place.vicinity,
//               ),
//             ),
//           );
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: TypeAheadField(
//           textFieldConfiguration: TextFieldConfiguration(
//             controller: locationController,
//             decoration: InputDecoration(
//               hintText: 'Enter a location',
//               suffixIcon: IconButton(
//                 icon: Icon(Icons.search),
//                 onPressed: () {
//                   _searchAndShowHospitals(locationController.text);
//                 },
//               ),
//             ),
//           ),
//           suggestionsCallback: (pattern) async {
//             return await placemarkFromCoordinates(
//                 mapController.cameraPosition.target.latitude,
//                 mapController.cameraPosition.target.longitude);
//           },
//           itemBuilder: (context, suggestion) {
//             return ListTile(
//               title: Text(suggestion.name),
//             );
//           },
//           onSuggestionSelected: (suggestion) {
//             locationController.text = suggestion.name;
//           }, onSelected: (Placemark value) {  },
//         ),
//       ),
//       body: GoogleMap(
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: LatLng(0.0, 0.0), // initial position
//           zoom: 11.0, // initial zoom level
//         ),
//         markers: _markers,
//       ),
//     );
//   }
// }