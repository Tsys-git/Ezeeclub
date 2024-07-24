import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

// GeminiService to handle API requests
class GeminiService {
 
  GeminiService();

  Future<List<dynamic>> search(String query) async {
    try {
      final response = await http.get(
        Uri.parse('https://gemini.google.com/app?hl=en-IN&query=$query'),
        headers: {
          'Authorization': 'Bearer ',
        },
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        print(response.body);
        return json.decode(response.body)['results'];
      } else {
        throw Exception('Failed to load search results');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to load search results: $e');
    }
  }
}

// SearchScreen UI
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  final GeminiService geminiService = GeminiService();
  List<dynamic> _results = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _search(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final results = await geminiService.search(query);
      setState(() {
        _results = results;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gemini AI Search'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    final query = searchController.text;
                    if (query.isNotEmpty) {
                      _search(query);
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_errorMessage.isNotEmpty)
              Center(child: Text('Error: $_errorMessage'))
            else if (_results.isEmpty)
              Center(child: Text('No results found'))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final result = _results[index];
                    return ListTile(
                      title: Text(result['title']),
                      subtitle: Text(result['description']),
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





  