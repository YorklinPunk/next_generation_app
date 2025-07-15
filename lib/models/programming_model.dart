class ProgrammingModel {
  final String servicio;
  final DateTime fechaServicio;
  final List<String> servidores;

  ProgrammingModel({
    required this.servicio,
    required this.fechaServicio,
    required this.servidores,
  });

  factory ProgrammingModel.fromMap(Map<String, dynamic> map) {
    return ProgrammingModel(
      servicio: map['servicio'] ?? '',
      fechaServicio: DateTime.parse(map['fechaServicio'].toString()),
      servidores: List<String>.from(map['servidores'] ?? []),
    );
  }
}
