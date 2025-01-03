import 'package:flutter/material.dart';
import 'dart:convert';

class ResultPage extends StatelessWidget {
  final String result;

  const ResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? jsonData;
    try {
      jsonData = jsonDecode(result);
    } catch (e) {
      jsonData = null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: jsonData != null
            ? ListView.builder(
                itemCount: jsonData.length,
                itemBuilder: (context, index) {
                  final key = jsonData!.keys
                      .elementAt(index); // Original key
                  final formattedKey =
                      "${key[0].toUpperCase()}${key.substring(1)}"; // Capitalize first letter
                  final value = jsonData[key]; // Value remains unchanged

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "$formattedKey:",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            value?.toString() ?? '', // Value is displayed as it is
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Invalid JSON data.',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      result,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
