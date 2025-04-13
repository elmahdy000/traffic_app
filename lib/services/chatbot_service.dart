import 'dart:convert';
import 'package:flutter/services.dart';

class ChatbotService {
  Map<String, String> _qaDatabase = {};

  Future<void> loadDatabase() async {
    String data = await rootBundle.loadString('assets/data.json');
    _qaDatabase = Map<String, String>.from(json.decode(data));
  }

  List<String> getQuestions() {
    return _qaDatabase.keys.toList();
  }

  String getResponse(String question) {
    return _qaDatabase[question] ?? "عذرًا، لا أملك إجابة لهذا السؤال.";
  }
}
