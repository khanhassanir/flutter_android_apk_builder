import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqService {
  static const String baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  String? _apiKey;

  GroqService() {
    _apiKey = dotenv.env['GROQ_API_KEY'];
    if (_apiKey == null) {
      throw Exception('GROQ_API_KEY not found in .env file');
    }
  }

  Future<String> sendMessage(String userMessage, {List<Map<String, String>>? conversationHistory}) async {
    try {
      // Build messages array with conversation history
      final messages = <Map<String, String>>[];

      // Add system prompt to guide the AI
      messages.add({
        'role': 'system',
        'content': 'You are PhysioAI, a knowledgeable and empathetic physiotherapy assistant. '
            'Provide helpful, accurate advice about pain management, exercises, and recovery. '
            'Always encourage professional medical consultation when appropriate. '
            'Keep responses concise but informative. Be supportive and practical.'
      });

      // Add conversation history (last 10 messages for context)
      if (conversationHistory != null && conversationHistory.isNotEmpty) {
        final recentHistory = conversationHistory.length > 10
            ? conversationHistory.sublist(conversationHistory.length - 10)
            : conversationHistory;
        messages.addAll(recentHistory);
      }

      // Add current user message
      messages.add({'role': 'user', 'content': userMessage});

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.1-8b-instant',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 1024,
          'top_p': 1.0,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else if (response.statusCode == 429) {
        final headers = response.headers;
        final retryAfter = headers['retry-after'] ?? '1';
        throw Exception('Rate limit exceeded. Please wait $retryAfter seconds.');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('API Error: ${errorData['error']['message'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get response: $e');
    }
  }

  // Streaming version for real-time responses
  Stream<String> sendMessageStream(String userMessage, {List<Map<String, String>>? conversationHistory}) async* {
    try {
      final messages = <Map<String, String>>[];

      messages.add({
        'role': 'system',
        'content': 'You are PhysioAI, a knowledgeable and empathetic physiotherapy assistant.'
      });

      if (conversationHistory != null && conversationHistory.isNotEmpty) {
        final recentHistory = conversationHistory.length > 10
            ? conversationHistory.sublist(conversationHistory.length - 10)
            : conversationHistory;
        messages.addAll(recentHistory);
      }

      messages.add({'role': 'user', 'content': userMessage});

      final request = http.Request('POST', Uri.parse(baseUrl))
        ..headers['Authorization'] = 'Bearer $_apiKey'
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          'model': 'llama-3.1-8b-instant',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 1024,
          'stream': true,
        });

      final response = await request.send();

      await for (var chunk in response.stream.transform(utf8.decoder)) {
        final lines = chunk.split('\n');
        for (var line in lines) {
          if (line.startsWith('data: ')) {
            final data = line.substring(6);
            if (data == '[DONE]') break;

            try {
              final jsonData = jsonDecode(data);
              final content = jsonData['choices'][0]['delta']['content'];
              if (content != null) {
                yield content;
              }
            } catch (e) {
              // Skip invalid JSON chunks
            }
          }
        }
      }
    } catch (e) {
      yield 'Error: $e';
    }
  }
}