import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UserController.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // تسجيل الدخول
  Future<void> signIn() async {
    try {
      UserCredential userCred =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      UserController userController = Get.find();
      userController.setUser(userCred.user);

      emailController.clear();
      passwordController.clear();

      Get.snackbar(
        "نجاح",
        "تم تسجيل الدخول بنجاح",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );

      Future.delayed(Duration(seconds: 2), () {
        Get.offNamed('/home');
      });
    } catch (e) {
      Get.snackbar("خطأ", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  // إنشاء حساب جديد
  Future<void> signUp() async {
    try {
      UserCredential userCred =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User user = userCred.user!;

      // حفظ في GetX فقط
      UserController userController = Get.find();
      userController.setUser(user);

      emailController.clear();
      passwordController.clear();

      Get.snackbar(
        "نجاح",
        "تم إنشاء الحساب بنجاح",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );

      Future.delayed(Duration(seconds: 2), () {
        Get.offNamed('/home');
      });
    } catch (e) {
      Get.snackbar("خطأ", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تسجيل الدخول / إنشاء حساب")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: "الإيميل"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: isPasswordHidden,
              decoration: InputDecoration(
                labelText: "كلمة المرور",
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordHidden = !isPasswordHidden;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: signIn,
              child: Text("تسجيل الدخول"),
            ),
            ElevatedButton(
              onPressed: signUp,
              child: Text("إنشاء حساب"),
            ),
          ],
        ),
      ),
    );
  }
}