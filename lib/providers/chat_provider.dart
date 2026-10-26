import 'package:flutter/foundation.dart';
import 'package:physioai/service/groq_service.dart';

class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ChatProvider extends ChangeNotifier {
  final GroqService _groqService = GroqService();
  final List<Message> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> sendMessage(String userMessage) async {
    // Add user message
    _messages.add(Message(text: userMessage, isUser: true));
    notifyListeners();

    // Show typing indicator
    _isLoading = true;
    notifyListeners();

    try {
      // Get AI response
      final aiResponse = await _groqService.sendMessage(userMessage);

      // Add AI message
      _messages.add(Message(text: aiResponse, isUser: false));
      _error = null;
    } catch (e) {
      _error = e.toString();
      _messages.add(Message(
        text: 'Sorry, I encountered an error: $e',
        isUser: false,
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Alternative: Streaming version for real-time responses
  Future<void> sendMessageStreaming(String userMessage) async {
    // Add user message
    _messages.add(Message(text: userMessage, isUser: true));

    // Add placeholder for AI response
    final aiMessageIndex = _messages.length;
    _messages.add(Message(text: '', isUser: false));
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      String fullResponse = '';
      await for (String chunk in _groqService.sendMessageStream(userMessage)) {
        fullResponse += chunk;
        _messages[aiMessageIndex] = Message(text: fullResponse, isUser: false);
        notifyListeners();
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
      _messages[aiMessageIndex] = Message(
        text: 'Sorry, I encountered an error: $e',
        isUser: false,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    _error = null;
    notifyListeners();
  }
}