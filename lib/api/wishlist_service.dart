import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WishListService {
  static const String _wishListKey = 'wishlist_movies';

  static Future<List<Map<String, dynamic>>> getWishList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? wishListJson = prefs.getString(_wishListKey);
      
      if (wishListJson == null || wishListJson.isEmpty) {
        return [];
      }
      
      final List<dynamic> decoded = json.decode(wishListJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addToWishList({
    required int movieId,
    required String title,
    String? imageUrl,
    int? year,
    double? rating,
  }) async {
    try {
      final wishList = await getWishList();
      
      if (wishList.any((movie) => movie['id'] == movieId)) {
        return false;
      }
      
      wishList.add({
        'id': movieId,
        'title': title,
        'imageUrl': imageUrl ?? '',
        'year': year ?? 0,
        'rating': rating ?? 0.0,
      });
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_wishListKey, json.encode(wishList));
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeFromWishList(int movieId) async {
    try {
      final wishList = await getWishList();
      wishList.removeWhere((movie) => movie['id'] == movieId);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_wishListKey, json.encode(wishList));
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isInWishList(int movieId) async {
    try {
      final wishList = await getWishList();
      return wishList.any((movie) => movie['id'] == movieId);
    } catch (e) {
      return false;
    }
  }

  static Future<int> getWishListCount() async {
    try {
      final wishList = await getWishList();
      return wishList.length;
    } catch (e) {
      return 0;
    }
  }

  static Future<bool> clearWishList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_wishListKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}

