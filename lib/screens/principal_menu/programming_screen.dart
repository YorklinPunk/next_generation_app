import 'package:flutter/material.dart';
import 'package:next_generation_app/db/mongo_database.dart';
import 'package:next_generation_app/models/programming_model.dart';
import 'package:next_generation_app/utils/dialog_helper.dart'; // tu función de dialog

class ProgrammingScreen extends StatefulWidget {
  const ProgrammingScreen({super.key});

  @override
  State<ProgrammingScreen> createState() => _ProgrammingScreenState();
}

class _ProgrammingScreenState extends State<ProgrammingScreen> {
  List<ProgrammingModel> _programmings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProgramming();
  }

  Future<void> _loadProgramming() async {
    // final current = await MongoDatabase.getLastProgramming();

    // if (current.isEmpty) {
    if (true) {
      showCustomDialog(context, "Aún no hay programación para esta semana", 2);
      final prev = await MongoDatabase.getPreviousProgrammings();
      setState(() {
        _programmings = prev;
        _loading = false;
      });
    } else {
      setState(() {
        _programmings = [];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Programación semanal"),
        backgroundColor: const Color(0xFFf8e152),
      ),
      backgroundColor: const Color(0xFFf8e152),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _programmings.length,
              itemBuilder: (context, index) {
                final p = _programmings[index];
                return Card(
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    title: Text(
                      "Servicio: ${p.servicio}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Fecha: ${p.fechaServicio.toLocal()}"),
                    trailing: Icon(Icons.people),
                  ),
                );
              },
            ),
    );
  }
}
