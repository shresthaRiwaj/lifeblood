import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GooglePlaceAutoCompleteTextField extends StatefulWidget {
  @override
  _GooglePlaceAutoCompleteTextFieldState createState() =>
      _GooglePlaceAutoCompleteTextFieldState();
}

class _GooglePlaceAutoCompleteTextFieldState
    extends State<GooglePlaceAutoCompleteTextField> {
  TextEditingController _controller = TextEditingController();
  List<String> _predictions = [];

  Future<void> _searchPlaces(String input) async {
    String apiKey = 'YOUR_API_KEY';
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String requestUrl = '$baseUrl?input=$input&types=geocode&key=$apiKey';

    final response = await http.get(Uri.parse(requestUrl));
    if (response.statusCode == 200) {
      final predictions = json.decode(response.body)['predictions'];
      setState(() {
        _predictions =
            predictions.map<String>((e) => e['description']).toList();
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search for a place...',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            _searchPlaces(value);
          },
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: _predictions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_predictions[index]),
                onTap: () {
                  // Handle selection
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
