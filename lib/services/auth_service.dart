import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fit_match/utils/backendUrls.dart';
import 'dart:async';
import 'dart:convert';

class AuthMethods {
  SharedPreferences? preferences;
  static const successMessage = "success";
  void initPrefrences() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Ha ocurrido algún error";
    try {
      // Initialize preferences
      initPrefrences();

      if (email.isNotEmpty && password.isNotEmpty) {
        // Create a map containing user credentials
        Map<String, dynamic> userCredentials = {
          'email': email,
          'plainPassword': password,
        };

        // Convert the map to a JSON string
        String jsonData = json.encode(userCredentials);

        // Send a POST request for login
        final response = await http.post(
          Uri.parse(loginUrl), // Replace with your login API endpoint
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonData,
        );

        print('Response status: ${response.statusCode}');

        // Check the response status
        if (response.statusCode == 200) {
          // Parse the response JSON if needed
          // Update 'res' based on the response from your backend
          res = successMessage;

          await preferences!
              .setString('token', json.decode(response.body)['token']);
          print(preferences!.getString('token'));
        } else {
          res = "Error, comprueba tus credenciales.";
        }
      } else {
        res = "Por favor escribe tu correo y contraseña.";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> createUsuario({
    required String username,
    required String email,
    required String password,
    required int profileId,
    required String birth,
    required String profilePicturePath, // Ruta del archivo de la imagen
  }) async {
    // Crear un MultipartRequest para manejar la imagen de perfil
    var request = http.MultipartRequest('POST', Uri.parse(usuariosUrl));

    // Agregar los campos de texto
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['profile_id'] = profileId.toString();
    request.fields['birth'] = birth;

    // Adjuntar la imagen de perfil como un MultipartFile
    var profilePicture = await http.MultipartFile.fromPath(
        'profile_picture', profilePicturePath);
    request.files.add(profilePicture);

    // Enviar la solicitud y capturar la respuesta
    var response = await request.send();

    if (response.statusCode == 201) {
      // Manejar la respuesta exitosa
      print('Usuario creado con éxito.');
    } else {
      // Si la solicitud no fue exitosa, lanza una excepción o maneja el error
      throw Exception(
          'Error al crear el usuario. Código de estado: ${response.statusCode}');
    }
  }
}
