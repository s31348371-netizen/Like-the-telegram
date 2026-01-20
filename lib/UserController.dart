import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController extends GetxController {
  Rxn<User> currentUser = Rxn<User>(); // يقبل null أو User

  void setUser(User? user) {
    currentUser.value = user;
  }
}