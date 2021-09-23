import 'package:agrozon/Model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static void setUser(User user) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("userId", user.uid);
    preferences.setString("email", user.email ?? "");
    preferences.setString("name", user.displayName ?? "");
    preferences.setString("mobile", user.phoneNumber ?? "");
  }

  static Future<AppUser> getUser() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String uid = preferences.getString("userId");
    String name = preferences.getString("name");
    String email = preferences.getString("email");
    String mobile = preferences.getString("mobile");

    return AppUser(fullName: name, uid: uid, email: email, mobile: mobile);
  }

  static void logOut() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("userId", "");
    preferences.setString("email", "");
    preferences.setString("name", "");
    preferences.setString("mobile", "");
  }
}
