import 'dart:convert';
import 'package:fit_match/models/sesion_entrenamiento.dart';
import 'package:http/http.dart' as http;
import 'package:fit_match/utils/backend_urls.dart';

class SesionEntrenamientoMethods {
  Future<void> createSesionEntrenamiento({
    required int templateId,
    required List<Map<String, dynamic>> ejercicios,
  }) async {
    final response = await http.post(
      Uri.parse(sesionEntrenamientoUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'template_id': templateId,
        'ejercicios': ejercicios,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception(
          'Error al crear la sesión de entrenamiento. Código de estado: ${response.statusCode}');
    }
  }

  Future<void> deleteSesionEntrenamiento(int sessionId) async {
    final response =
        await http.delete(Uri.parse('$sesionEntrenamientoUrl/$sessionId'));
    if (response.statusCode != 200) {
      throw Exception(
          'Error al eliminar la sesión de entrenamiento. Código de estado: ${response.statusCode}');
    }
  }

  Future<void> editSesionEntrenamiento(
      int sessionId, Map<String, dynamic> sessionData) async {
    final response = await http.put(
      Uri.parse('$sesionEntrenamientoUrl/$sessionId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(sessionData),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Error al editar la sesión de entrenamiento. Código de estado: ${response.statusCode}');
    }
  }

  Future<List<SesionEntrenamiento>> getSesionesEntrenamientoByTemplateId(
      templateId) async {
    final response = await http.get(
      Uri.parse('$sesionEntrenamientoUrl?template_id=$templateId'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body) as List;
      return jsonData
          .map((jsonItem) => SesionEntrenamiento.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception(
          'Error al obtener los posts. Código de estado: ${response.statusCode}');
    }
  }
}

class EjerciciosMethods {
  Future<void> createEjercicio(String name, String description) async {
    final response = await http.post(
      Uri.parse(ejerciciosUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception(
          'Error al crear el ejercicio. Código de estado: ${response.statusCode}');
    }
  }
}
