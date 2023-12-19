import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/app_button.dart';
import 'package:flutter_application_1/components/app_text_field.dart';
import 'package:flutter_application_1/home.dart';
import 'package:get_storage/get_storage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() {
    final box = GetStorage();
    String? username = box.read('username');
    if (username != null) {
      print("LOGIN USER ${username}");

      Future.delayed(Duration(milliseconds: 100), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => HomePage()));
      });
    }
  }

  void login() {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username != 'admin' || password != 'admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Username atau Password Salah"),
        ),
      );
      return;
    }
    final box = GetStorage();
    box.write('username', username);
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Login",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            AppTextField(label: "Username", controller: usernameController),
            SizedBox(height: 20),
            AppTextField(label: "Password", controller: passwordController),
            SizedBox(height: 20),
            AppButton(
              text: "Login",
              color: Colors.black,
              onPressed: (() {
                login();
              }),
            )
          ],
        ),
      ),
    );
  }
}
