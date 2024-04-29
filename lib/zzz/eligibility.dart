// import 'package:flutter/material.dart';

// class EligibilityCriteria extends StatefulWidget {
//   const EligibilityCriteria({super.key});

//   @override
//   State<EligibilityCriteria> createState() => _EligibilityCriteriaState();
// }

// class _EligibilityCriteriaState extends State<EligibilityCriteria> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 400,
//       margin: EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey), // Add border
//         color: Colors.grey[200], // Add background color
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: Offset(0, 3), // changes position of shadow
//           ),
//         ],
//       ),
//       padding: EdgeInsets.all(16), // Add padding
//       child: ListView(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Eligibility Criteria:',
//                 style: TextStyle(
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 10.0),
//               // Add eligibility criteria text widgets
//               Text(
//                 '1. Donor must be at least 18 years old to donate blood.',
//                 style: TextStyle(fontSize: 16.0),
//               ),
//               SizedBox(height: 10.0),
//               Text(
//                 '2. User must be in good health at the time of donation.',
//                 style: TextStyle(fontSize: 16.0),
//               ),
//               SizedBox(height: 10.0),
//               Text(
//                 '3. Certain medications may affect the eligibility to donate blood.' +
//                     'Please consult with the blood donation center if you are taking any medications.',
//                 style: TextStyle(fontSize: 16.0),
//               ),
//               SizedBox(height: 10.0),
//               Text(
//                 '4. Some health conditions may affect your eligibility to donate blood.' +
//                     'Please inform the blood donation center staff if you have any existing health conditions.',
//                 style: TextStyle(fontSize: 16.0),
//               ),
//               SizedBox(height: 10.0),
//               Text(
//                 '5. Pregnant women are usually deferred from donating blood.',
//                 style: TextStyle(fontSize: 16.0),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
