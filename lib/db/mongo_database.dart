import 'package:mongo_dart/mongo_dart.dart';
import '../models/programming_model.dart';
import '../models/user_model.dart';
import '../models/ministry_model.dart';

import 'package:crypto/crypto.dart';
import 'dart:convert';

class MongoDatabase {
  static var db;
  static var userCollection;
  static var servicesCollection;
  static var rolesCollection;
  static var checkinsCollection;
  static var ministriesCollection;
  static var programmingCollection;

  static Future<void> connect() async {
    db = await Db.create(
      "mongodb://flutter_user:Flutter2024!@ac-8rk5moq-shard-00-00.np6zcyj.mongodb.net:27017,ac-8rk5moq-shard-00-01.np6zcyj.mongodb.net:27017,ac-8rk5moq-shard-00-02.np6zcyj.mongodb.net:27017/DBNextGeneration?ssl=true&replicaSet=atlas-8rk5moq-shard-0&authSource=admin&retryWrites=true&w=majority"
    );

    await db.open();
    print("✅ Conectado a MongoDB");

    userCollection = db.collection("users");
    servicesCollection = db.collection("services");
    rolesCollection = db.collection("roles");
    checkinsCollection = db.collection("checkins");
    ministriesCollection = db.collection("ministries");
    programmingCollection = db.collection("programming");
  }

  //Hash de contraseña
  // Utiliza SHA-256 para encriptar la contraseña
  static String encriptarPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<List<Map<String, dynamic>>> getUsuarios() async {
    return await userCollection.find().toList();
  }

    // Método para insertar un usuario con modelo
  static Future<void> insertUser(UserModel user) async {
    try {
      await userCollection.insertOne(user.toMap());
      print("Usuario registrado con éxito ${user.username}");
    } catch (e) {
      print("Error al registrar: $e");
    }
  }

  static Future<List<UserModel>> getUsers() async {
    final docs = await userCollection.find().toList();
    return docs.map((doc) => UserModel.fromMap(doc)).toList();
  }

  static Future<bool> existeUsername(String username) async {
    final user = await userCollection.findOne({'username': username});
    return user != null;
  }

  static Future<bool> existeDocumento(String document) async {
    final user = await userCollection.findOne({'document': document});
    return user != null;
  }


  //LISTA DE MINISTERIOS
  static Future<List<MinistryModel>> getMinistries() async {
    try {
      final results = await ministriesCollection.find().toList();

      final ministries = results.map((doc) {
        final map = Map<String, dynamic>.from(doc); // conversión explícita
        if (map['status'] == 1 && map.containsKey('codMinistry')) {
          return MinistryModel.fromMap(map);
        }
        // Validar que los campos existan
        if (map.containsKey('codMinistry') && map.containsKey('nomMinistry')) {
          return MinistryModel.fromMap(map);
        } else {
          print("❌ Registro inválido: $map");
          return null;
        }
      }).whereType<MinistryModel>().toList();

      return ministries;
    } catch (e) {
      print("❌ Error al obtener ministerios: $e");
      return [];
    }
  }

  static Future<List<ProgrammingModel>> getLastProgramming() async {
    final results = await programmingCollection.find().sort({'fechaServicio': -1}).limit(1).toList();

    if (results.isEmpty) return [];

    final last = ProgrammingModel.fromMap(results.first);
    final now = DateTime.now();

    final lastWeek = DateTime.utc(last.fechaServicio.year, last.fechaServicio.month, last.fechaServicio.day);
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = now.add(Duration(days: 7 - now.weekday));

    if (lastWeek.isBefore(startOfWeek) || lastWeek.isAfter(endOfWeek)) {
      return []; // Indica que no es de esta semana
    }

    return [last];
  }

  static Future<List<ProgrammingModel>> getPreviousProgrammings() async {
    final results = await programmingCollection.find().sort({'fechaServicio': -1}).skip(1).limit(5).toList();
    return results.map((e) => ProgrammingModel.fromMap(e)).toList();
  }

}
