import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lifeblood/articles/article.dart';
import 'package:http/http.dart' as http;

class ShareNavbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Articles'),
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          Article article = articles[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(article.title),
              subtitle: FutureBuilder<String>(
                future: fetchArticleContent(article.url),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error loading article: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Text(
                      // Display the first few lines of the article content
                      snapshot.data!
                          .substring(0, 100), // Adjust the length as needed
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    );
                  } else {
                    return Text('No article content available');
                  }
                },
              ),
              onTap: () async {
                final uri = Uri.parse(article.url);
                if (await launchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  throw "Couldn't launch ${article.url}";
                }
              },
            ),
          );
        },
      ),
    );
  }

// Function to fetch the article content from the URL
  Future<String> fetchArticleContent(String url) async {
    try {
      // Make an HTTP GET request to the URL
      final response = await http.get(Uri.parse(url));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Return the response body, which contains the HTML content of the webpage
        return response.body;
      } else {
        // If the request was not successful, throw an error
        throw 'Failed to load article: ${response.statusCode}';
      }
    } catch (e) {
      // If an error occurs during the request, throw an error
      throw 'Failed to load article: $e';
    }
  }
}
