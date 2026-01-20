import 'package:firstapp/page2.dart';
import 'package:firstapp/page3.dart';
import 'package:firstapp/page4.dart';
import 'package:firstapp/page5.dart';
import 'package:firstapp/page6.dart';
import 'package:firstapp/page7.dart';
import 'package:firstapp/page8.dart';
import 'package:firstapp/page9.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ChatController.dart';
import 'package:firstapp/controllers/UserControllers.dart';
import 'Chatpage.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final ChatController chatController = Get.put(ChatController());

  Container buildListTile(BuildContext context, String txt, icon, page) {
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      child: ListTile(
        tileColor: Colors.white,
        title: Text(txt),
        leading: Icon(icon),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<UserController>();
    final user = c.currentUser;

    if (user != null) {
      chatController.loadChats(user.uid);
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: Colors.blue,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage('assets/image/a.jpg'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      user?.email ?? "مستخدم",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              buildListTile(context, "الملف لشخصي", Icons.account_circle_outlined, page2()),
              buildListTile(context, "مجموعة جديدة", Icons.add_box, page3()),
              buildListTile(context, "جهات الاتصال", Icons.account_circle_outlined, page4()),
              buildListTile(context, "المكالمات", Icons.call, page5()),
              buildListTile(context, "الرسائل المحفوظة", Icons.save_sharp, page6()),
              buildListTile(context, "الاعدادات", Icons.settings, page7()),
              buildListTile(context, "دعوة الاصدقاء", Icons.person_add_rounded, page8()),
              buildListTile(context, "ميزات تليجرام", Icons.question_mark, page9()),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "تليجرام",
            style: TextStyle(color: Colors.white),
          ),
        ),

        // عرض المحادثات من SQLite
        body: Obx(() {
          if (chatController.chats.isEmpty) {
            return Center(child: Text("لا توجد محادثات بعد"));
          }

          return ListView.builder(
            itemCount: chatController.chats.length,
            itemBuilder: (context, index) {
              var chat = chatController.chats[index];
              String chatName = chat['isGroup'] == 1 ? "مجموعة" : "محادثة خاصة";

              return ListTile(
                title: Text(chat['lastMessage'] == "" ? chatName : chat['lastMessage']),
                subtitle: Text(chat['isGroup'] == 1 ? "مجموعة" : "خاص"),
                leading: CircleAvatar(
                  child: Text(chatName[0]),
                  backgroundColor: Colors.blueAccent,
                ),
                onTap: () {
                  Get.to(() => ChatPage(
                    chatId: chat['id'],
                    chatName: chatName,
                  ));
                },
              );
            },
          );
        }),

        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.white), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
                label: "Camera"),
            BottomNavigationBarItem(
                icon: Icon(Icons.edit, color: Colors.white), label: "Edit")
          ],
        ),
      ),
    );
  }
}