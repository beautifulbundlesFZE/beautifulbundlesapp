import 'package:cirilla/service/constants/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistHelper {
  final SharedPreferences sharedPreferences;

  PersistHelper(this.sharedPreferences);

  /// Save setting dark mode
  Future<void> saveDarkMode(bool value) async {
    return await sharedPreferences.setBool(Preferences.darkMode, value);
  }

  /// Get setting dark mode
  Future<bool> getDarkMode() async {
    return sharedPreferences.getBool(Preferences.darkMode) ?? false;
  }

  /// Save user login token
  Future<void> saveToken(String value) async {
    return await sharedPreferences.setString(Preferences.authToken, value);
  }

  /// Get user login token
  String getToken() {
    return sharedPreferences.getString(Preferences.authToken);
  }

  /// Remove user login token
  Future<bool> removeToken() async {
    return sharedPreferences.remove(Preferences.authToken);
  }

  /// Get cart key
  String getCartKey() {
    return sharedPreferences.getString(Preferences.cartKey);
  }

  /// Save cart key
  Future<void> saveCartKey(String value) async {
    return await sharedPreferences.setString(Preferences.cartKey, value);
  }

  /// Save language
  Future<void> saveLanguage(String value) async {
    return await sharedPreferences.setString(Preferences.languageKey, value);
  }

  /// Get language
  Future<String> getLanguage() async {
    return sharedPreferences.getString(Preferences.languageKey);
  }

  /// Save currency
  Future<void> saveCurrency(String value) async {
    return await sharedPreferences.setString(Preferences.currencyKey, value);
  }

  /// Get currency
  Future<String> getCurrency() async {
    return sharedPreferences.getString(Preferences.currencyKey);
  }

  /// Save WishList
  Future<void> saveWishList(List<String> value) async {
    return await sharedPreferences.setStringList(Preferences.wishlistKey, value);
  }

  /// Get WishList
  Future<List<String>> getWishList() async {
    return sharedPreferences.getStringList(Preferences.wishlistKey);
  }

  /// Save post WishList
  Future<void> savePostWishList(List<String> value) async {
    return await sharedPreferences.setStringList(Preferences.postWishlistKey, value);
  }

  /// Get post WishList
  Future<List<String>> getPostWishList() async {
    return sharedPreferences.getStringList(Preferences.postWishlistKey);
  }

  /// Save enableGetStartKey
  Future<void> saveEnableGetStart(bool value) async {
    return await sharedPreferences.setBool(Preferences.enableGetStartKey, value);
  }

  /// Get enableGetStartKey
  Future<bool> getEnableGetStart() async {
    return sharedPreferences.getBool(Preferences.enableGetStartKey);
  }

  /// Save messages
  Future<void> saveMessages(List<String> value) async {
    return await sharedPreferences.setStringList(Preferences.messagesKey, value);
  }

  /// Get messages
  Future<List<String>> getMessages() async {
    return sharedPreferences.getStringList(Preferences.messagesKey);
  }

  /// Delete messages
  Future<bool> removeMessages() async {
    return sharedPreferences.remove(Preferences.messagesKey);
  }
}
