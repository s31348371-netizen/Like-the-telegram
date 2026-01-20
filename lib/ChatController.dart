import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'AppDatabase.dart';

class ChatController extends GetxController {
  var chats = <Map<String, dynamic>>[].obs;

  // تغيير النوع إلى String ليتوافق مع Firebase UID
  Future<void> loadChats(String userId) async {
    Database db = await AppDatabase().database;
    // ملاحظة: يفضل تصفية المحادثات بناءً على userId إذا كان الجدول يدعم ذلك
    var result = await db.query('chats');
    chats.value = result;
  }

  // تم تغيير senderId إلى String هنا
  Future<void> sendMessage(int chatId, String senderId, String text) async {
    Database db = await AppDatabase().database;
    await db.insert('messages', {
      'chatId': chatId,
      'senderId': senderId, // سيقبل النص الآن بدون أخطاء
      'text': text,
      'timestamp': DateTime.now().toIso8601String(),
      'isRead': 0,
    });

    // تحديث آخر رسالة في جدول chats
    await db.update(
      'chats',
      {'lastMessage': text},
      where: 'id = ?',
      whereArgs: [chatId],
    );

    await loadChats(senderId); // إعادة تحميل المحادثات
  }

  Future<List<Map<String, dynamic>>> getMessages(int chatId) async {
    Database db = await AppDatabase().database;
    var result = await db.query(
      'messages',
      where: 'chatId = ?',
      whereArgs: [chatId],
      orderBy: 'timestamp ASC',
    );
    return result;
  }
}