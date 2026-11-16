import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrenceHelper {
  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMIALKEY";
  static String userProfileKey = "USERPROFILEKEY";
  static String userDisplayNameKey="USERDISPLAYKEY";

  Future<bool> saveUserId(String getUserId) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserProfile(String getUserProfile) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(userProfileKey, getUserProfile);
  }
   Future<bool> saveUserDisplayName(String getUserDisplayName) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(userDisplayNameKey, getUserDisplayName);
  }

  Future<String?> getUserId() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(userIdKey);
  }

  Future<String?> getUserName() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(userEmailKey);
  }

  Future<String?> getUserProfile() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(userProfileKey);
  }
  Future<String?> getUserDisplayName() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(userDisplayNameKey);
  }
}
