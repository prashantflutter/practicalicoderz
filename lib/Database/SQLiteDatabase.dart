import 'package:sqflite/sqflite.dart' as sql;


class SQLiteDatabase {

  //// CREATED TABLE ////

  static Future<void>createTable(sql.Database database)async{
    await database.execute(
        """CREATE TABLE userData(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    categoryName TEXT,
    type TEXT,
    refNo TEXT,
    date TEXT,
    amount TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 
    )""");
  }

  ////// Created Database ////////
  static Future<sql.Database>db()async{
    return sql.openDatabase('managementByPrashant.db',version: 1,onCreate: (sql.Database database,int version)async{
      await createTable(database);
    });
  }


  // Create Method for store data in database
  static Future<int> createData(String title,String categoryName,String type,String refNo,
      String date,String? amount)async{

    // SQLiteDatabase class Name where created and all data pass in created object

    final db = await SQLiteDatabase.db();
    final data = {
      'title':title,
      'categoryName':categoryName,
      'type':type,
      'refNo':refNo,
      'date':date,
      'amount':amount,
    };
    final id = await db.insert('userData', data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;

  }


  // Get All Data from Database Method Created
  static Future<List<Map<String,dynamic>>>getAllData()async{
    final db = await SQLiteDatabase.db();
    return db.query('userData',orderBy: 'id');
  }


  // Get Single Data from Database Method
  static  Future<List<Map<String,dynamic>>>getSingleData(int id)async{
    final db = await SQLiteDatabase.db();
    return db.query('userData',where: 'id = ?',whereArgs: [id],limit: 1);
  }


  // Update Data in Database using this Method
  static Future<int>updateData(int id,String title,String categoryName,String type,String refNo, String date,String? amount)async{
    final db =  await SQLiteDatabase.db();
    final data = {
      'title':title,
      'categoryName':categoryName,
      'type':type,
      'refNo':refNo,
      'date':date,
      'amount':amount,
      'createdAt':DateTime.now().toString()
    };
    final result = await db.update('userData', data,where: 'id = ?',whereArgs: [id]);
    return result;
  }

  // Delete Data from Database Created Method
  static Future<void>deleteData(int id)async{
    final db = await SQLiteDatabase.db();
    try{
      await db.delete('userData',where: 'id = ?',whereArgs: [id]);
    }catch(e){
      print('error $e');
    }
  }
// All Data from Database DeleteAllData Method
  static Future<void> deleteAllData() async {
    final db = await SQLiteDatabase.db();
    try {
      await db.delete('userData'); // Delete all data from your table
    } catch (ex) {
      print('Error deleting data: $ex');
    }
  }



}