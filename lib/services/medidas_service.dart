import 'dart:convert';
import 'dart:typed_data';
import 'package:fit_match/models/medidas.dart';
import 'package:http/http.dart' as http;

class PlantillaPostsMethods {
  Future<void> createMedidas({
    required Medidas medidas,
    Uint8List? picture,
  }) async {
    var uri = Uri.parse('http://yourbackend/api/medidas');
    var request = http.MultipartRequest('POST', uri)
      ..fields['user_id'] = medidas.userId.toString()
      ..fields['left_arm'] = medidas.leftArm?.toString() ?? ''
      ..fields['right_arm'] = medidas.rightArm?.toString() ?? ''
      ..fields['shoulders'] = medidas.shoulders?.toString() ?? ''
      ..fields['neck'] = medidas.neck?.toString() ?? ''
      ..fields['chest'] = medidas.chest?.toString() ?? ''
      ..fields['waist'] = medidas.waist?.toString() ?? ''
      ..fields['upper_left_leg'] = medidas.upperLeftLeg?.toString() ?? ''
      ..fields['upper_right_leg'] = medidas.upperRightLeg?.toString() ?? ''
      ..fields['left_calve'] = medidas.leftCalve?.toString() ?? ''
      ..fields['right_calve'] = medidas.rightCalve?.toString() ?? ''
      ..fields['weight'] = medidas.weight?.toString() ?? ''
      ..fields['timestamp'] = medidas.timestamp?.toIso8601String() ?? '';

    // Añade la imagen si existe
    if (picture != null) {
      var pictureStream = http.ByteStream(Stream.value(picture));
      var pictureLength = picture.length;
      var multipartFile = http.MultipartFile(
          'picture', pictureStream, pictureLength,
          filename: 'medida_picture.jpg');
      request.files.add(multipartFile);
    }

    // Enviar el request
    var response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Error al crear medidas: ${response.statusCode}');
    }
  }

  Future<void> deleteMedidas(int medidaId) async {
    var uri = Uri.parse('http://yourbackend/api/medidas/$medidaId');
    var response = await http.delete(uri);

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar medidas: ${response.statusCode}');
    }
  }

  Future<List<Medidas>> getAllMedidas(int userId) async {
    var uri = Uri.parse('http://yourbackend/api/medidas/$userId');
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Medidas.fromJson(e)).toList();
    } else if (response.statusCode == 204) {
      return [];
    } else {
      throw Exception('Error al obtener medidas: ${response.statusCode}');
    }
  }

  Future<void> updateMedidas({
    required int medidaId,
    required double weight, // Agrega más parámetros según sean necesarios
    Uint8List? picture,
  }) async {
    var uri = Uri.parse('http://yourbackend/api/medidas/$medidaId');
    var request = http.MultipartRequest('PUT', uri)
      ..fields['weight'] =
          weight.toString(); // Agrega más campos según sean necesarios

    if (picture != null) {
      var pictureStream = http.ByteStream(Stream.value(picture));
      var pictureLength = picture.length;
      var multipartFile = http.MultipartFile(
          'picture', pictureStream, pictureLength,
          filename: 'medida_update_picture.jpg');
      request.files.add(multipartFile);
    }

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar medidas: ${response.statusCode}');
    }
  }
}
