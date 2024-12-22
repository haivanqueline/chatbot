import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  late GenerativeModel _model;

  GeminiService() {
    final apiKey = dotenv.env['OPEN_API_KEY'] ?? '';
    _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  }

  Future<String> sendMessage(String message) async {
    try {
      final content = [Content.text(message)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Không có phản hồi từ chatbot.';
    } catch (e) {
      return 'Lỗi khi giao tiếp với chatbot: $e';
    }
  }
}
