import 'package:flutter/material.dart';
import 'package:next_generation_app/db/mongo_database.dart';
import 'package:next_generation_app/models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _documentController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      final user = UserModel(
        name: _nameController.text,
        lastName: _lastNameController.text,
        document: _documentController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        role: 3,
        state: 1,
        dateRegistration: DateTime.now(),
      );

      await MongoDatabase.userCollection.insertOne(user.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Usuario registrado")),
      );

      Navigator.pop(context); // volver a login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E2C),
        elevation: 0,
        title: Text("Registro", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _campo("Nombres", _nameController),
              _campo("Apellidos", _lastNameController),
              _campo("Documento", _documentController),
              _campo("Usuario", _usernameController),
              _campo("Contraseña", _passwordController, isPassword: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarUsuario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFff8e3a),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text("Crear cuenta", style: TextStyle(color: Colors.black)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _campo(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFff8e3a))),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Campo requerido" : null,
      ),
    );
  }
}
