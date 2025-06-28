import 'package:mongo_dart/mongo_dart.dart';
import '../models/user_model.dart';

class MongoDatabase {
  static var db;
  static var userCollection;
  static var servicesCollection;
  static var rolesCollection;
  static var checkinsCollection;

  static Future<void> connect() async {
    db = await Db.create(
      "mongodb://flutter_user:Flutter2024!@ac-8rk5moq-shard-00-00.np6zcyj.mongodb.net:27017,ac-8rk5moq-shard-00-01.np6zcyj.mongodb.net:27017,ac-8rk5moq-shard-00-02.np6zcyj.mongodb.net:27017/?ssl=true&replicaSet=atlas-8rk5moq-shard-0&authSource=admin&retryWrites=true&w=majority"
    );
    await db.open();
    print("✅ Conectado a MongoDB");

    userCollection = db.collection("users");
    servicesCollection = db.collection("services");
    rolesCollection = db.collection("roles");
    checkinsCollection = db.collection("checkins");
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
}
