import 'package:basic_calculator/screen/my_calculator.dart';
import 'package:basic_calculator/screen/shared.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String adminUserName = "";
  String adminPassword = "";
  Login({Key? key});

  void showDialogFunction(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext) => AlertDialog(
        title: Text("Şifreniz yanış oldu tekrar deneyin:)"),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {},
            child: Text("Tamam"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[600],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/calculator.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Dikey eksende ortalamak için
            children: <Widget>[
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BasicCalculator()),
                  );
                },
                child: Text(
                  'Giriş Yap',
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginPush(BuildContext context) async {
    String adminUserName = usernameController.text;
    String adminPassword = passwordController.text;

    if (adminPassword == '1907' && adminUserName == "betul") {
      SharedPreferencesHelper().savelogin(adminUserName, adminPassword);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BasicCalculator()));
    } else {
      showDialogFunction(context);
    }
  }
}
