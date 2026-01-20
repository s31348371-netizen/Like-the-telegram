import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class page9 extends StatefulWidget {
  const page9({super.key});

  @override
  State<page9> createState() => _Page9State();
}

class _Page9State extends State<page9> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<Map<String, String>> userList = [];
  String _currentLang = 'ar'; // اللغة الافتراضية
  final Map<String, Map<String, String>> _texts = {
    'ar': {
      'app_bar': 'إدارة الحسابات',
      'name_label': 'الاسم',
      'email_label': 'البريد',
      'pass_label': 'كلمة المرور',
      'add_btn': 'إضافة حساب جديد',
      'edit_title': 'تعديل',
      'save_btn': 'حفظ',
    },
    'en': {
      'app_bar': 'Account Management',
      'name_label': 'Name',
      'email_label': 'Email',
      'pass_label': 'Password',
      'add_btn': 'Add New Account',
      'edit_title': 'Edit',
      'save_btn': 'Save',
    }
  };

  String t(String key) => _texts[_currentLang]?[key] ?? key;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> saveUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = json.encode(userList);
    await prefs.setString('users_data', encodedData);
  }

  Future<void> loadUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('users_data');
    if (encodedData != null) {
      setState(() {
        userList = List<Map<String, String>>.from(
          json.decode(encodedData).map((item) => Map<String, String>.from(item)),
        );
      });
    }
  }

  void addUser() {
    if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
      setState(() {
        userList.add({
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        });
      });
      saveUsers();
      nameController.clear();
      emailController.clear();
      passwordController.clear();
    }
  }

  void deleteUser(int index) {
    setState(() {
      userList.removeAt(index);
    });
    saveUsers();
  }

  void updateUserInfo(int index) {
    setState(() {
      userList[index] = {
        'name': nameController.text,
        'email': emailController.text,
        'password': userList[index]['password']!,
      };
    });
    saveUsers();
    Navigator.pop(context);
    nameController.clear();
    emailController.clear();
  }

  void editUser(int index) {
    nameController.text = userList[index]['name']!;
    emailController.text = userList[index]['email']!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t('edit_title')),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: t('name_label'))),
              TextField(controller: emailController, decoration: InputDecoration(labelText: t('email_label'))),
            ]
        ),
        actions: [
          TextButton(onPressed: () => updateUserInfo(index), child: Text(t('save_btn')))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAr = _currentLang == 'ar';

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t('app_bar')),
          actions: [
            IconButton(
              icon: const Icon(Icons.language, color: Colors.blue),
              onPressed: () {
                setState(() {
                  _currentLang = (_currentLang == 'ar') ? 'en' : 'ar';
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: t('name_label'), border: const OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: emailController, decoration: InputDecoration(labelText: t('email_label'), border: const OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: passwordController, decoration: InputDecoration(labelText: t('pass_label'), border: const OutlineInputBorder())),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: addUser,
                child: Text(t('add_btn')),
              ),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(userList[index]['name']!),
                      subtitle: Text(userList[index]['email']!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: () => editUser(index)),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.grey), onPressed: () => deleteUser(index)),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}