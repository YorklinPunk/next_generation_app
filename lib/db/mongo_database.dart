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
      //"mongodb://zetita159:UNYj0yh8OrHpNDQZ@ac-xxxxx.mongodb.net:27017/DBNextGeneration?retryWrites=true&w=majority&tls=true"
      "mongodb://zetita159:UNYj0yh8OrHpNDQZ@ac-rr0zizn-shard-00-00.np6zcyj.mongodb.net:27017/DBNextGeneration?retryWrites=true&w=majority&tls=true"
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
