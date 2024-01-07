import 'package:fit_match/models/user.dart';
import 'package:fit_match/screens/client/create_plantilla_screen.dart';
import 'package:fit_match/utils/colors.dart';
import 'package:flutter/material.dart';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:fit_match/providers/get_jwt_token.dart';

class ViewTrainingScreen extends StatefulWidget {
  @override
  _ViewTrainingScreen createState() => _ViewTrainingScreen();
}

class _ViewTrainingScreen extends State<ViewTrainingScreen> {
  User user = User(
      user_id: 0,
      username: '',
      email: '',
      password: '',
      profile_picture: '',
      birth: DateTime.now(),
      profile_id: 0);
  final List<String> trainingTemplates = [
    'Plantilla 1',
    'Plantilla 2',
    'Plantilla 3',
    // Agrega más plantillas según sea necesario
  ];

  void _editTemplate(String templateName) {
    // Lógica para editar la plantilla
    print('Editar $templateName');
  }

  void _deleteTemplate(String templateName) {
    // Lógica para eliminar la plantilla
    print('Eliminar $templateName');
  }

  void _createNewTemplate() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => CreateProgramScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void initUser() async {
    try {
      String? token = await getToken();
      if (token != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        user = decodedToken['user'];
        print(user);
      }
    } catch (e) {
      print('Error al decodificar el token o al manejar el userId: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantillas'),
      ),
      body: ListView.builder(
        itemCount: trainingTemplates.length,
        itemBuilder: (context, index) {
          String templateName = trainingTemplates[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(templateName),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      _editTemplate(templateName);
                      break;
                    case 'delete':
                      _deleteTemplate(templateName);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Editar'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Eliminar'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewTemplate,
        backgroundColor: blueColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
