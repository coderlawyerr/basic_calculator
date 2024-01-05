import 'package:basic_calculator/screen/shared.dart';
import 'package:basic_calculator/screen/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

void main() async {
  // // Uygulamanın Flutter ile ilgili kısımlarını başlatır
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferencesHelper sınıfından bir örnek oluşturulur ve başlatılır
  SharedPreferencesHelper preferences = SharedPreferencesHelper();
  // SharedPreferencesHelper'ın başlatılması beklenir
  await preferences.initialize();

  // Uygulama çalıştırılır
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Splash(),
    );
  }
}
