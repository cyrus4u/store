import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  static Future<List<String>> getImageUrls() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('imageUrls') ?? [];
  }

  static Future<List<String>> getTitles() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('productTitels') ?? [];
   
  }

  static Future<List<String>> getPrices() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('productPrice') ?? [];
  }

  static Future<void> addProduct({
    required String image,
    required String title,
    required String price,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final images = prefs.getStringList('imageUrls') ?? [];
    final titles = prefs.getStringList('productTitels') ?? [];
    final prices = prefs.getStringList('productPrice') ?? [];

    images.add(image);
    titles.add(title);
    prices.add(price);

    prefs.setStringList('imageUrls', images);
    prefs.setStringList('productTitels', titles);
    prefs.setStringList('productPrice', prices);
  }
}
