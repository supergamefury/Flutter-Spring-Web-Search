import 'package:flutter/material.dart';
import 'search_service.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search App',
      theme: ThemeData(
          appBarTheme:
              const AppBarTheme(color: Color.fromARGB(255, 15, 72, 218)),
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255)),
      home: const SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final SearchService _searchService = SearchService();
  List<String> links = [];
  bool isLoading = false;

  void fetchLinks(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      List<String> fetchedLinks = await _searchService.search(query);
      setState(() {
        links = fetchedLinks;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching links: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String getDisplayText(String url) {
    Uri uri = Uri.parse(url);
    String host = uri.host;
    return host.startsWith('www.') ? host.substring(4) : host;
  }

  void openLinkInNewTab(String url) {
    html.window.open(url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true, title: const Text('Search App'), elevation: 100),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              textAlign: TextAlign.center,
              controller: _controller,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 5.0),
                ),
                hintText: 'Enter the Seach query',
              ),
              onSubmitted: (value) {
                fetchLinks(value);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 40, 72, 202),
                  foregroundColor: Colors.black),
              onPressed: () {
                fetchLinks(_controller.text);
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (links.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: links.length,
                  itemBuilder: (context, index) {
                    String link = links[index];
                    return ListTile(
                      title: Text(
                        getDisplayText(link),
                        style: const TextStyle(color: Colors.black),
                      ),
                      onTap: () => openLinkInNewTab(links[index]),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
