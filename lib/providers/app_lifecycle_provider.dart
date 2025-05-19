import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppLifecycleProvider with ChangeNotifier {
  DateTime? _backgroundTime;
  int _currentContactId = -1;
  final Map<int, int> _contactBackgroundTimes = {};

  void setCurrentContact(int contactId) {
    _currentContactId = contactId;
    notifyListeners();
  }

  void onAppBackground() {
    _backgroundTime = DateTime.now();
  }

  void onAppForeground() {
    if (_backgroundTime != null && _currentContactId != -1) {
      final now = DateTime.now();
      final backgroundDuration = now.difference(_backgroundTime!).inSeconds;
      
      // Update the background time for the current contact
      _contactBackgroundTimes[_currentContactId] = 
          (_contactBackgroundTimes[_currentContactId] ?? 0) + backgroundDuration;
      
      _backgroundTime = null;
      notifyListeners();
    }
  }

  int getBackgroundTimeForContact(int contactId) {
    return _contactBackgroundTimes[contactId] ?? 0;
  }

  void resetBackgroundTime(int contactId) {
    _contactBackgroundTimes.remove(contactId);
    notifyListeners();
  }
} 