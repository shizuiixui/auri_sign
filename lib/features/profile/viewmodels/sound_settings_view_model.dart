import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundSettingsViewModel extends ChangeNotifier {
  static const String _keySoundEffectsEnabled = 'sound_effects_enabled';

  bool _isSoundEffectsEnabled = true;

  bool get isSoundEffectsEnabled => _isSoundEffectsEnabled;

  SoundSettingsViewModel() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isSoundEffectsEnabled = prefs.getBool(_keySoundEffectsEnabled) ?? true;
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading sound settings: $e");
    }
  }

  Future<void> setSoundEffectsEnabled(bool enabled) async {
    if (_isSoundEffectsEnabled == enabled) return;
    _isSoundEffectsEnabled = enabled;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keySoundEffectsEnabled, enabled);
    } catch (e) {
      debugPrint("Error saving sound settings: $e");
    }
  }
}
