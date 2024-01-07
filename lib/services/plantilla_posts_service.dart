import 'dart:convert';
import 'dart:typed_data';
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
  final String url =
      'tu_endpoint_para_actualizar_plantilla/${plantilla.templateId}'; // Reemplaza con tu URL
  final response = await http.put(
    Uri.parse(url),
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
