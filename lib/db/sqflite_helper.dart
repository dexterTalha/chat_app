import 'package:sqflite/sqflite.dart';
import 'package:tabahi_chat_app/db/db_query.dart';

class SqfliteHelper {
  //OPEN DB -> INITIALIZATION
  //CREATE TABLES
  //PERFORM OPERATION

  Future<Database> initialize() async {
    String path = await getDatabasesPath();
    Database db = await openDatabase(
      "$path/chat_db.db",
      version: 1,
      onCreate: (db, version) async {
        await db.execute(Query.createChatTable);
      },
    );
    return db;
  }

  Future<dynamic> getAllData() async {
    Database db = await initialize();
    var data = await db.rawQuery("SELECT id, msg, sender FROM ${Query.chat} WHERE sender='123'"); //raw query method
    var data2 = await db.query(Query.chat, columns: [], where: "sender='123'"); //sqflite method use
    var data3 = await db.query(Query.chat, where: "sender=? AND receiver=?", whereArgs: ['123', '345']); //sqflite method use
    var data4 = await db.insert(Query.chat, {
      'id': "abc",
      'isseen': 0,
    });

    var map = [
      {
        'mytask': "task1",
        'start_date': "2342432",
      },
      {
        'mytask': "task2",
        'start_date': "654",
      },
      {
        'mytask': "task3",
        'start_date': "5678",
      }
    ];
  }
}
