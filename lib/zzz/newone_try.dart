// void deleteDonor(String id) async {
//     await FirebaseFirestore.instance.collection("donors").doc(id).delete();
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Donor removed"),
//         ),
//       );
//     }
//   }