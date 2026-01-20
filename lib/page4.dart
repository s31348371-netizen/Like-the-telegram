import 'package:flutter/material.dart';

class page4 extends StatefulWidget {
  @override
  State<page4> createState() => _page2State();
}

class _page2State extends State<page4> {
  List studends = ["ahmed", "ali", "sarah", "ahmed", "ali", "sarah"];
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("جهات الاتصال", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              controller: name,
              decoration: InputDecoration(
                label: Text("Name:"),
                border: OutlineInputBorder(),
                hintText: "input u Name:",
                fillColor: Colors.blue[100],
                filled: true,
                prefixIcon: Icon(Icons.person),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // التصحيح: يجب وضع الإضافة داخل setState لتحديث الشاشة فوراً
              setState(() {
                if (name.text.isNotEmpty) {
                  studends.add(name.text);
                  name.clear(); // مسح النص بعد الإضافة
                }
              });
            },
            child: Text("add student"),
          ),
          Expanded(
            child: ListView.builder(
              // الحل الأساسي: تفعيل هذا السطر وإزالة العلامات عنه 👇
              itemCount: studends.length,
              itemBuilder: (context, i) {
                return Container(
                  color: Colors.blue[100],
                  margin: EdgeInsets.all(5),
                  child: ListTile(
                    leading: IconButton(
                      onPressed: () {
                        setState(() {
                          studends.removeAt(i); // الحذف داخل setState
                        });
                      },
                      icon: Icon(Icons.delete, color: Colors.grey),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          if (name.text.isNotEmpty) {
                            studends[i] = name.text;
                            name.clear();
                          }
                        });
                      },
                      icon: Icon(Icons.update),
                    ),
                    onTap: () {
                      name.text = studends[i];
                    },
                    title: Text(
                      studends[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}