import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferencesHelper? _instance;
  late SharedPreferences _pref;

  SharedPreferencesHelper._();

  factory SharedPreferencesHelper() => _instance ??= SharedPreferencesHelper();

  Future<void> initialize() async {
    if (_pref == null) {
      _pref = await SharedPreferences.getInstance();
    }
  }

  bool isAdmin(String adminUserName, String adminPassword) {
    String? savedUserName = _pref.getString('username');
    String? savedPassword = _pref.getString('password');
    if (savedUserName == adminUserName && savedPassword == adminPassword) {
      print(savedUserName);
      return true;
    } else {
      return false;
    }
  }

  void savelogin(String adminUserName, String adminPassword) async {
    await initialize(); // Başlatma işlemini burada çağırın
    await _pref.setString('username', adminUserName);
    await _pref.setString('password', adminPassword);
  }

  void deletelogin() async {
    await initialize();
    await _pref.remove('username');
    await _pref.remove('password');
  }

  // Future<void> initialize() async {
  //   if (_pref == null) {
  //     // Null kontrolü düzeltildi
  //     _pref = await SharedPreferences.getInstance();
  //   }
  // }
}
