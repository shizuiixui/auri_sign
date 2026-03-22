import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// The Data Model
class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'timestamp': timestamp.toIso8601String(),
    'isRead': isRead,
  };

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'],
        title: json['title'],
        message: json['message'],
        timestamp: DateTime.parse(json['timestamp']),
        isRead: json['isRead'],
      );
}

// ViewModel
class NotificationCenterViewModel extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationCenterViewModel() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('aurisign_inbox');

    if (savedData != null) {
      final List<dynamic> decoded = jsonDecode(savedData);
      _notifications = decoded
          .map((item) => AppNotification.fromJson(item))
          .toList();
      notifyListeners();
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      _notifications.map((n) => n.toJson()).toList(),
    );
    await prefs.setString('aurisign_inbox', encoded);
  }

  //  Inbox
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      _saveToStorage();
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    _saveToStorage();
    notifyListeners();
  }

  void addNotification(String title, String message, {DateTime? time}) {
    _notifications.insert(
      0,
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        message: message,
        timestamp: time ?? DateTime.now(),
      ),
    );
    _saveToStorage();
    notifyListeners();
  }

  Future<void> catchUp8AMNotification(bool isScheduleEnabled) async {
    if (!isScheduleEnabled) return;

    final now = DateTime.now();
    final today8AM = DateTime(now.year, now.month, now.day, 8, 0);

    if (now.isAfter(today8AM)) {
      final alreadyAddedToday = _notifications.any(
        (n) =>
            n.title == "Time to Practice AuriSign!" &&
            n.timestamp.year == today8AM.year &&
            n.timestamp.month == today8AM.month &&
            n.timestamp.day == today8AM.day,
      );

      if (!alreadyAddedToday) {
        _notifications.insert(
          0,
          AppNotification(
            id: 'daily_${today8AM.millisecondsSinceEpoch}',
            title: "Time to Practice AuriSign!",
            message:
                "Keep your streak alive. Jump in for a quick sign language lesson.",
            timestamp: today8AM,
          ),
        );
        await _saveToStorage();
        notifyListeners();
      }
    }
  }
}
