import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const String _historyKey = 'history_movies';

  static Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? historyJson = prefs.getString(_historyKey);
      
      if (historyJson == null || historyJson.isEmpty) {
        return [];
      }
      
      final List<dynamic> decoded = json.decode(historyJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addToHistory({
    required int movieId,
    required String title,
    String? imageUrl,
    int? year,
    double? rating,
  }) async {
    try {
      final history = await getHistory();
      
      history.removeWhere((movie) => movie['id'] == movieId);
      
      history.insert(0, {
        'id': movieId,
        'title': title,
        'imageUrl': imageUrl ?? '',
        'year': year ?? 0,
        'rating': rating ?? 0.0,
        'viewedAt': DateTime.now().toIso8601String(),
      });
      
      if (history.length > 100) {
        history.removeRange(100, history.length);
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_historyKey, json.encode(history));
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeFromHistory(int movieId) async {
    try {
      final history = await getHistory();
      history.removeWhere((movie) => movie['id'] == movieId);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_historyKey, json.encode(history));
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<int> getHistoryCount() async {
    try {
      final history = await getHistory();
      return history.length;
    } catch (e) {
      return 0;
    }
  }
}

