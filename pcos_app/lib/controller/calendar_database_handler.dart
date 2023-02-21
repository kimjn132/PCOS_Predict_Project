import 'package:path/path.dart';
import 'package:pcos_app/model/schedule.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'pcosrnd.db'),
      onCreate: (database, version) async {
        // 생성될때
        await database.execute(
          'create table schedule(id integer primary key autoincrement, date text, content text, dropdate text)',
        );
        await database.execute(
          'create table cycle(id integer primary key autoincrement, start text, end text)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertSchedule(Schedule schedule) async {
    final Database db = await initializeDB(); // 해당 위치가 어딘지
    await db.rawInsert('insert into schedule (date, content) values (?,?)',
        [schedule.date, schedule.content]);
  }

  Future<void> updateSchedule(String content, int id) async {
    final Database db = await initializeDB(); // 해당 위치가 어딘지
    await db.rawUpdate(
        'update schedule set content = ? where id = ?', [content, id]);
  }

  Future<void> deleteSchedule(int id, String today) async {
    final Database db = await initializeDB(); // 해당 위치가 어딘지
    await db.rawUpdate(
      'update schedule set dropdate = ? where id = ?',
      [today, id],
    );
  }

  // index 번호를 알아오기 위함
  Future<List<Schedule>> querySchedule() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        'select * from schedule where dropdate is null order by date desc');
    return queryResult.map((e) => Schedule.fromMap(e)).toList(); // decode
  }
}
