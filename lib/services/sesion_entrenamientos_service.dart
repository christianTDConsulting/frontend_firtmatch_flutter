import 'dart:convert';
import 'package:fit_match/models/ejercicios.dart';
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

  Future<List<Ejercicios>> getAllEjercicios({
    num? userId,
    String? name,
    int? idGrupoMuscular,
    int? idMaterial,
    int page = 1,
    int pageSize = 20,
  }) async {
    // Comienza con la URL base y los parámetros de paginación.
    String url = "$ejerciciosUrl?page=$page&pageSize=$pageSize";

    // Añade los parámetros adicionales si están presentes.
    if (userId != null) url += "&userId=$userId";
    if (name != null)
      url +=
          "&name=${Uri.encodeComponent(name)}"; // Codifica el nombre para URL.
    if (idGrupoMuscular != null) url += "&idGrupoMuscular=$idGrupoMuscular";
    if (idMaterial != null) url += "&idMaterial=$idMaterial";

    // Realiza la solicitud HTTP.
    final response = await http.get(Uri.parse(url));

    // Procesa la respuesta.
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body) as List;
      return jsonData.map((jsonItem) => Ejercicios.fromJson(jsonItem)).toList();
    } else {
      throw Exception(
          'Error al obtener los ejercicios. Código de estado: ${response.statusCode}');
    }
  }

  Future<List<GrupoMuscular>> getGruposMusculares() async {
    final response = await http.get(Uri.parse(grupoMuscularesUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body) as List;
      return jsonData
          .map((jsonItem) => GrupoMuscular.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception('Error al obtener los grupos musculares');
    }
  }

  Future<List<Equipment>> getMaterial() async {
    final response = await http.get(Uri.parse(materialUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body) as List;
      return jsonData
          .map((jsoinItem) => Equipment.fromJson(jsoinItem))
          .toList();
    } else {
      throw Exception('Error al obtener los materiales');
    }
  }

  Future<List<Ejercicios>> getEjerciciosByGrupoMuscular({
    required int grupoMuscularId,
    int? page = 1,
    int? pageSize = 20,
  }) async {
    String url =
        "$ejerciciosUrl/grupoMuscular/$grupoMuscularId?page=$page&pageSize=$pageSize";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body) as List;
      return jsonData.map((jsonItem) => Ejercicios.fromJson(jsonItem)).toList();
    } else {
      throw Exception(
          'Error al obtener los posts. Código de estado: ${response.statusCode}');
    }
  }
}
