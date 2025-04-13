import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatGPTService {
  static const String apiKey =
      "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";
  static const String apiUrl = "https://api.openai.com/v1/chat/completions";

  Future<String> getChatResponse(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [
            {
              "role": "system",
              "content": "أنت مساعد ذكي جاهز للإجابة على الأسئلة."
            },
            {"role": "user", "content": userMessage},
          ],
          // Optional parameters for better control
          "temperature": 0.7, // Controls randomness (0.0-2.0)
          "max_tokens": 1000, // Limits response length
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data["choices"]?[0]?["message"]?["content"];
        return content ?? "لا يوجد رد متاح";
      } else {
        final errorData = jsonDecode(response.body);
        return "حدث خطأ ${response.statusCode}: ${errorData['error']['message'] ?? 'غير معروف'}";
      }
    } catch (e) {
      // More specific error handling
      if (e is http.ClientException) {
        return "فشل الاتصال بالخادم: تحقق من الإنترنت";
      }
      return "خطأ غير متوقع: $e";
    }
  }
}