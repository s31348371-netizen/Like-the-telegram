import 'package:flutter/material.dart';
class LoginPage extends StatefulWidget {
  final List<Map<String, String>> users;

  const LoginPage({super.key, required this.users});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String result = '';
  void login() {
    bool found = false;

    for (var user in widget.users) {
      if (user['email'] == emailController.text && user['password'] == passwordController.text) {
        found = true;
        break;
      }
    }

    setState(() {
      result = found ? ' تسجيل دخول ناجح' : ' بيانات غير صحيحة';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول',style: TextStyle(color:Colors.white)),
        backgroundColor:Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'البريد الإلكتروني',
                border: OutlineInputBorder(),
              ),
            ),


            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور',
                border: OutlineInputBorder(),
              ),
            ),


            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: login,
              child: const Text('تسجيل الدخول'),
            ),


            const SizedBox(height: 20),
            Text(
              result,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}


