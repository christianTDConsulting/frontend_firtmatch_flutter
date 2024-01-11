import 'package:fit_match/models/user.dart';
import 'package:fit_match/screens/client/training/create_plantilla_screen.dart';
import 'package:fit_match/utils/colors.dart';
import 'package:flutter/material.dart';

class ViewTrainingScreen extends StatefulWidget {
  final User user;
  const ViewTrainingScreen({super.key, required this.user});

  @override
  _ViewTrainingScreen createState() => _ViewTrainingScreen();
}

class _ViewTrainingScreen extends State<ViewTrainingScreen> {
  final List<String> trainingTemplates = [
    'Plantilla 1',
    'Plantilla 2',
    'Plantilla 3',
  ];

  void _editTemplate(String templateName) {
    // Lógica para editar la plantilla
    print('Editar $templateName');
  }

  void _deleteTemplate(String templateName) async {}

  void _createNewTemplate() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => CreateProgramScreen(user: widget.user)),
    );
  }

  @override
  void initState() {
    super.initState();
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
