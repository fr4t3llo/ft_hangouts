import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ft_hangouts/pages/components/message.dart';
import 'dart:convert';

class MessageProvider with ChangeNotifier {
  // Map to store messages by contact ID
  Map<String, List<Message>> _messagesByContact = {};
  DateTime? _lastBackgroundTime;
  
  Map<String, List<Message>> get messagesByContact => _messagesByContact;
  DateTime? get lastBackgroundTime => _lastBackgroundTime;
  
  // Initialize provider and load messages from SharedPreferences
  Future<void> initialize() async {
    await _loadMessages();
    await _loadLastBackgroundTime();
  }
  
  // Get messages for a specific contact
  List<Message> getMessagesForContact(String contactId) {
    return _messagesByContact[contactId] ?? [];
  }
  
  // Add a new message
  Future<void> addMessage(Message message) async {
    if (!_messagesByContact.containsKey(message.contactId)) {
      _messagesByContact[message.contactId] = [];
    }
    
    _messagesByContact[message.contactId]!.add(message);
    await _saveMessages();
    notifyListeners();
  }
  
  // Record when app goes to background
  Future<void> recordBackgroundTime() async {
    _lastBackgroundTime = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_background_time', _lastBackgroundTime!.toIso8601String());
  }
  
  // Load last background time from SharedPreferences
  Future<void> _loadLastBackgroundTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeString = prefs.getString('last_background_time');
    if (timeString != null) {
      _lastBackgroundTime = DateTime.parse(timeString);
    }
  }
  
  // Save messages to SharedPreferences
  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Convert messages to JSON format
    final messagesJson = <String, List<Map<String, dynamic>>>{};
    
    _messagesByContact.forEach((contactId, messages) {
      messagesJson[contactId] = messages.map((message) => {
        'date': message.date.toIso8601String(),
        'text': message.text,
        'sentByMe': message.sentByMe,
        'contactId': message.contactId,
      }).toList();
    });
    
    await prefs.setString('messages', jsonEncode(messagesJson));
  }
  
  // Load messages from SharedPreferences
  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesString = prefs.getString('messages');
    
    if (messagesString != null) {
      final messagesJson = jsonDecode(messagesString) as Map<String, dynamic>;
      
      _messagesByContact = {};
      
      messagesJson.forEach((contactId, messagesData) {
        final List<Message> messages = (messagesData as List).map((messageData) {
          return Message(
            date: DateTime.parse(messageData['date']),
            text: messageData['text'],
            sentByMe: messageData['sentByMe'],
            contactId: messageData['contactId'],
          );
        }).toList();
        
        _messagesByContact[contactId] = messages;
      });
    }
  }
  
  // Clear all messages (for testing)
  Future<void> clearAllMessages() async {
    _messagesByContact = {};
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('messages');
    notifyListeners();
  }
}