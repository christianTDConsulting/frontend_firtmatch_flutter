import 'dart:convert';
import 'dart:typed_data';
import 'package:fit_match/models/ejercicios.dart';
import 'package:fit_match/models/sesion_entrenamiento_entrada.dart';
import 'package:fit_match/utils/backendUrls.dart';
import 'package:http/http.dart' as http;
import 'package:fit_match/models/post.dart'; // Asegúrate de importar tu clase Post

Future<List<PlantillaPost>> getAllPosts(num userId,
    {int page = 1, int pageSize = 10}) async {
  final String url = "$plantillaPostsUrl?page=$page&pageSize=$pageSize";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body) as List;

    List<PlantillaPost> posts =
        jsonData.map((jsonItem) => PlantillaPost.fromJson(jsonItem)).toList();

    return posts;
  } else {
    throw Exception(
        'Error al obtener los posts. Código de estado: ${response.statusCode}');
  }
}

Future<List<PlantillaPost>> getPostsById(num userId,
    {int page = 1, int pageSize = 10}) async {
  final String url = "$plantillaPostsUrl/$userId?page=$page&pageSize=$pageSize";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body) as List;

    List<PlantillaPost> posts =
        jsonData.map((jsonItem) => PlantillaPost.fromJson(jsonItem)).toList();

    return posts;
  } else {
    throw Exception(
        'Error al obtener los posts. Código de estado: ${response.statusCode}');
  }
}

Future<void> postPlantilla({
  required String templateName,
  required String description,
  required Uint8List? picture,
  required List<String> etiquetas,
}) async {
  var request = http.MultipartRequest('POST', Uri.parse(plantillaPostsUrl));

  // Agregar la imagen si está presente
  if (picture != null) {
    var pictureStream = http.ByteStream(Stream.value(picture));
    var pictureLength = picture.length;
    var multipartFile = http.MultipartFile(
        'picture', pictureStream, pictureLength,
        filename: 'template_picture.jpg');
    request.files.add(multipartFile);
  }

  // Crear el cuerpo de la solicitud
  request.fields['template_name'] = templateName;
  request.fields['description'] = description;
  request.fields['etiquetas'] =
      etiquetas.join(','); // Asumiendo que el servidor espera una cadena

  // Realizar la solicitud POST
  var response = await request.send();

  // Manejar la respuesta
  if (response.statusCode == 200) {
    print('Plantilla creada con éxito');
  } else {
    // Considerar la lectura del cuerpo de la respuesta para obtener más detalles sobre el error
    var responseBody = await response.stream.bytesToString();
    throw Exception(
        'Error al crear la plantilla. Código de estado: ${response.statusCode}, Respuesta: $responseBody');
  }
}

Future<void> putPlantilla(PlantillaPost plantilla) async {
  final response = await http.put(
    Uri.parse('$plantillaPostsUrl/${plantilla.templateId}'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(plantilla.toJson()),
  );

  if (response.statusCode == 200) {
    print('Plantilla actualizada con éxito');
  } else {
    throw Exception(
        'Error al actualizar la plantilla. Código de estado: ${response.statusCode}');
  }
}

Future<void> createSesionEntrenamiento({
  required int templateId,
  required List<Map<String, dynamic>> ejercicios,
}) async {
  final response = await http.post(
    Uri.parse('$sesionEntrenamientoUrl'),
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
  final response = await http.delete(
    Uri.parse('$sesionEntrenamientoUrl/$sessionId'),
  );

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

Future<void> createRutinaGuardada(int userId, int templateId) async {
  final response = await http.post(
    Uri.parse(rutinasGuardadasUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'user_id': userId,
      'template_id': templateId,
    }),
  );

  if (response.statusCode != 201) {
    throw Exception(
        'Error al guardar la rutina. Código de estado: ${response.statusCode}');
  }
}

Future<void> deleteRutinaGuardada(int savedId) async {
  final response = await http.delete(
    Uri.parse('$rutinasGuardadasUrl/$savedId'),
  );

  if (response.statusCode != 200) {
    throw Exception(
        'Error al eliminar la rutina guardada. Código de estado: ${response.statusCode}');
  }
}

Future<void> createSesionEntrenamientoEntrada(
    int userId, int sessionId, List<EjercicioEntrada> ejerciciosEntrada) async {
  final response = await http.post(
    Uri.parse(sesionEntrenamientoEntradaUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'user_id': userId,
      'session_id': sessionId,
      'ejercicios': ejerciciosEntrada.map((e) => e.toJson()).toList(),
    }),
  );

  if (response.statusCode == 201) {
    print('Sesión de entrenamiento de entrada creada con éxito');
  } else {
    throw Exception(
        'Error al crear la sesión de entrenamiento de entrada. Código de estado: ${response.statusCode}');
  }
}

Future<void> deleteSesionEntrenamientoEntrada(int entryId) async {
  final response =
      await http.delete(Uri.parse('$sesionEntrenamientoEntradaUrl/$entryId'));

  if (response.statusCode == 200) {
    print('Sesión de entrenamiento de entrada eliminada con éxito');
  } else {
    throw Exception(
        'Error al eliminar la sesión de entrenamiento de entrada. Código de estado: ${response.statusCode}');
  }
}

Future<void> editSesionEntrenamientoEntrada(
    int entryId, SesionEntrenamientoEntrada sesionEntrada) async {
  final response = await http.put(
    Uri.parse('$sesionEntrenamientoEntradaUrl/$entryId'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(sesionEntrada.toJson()),
  );

  if (response.statusCode == 200) {
    print('Sesión de entrenamiento de entrada editada con éxito');
  } else {
    throw Exception(
        'Error al editar la sesión de entrenamiento de entrada. Código de estado: ${response.statusCode}');
  }
}
