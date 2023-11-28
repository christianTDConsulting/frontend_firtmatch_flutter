import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';

class AuthMethods {
  final backend_url = "http://localhost:3000";
  var _token = "";

  String get token => _token;

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Ha ocurrido algún error";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Create a map containing user credentials
        Map<String, dynamic> userCredentials = {
          'email': email,
          'password': password,
        };

        // Convert the map to a JSON string
        String jsonData = json.encode(userCredentials);

        // Send a POST request for login
        final response = await http.post(
          Uri.parse(
              '$backend_url/verificar'), // Replace with your login API endpoint
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonData,
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        // Check the response status
        if (response.statusCode == 200) {
          // Parse the response JSON if needed
          // Update 'res' based on the response from your backend
          res = "success";
          _token = response.body;
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

  Future<String> registerUser({
    required String email,
    required String password,
    required String username,
    required DateTime birth,
    required Uint8List pic,
    required num id,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          id != null ||
          birth != null ||
          pic != null) {
        // Create a map containing user data
        Map<String, dynamic> userData = {
          'email': email,
          'password': password,
          'username': username,
          'birth': birth,
          'profile_pictre': pic,
          'profile_id': id
        };

        // Convert the map to a JSON string
        String jsonData = json.encode(userData);

        // Send a POST
        final response = await http.post(
          Uri.parse('$backend_url/usuarios'), // Replace with your API endpoint
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonData,
        );

        // Check the response status
        if (response.statusCode == 200) {
          // Parse the response JSON if needed
          // Update 'res' based on the response from your backend
          res = "success";
        } else {
          res = "Failed to register. Please try again.";
        }
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }
}
