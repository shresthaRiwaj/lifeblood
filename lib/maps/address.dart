// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_geocoder/geocoder.dart';
// // import 'package:geocoder_plus/geocoder_plus.dart';
// // import 'package:flutter_geocoder/geocoder.dart';

// class ConvertLatLngToAddress extends StatefulWidget {
//   const ConvertLatLngToAddress({super.key});

//   @override
//   State<ConvertLatLngToAddress> createState() => _ConvertLatLngToAddressState();
// }

// class _ConvertLatLngToAddressState extends State<ConvertLatLngToAddress> {
//   String stAddress = '';

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Google Map"),
//           centerTitle: true,
//         ),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(stAddress),
//             GestureDetector(
//               onTap: () async {
//                 final query = "1600 Amphiteatre Parkway, Mountain View";
//                 var addresses =
//                     await Geocoder.local.findAddressesFromQuery(query);
//                 var second = addresses.first;
//                 print("${second.featureName} : ${second.coordinates}");
//                 final coordinates = new Coordinates(27.700769, 85.300140);
//                 var address = await Geocoder.local
//                     .findAddressesFromCoordinates(coordinates);
//                 var first = address.first;

//                 print("Address: " +
//                     first.featureName.toString() +
//                     first.addressLine.toString());

//                 setState(() {
//                   stAddress = " " + first.countryCode.toString();
//                 });
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   height: 50,
//                   decoration: BoxDecoration(color: Colors.green),
//                   child: Center(
//                     child: Text('Convert'),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
