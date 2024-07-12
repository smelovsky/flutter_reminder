import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

import '../db_model.dart';
import '../models/reminder_item.dart';

/// Singleton сервис для определения базовых функций работы с БД
class DB {
  DB._();
  static final DB instance = DB._();
  static late Database _db;
  static bool _isInitialized = false;

  /// При изменении структуры базы, необходимо увеличить версию Базы (в названии файла)
  Future init() async {
    if (!_isInitialized) {
      var databasePath = await getDatabasesPath();
      var path = join(databasePath, "db_v1.0.2.db"); // Вот тут меняется версия

      _db = await openDatabase(path, version: 1, onCreate: _createDB);
      _isInitialized = true;
    }
  }

  /// Обязательно не забыть добавить путь до файла (в формате assets/<файл инициализации>.sql)
  /// в pubspec.yaml. Пример добавления новой таблицы есть в самом файле db_init.sql
  Future _createDB(Database db, int version) async {
    var dbInitScript = await rootBundle.loadString('assets/db/db_init.sql');

    dbInitScript.split(';').forEach((element) async {
      if (element.isNotEmpty) {
        await db.execute(element);
      }
    });
  }

  static final _factories = <Type, Function(Map<String, dynamic> map)>{
    ReminderItem: (map) => ReminderItem.fromMap(map),
  };

  String _dbName(Type type) {
    if (type == DbModel) {
      throw Exception("Type is required");
    }
    return "t_${(type).toString()}";
  }

  Future<Iterable<T>> getAll<T extends DbModel>({
    Map<String, Object?>? whereMap,
    int? take,
    int? skip,
  }) async {
    Iterable<Map<String, dynamic>> query;

    if (whereMap != null) {
      var whereBuilder = <String>[];
      var whereArgs = <dynamic>[];

      whereMap.forEach((key, value) {
        if (value is Iterable<dynamic>) {
          whereBuilder
              .add("$key IN (${List.filled(value.length, '?').join(',')})");
          whereArgs.addAll(value.map((e) => "$e"));
        } else {
          whereBuilder.add("$key = ?");
          whereArgs.add(value);
        }
      });

      query = await _db.query(_dbName(T),
          where: whereBuilder.join(' and '),
          whereArgs: whereArgs,
          offset: skip,
          limit: take);
    } else {
      query = await _db.query(
        _dbName(T),
        offset: skip,
        limit: take,
      );
    }

    var resList = query.map((e) => _factories[T]!(e)).cast<T>();

    return resList;
  }

  Future<T?> get<T extends DbModel>(dynamic id) async {
    var res = await _db.query(
      _dbName(T),
      where: 'id = ? ',
      whereArgs: [id],
    );
    return res.isNotEmpty ? _factories[T]!(res.first) : null;
  }

  Future<int> add<T extends DbModel>(T model) async => await _db.insert(
        _dbName(T),
        model.toMapValue(),
        conflictAlgorithm: null,
        nullColumnHack: null,
      );

  Future<int> insert<T extends DbModel>(T model) async => await _db.insert(
        _dbName(T),
        model.toMap(),
        conflictAlgorithm: null,
        nullColumnHack: null,
      );

  Future<int> update<T extends DbModel>(T model) async => _db.update(
        _dbName(T),
        model.toMap(),
        where: 'id = ?',
        whereArgs: [model.id],
      );

  Future<int> delete<T extends DbModel>(T model) async => _db.delete(
        _dbName(T),
        where: 'id = ?',
        whereArgs: [model.id],
      );

  Future<int> cleanTable<T extends DbModel>() async =>
      await _db.delete(_dbName(T));

  Future<int> createUpdate<T extends DbModel>(T model) async {
    var dbItem = await get<T>(model.id);
    var res = dbItem == null ? insert(model) : update(model);
    return await res;
  }

  Future<int> unselectAll<T extends DbModel>() async {
    var count =
        await _db.rawUpdate('UPDATE ${_dbName(T)} SET is_selected = ?', [0]);
    return count;
  }
}
