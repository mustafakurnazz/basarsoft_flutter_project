import 'package:basarsoft/core/model/new_activity_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:latlong2/latlong.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'activities.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE activities(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        activityId TEXT,
        userId TEXT,
        totalDistance REAL,
        activityTimer INTEGER,
        averageSpeed REAL,
        startLocationLat REAL,
        startLocationLng REAL,
        endLocationLat REAL,
        endLocationLng REAL,
        timestamp TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE routePoints(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        activityId TEXT,
        latitude REAL,
        longitude REAL,
        FOREIGN KEY(activityId) REFERENCES activities(activityId)
      )
    ''');
  }

   Future<List<Map<String, dynamic>>> getAllRecords() async {
    final db = await database;
    return await db.rawQuery('SELECT * FROM activities');
  }

  Future<void> printAllRecords() async {
    final records = await getAllRecords();
    for (var record in records) {
      print(record);
    }
  }

  Future<void> insertActivity(NewActivityModel activity) async {
    final db = await database;

    await db.insert('activities', {
      'activityId': activity.activityId,
      'userId': activity.userId,
      'totalDistance': activity.totalDistance,
      'activityTimer': activity.activityTimer,
      'averageSpeed': activity.averageSpeed,
      'startLocationLat': activity.startLocation?.latitude,
      'startLocationLng': activity.startLocation?.longitude,
      'endLocationLat': activity.endLocation?.latitude,
      'endLocationLng': activity.endLocation?.longitude,
      'timestamp': activity.timestamp.toDate().toIso8601String(),
    });

    for (LatLng point in activity.routePoints) {
      await db.insert('routePoints', {
        'activityId': activity.activityId,
        'latitude': point.latitude,
        'longitude': point.longitude,
      });
    }
  }
}
