import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class DailyQuotes extends StatefulWidget {
  const DailyQuotes({super.key});

  @override
  _DailyQuotesState createState() => _DailyQuotesState();
}

class _DailyQuotesState extends State<DailyQuotes> {
  var apiKey = "AIzaSyCJAX0v1KtTu963AME6LK3c5CG8RCNgZYs";

  late GenerativeModel _model;
  List<String> _quotes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );
    fetchQuotes();
  }

  Future<void> fetchQuotes() async {
    const prompt =
        'Tips about how to make your workouts effective. add # to the number.';
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);

    print(response);
    setState(() {
      _quotes = response.text!.split('#').map((quote) {
        // Remove asterisks and trim whitespace
        String trimmedQuote = quote.replaceAll('*', '').trim();

        // Check and remove trailing period
        if (trimmedQuote.endsWith('.')) {
          trimmedQuote = trimmedQuote.substring(0, trimmedQuote.length - 1);
        }

        return trimmedQuote;
      }).toList();

      _isLoading = false;
    });
    print(_quotes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Quotes'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _quotes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(child: QuoteCard(quote: _quotes[index])),
                );
              },
            ),
    );
  }
}

class QuoteCard extends StatelessWidget {
  final String quote;

  const QuoteCard({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quote,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
