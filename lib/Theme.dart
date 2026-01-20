// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
//
// class ThemeController extends GetxController {
//   final _box = GetStorage(); // إنشاء نسخة من التخزين
//   final _key = 'isDarkMode'; // المفتاح الذي سنخزن به القيمة
//
//   // عند تشغيل الكنترولر، يقرأ الحالة المحفوظة أو يفترض أنها false
//   RxBool isDarkMode = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     isDarkMode.value = _box.read(_key) ?? false;
//   }
//
//   void toggleTheme() {
//     if (Get.isDarkMode) {
//       Get.changeThemeMode(ThemeMode.light);
//       isDarkMode.value = false;
//     } else {
//       Get.changeThemeMode(ThemeMode.dark);
//       isDarkMode.value = true;
//     }
//
//     // السطر المطلوب لحفظ الحالة في ذاكرة الهاتف
//     _box.write(_key, isDarkMode.value);
//   }
// }