import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController extends GetxController {
  // متغير يراقب المستخدم الحالي
  var user = Rxn<User>();

  // لتحديث المستخدم الحالي عند تسجيل الدخول أو إنشاء الحساب
  void setUser(User? u) {
    user.value = u;
  }

  // للحصول على المستخدم الحالي بسهولة
  User? get currentUser => user.value;

  // للتحقق إذا كان المستخدم مسجل دخول
  bool get isLoggedIn => user.value != null;
}