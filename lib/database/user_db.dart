import 'package:sqflite/sqflite.dart';

import '../models/userReponseModel.dart';
import 'database_service.dart';


class UserDB {
  final tableName = "users";
  
  Future<void> createTable(Database databse)async { //  PRIMARY KEY("id" AUTOINCREMENT)

    var sql = """CREATE TABLE IF NOT EXISTS $tableName(
    "id" PRIMARY KEY("id" AUTOINCREMENT),
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "mobile" TEXT NOT NULL,
    "gender" TEXT NOT NULL,
   );""";
    await databse.execute(sql);
  }

  Future<int> create({required userResonseModel usermodel}) async {

    final database = await DatabaseService().database;     // DateTime.now().microsecondsSinceEpoch
    return await database.rawInsert('''INSERT INTO $tableName (id,name,email,mobile,gender) VALUES (NULL,?,?,?,?)''',
      [usermodel.name,usermodel.email,usermodel.mobile,usermodel.gender]);
  }

 Future<List<userResonseModel>> fetchAll() async {
    final database = await DatabaseService().database;
    final users = await database.rawQuery(
      '''SELECT * from $tableName ORDER BY COALESCE(id,name)''');
    return users.map((user) => userResonseModel.fromSqfliteDatabase(user)).toList();

 }
  
}