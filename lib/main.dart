import 'package:flutter/material.dart';
import 'package:next_generation_app/services/api_service.dart';
import 'screens/home_screen.dart';

void main() {
  final apiService = ApiService(
    baseUrl: 'https://dominio-api.com/', //CAMBIAR DOMINIO DE API
    ignoreBadCertificates: true
  );
    runApp(MyApp(apiService: apiService));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;

  const MyApp({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(apiService: apiService)
    );
  }
}