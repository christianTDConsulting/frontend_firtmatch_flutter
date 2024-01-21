import 'package:fit_match/models/post.dart';
import 'package:fit_match/models/user.dart';
import 'package:fit_match/screens/client/training/info_plantilla_screen.dart';
import 'package:fit_match/services/plantilla_posts_service.dart';
import 'package:fit_match/utils/colors.dart';

import 'package:flutter/material.dart';

class ViewTrainingScreen extends StatefulWidget {
  final User user;
  const ViewTrainingScreen({super.key, required this.user});

  @override
  _ViewTrainingScreen createState() => _ViewTrainingScreen();
}

class _ViewTrainingScreen extends State<ViewTrainingScreen> {
  List<PlantillaPost> trainingTemplates = [];
  List<PlantillaPost> createdTrainingTemplates = [];
  List<PlantillaPost> arhivedTrainingTemplates = [];
  bool isLoading = false;
  int _currentPage = 0;

  Future<void> loadTrainingTemplates() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      var resultados = await Future.wait([
        RutinaGuardadaMethods().getPlantillas(widget.user.user_id),
        PlantillaPostsMethods().getAllPosts(userId: widget.user.user_id),
        RutinasArchivadaMethods().getPlantillas(widget.user.user_id),
      ]);

      var newTemplates = resultados[0];
      var newCreatedTemplates = resultados[1];
      var newArchivedTemplates = resultados[2];

      if (mounted) {
        setState(() {
          trainingTemplates = newTemplates;
          createdTrainingTemplates = newCreatedTemplates;
          arhivedTrainingTemplates = newArchivedTemplates;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al cargar plantillas: $e');
    }
  }

  void _editTemplate(PlantillaPost template) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => CreateProgramScreen(
              user: widget.user, editingTemplate: template)),
    );
  }

  void _archivarTemplate(String templateName) {
    // Lógica para archivar la plantilla
    print('Archivar $templateName');
  }

  void _quitar_de_archivado(String templateName) {
    // Lógica para quitar de archivado la plantilla
    print('Quitar de archivado $templateName');
  }

  void _eliminar_de_archivados(String templateName) {}

  void _deleteTemplate(String templateName) async {}

  void _verMas() {}
  void _createNewTemplate() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => CreateProgramScreen(user: widget.user)),
    );
  }

  @override
  void initState() {
    super.initState();
    loadTrainingTemplates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Plantillas de entrenamiento'),
      ),
      floatingActionButton: _currentPage == 1
          ? FloatingActionButton(
              onPressed: _createNewTemplate,
              backgroundColor: blueColor,
              child: const Icon(Icons.add),
            )
          : null,
      body: SafeArea(
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSwatch(
              cardColor: blueColor,
              backgroundColor: primaryColor,
            ),
          ),
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentPage,
            onStepTapped: (int step) => setState(() => _currentPage = step),
            onStepContinue: () {
              setState(() {
                if (_currentPage < 1) {
                  _currentPage++;
                }
              });
            },
            onStepCancel: () {
              setState(() {
                if (_currentPage > 0) {
                  _currentPage--;
                }
              });
            },
            steps: _buildSteps(),
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Row(children: <Widget>[
                if (_currentPage != 0)
                  TextButton(
                    onPressed: () => setState(() => _currentPage = 0),
                    child: const Text('Ir a Programas Activos',
                        style: TextStyle(color: blueColor)),
                  ),
                if (_currentPage != 1)
                  TextButton(
                    onPressed: () => setState(() => _currentPage = 1),
                    child: const Text('Ir a Programas Creados',
                        style: TextStyle(color: blueColor)),
                  ),
                if (_currentPage != 2) // Botón para el tercer paso
                  TextButton(
                    onPressed: () => setState(() => _currentPage = 2),
                    child: const Text('Ir a Programas Archivados',
                        style: TextStyle(color: blueColor)),
                  ),
              ]);
            },
          ),
        ),
      ),
    );
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text("Activos",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor)),
        content: _buildProgramList(context, "Activos"),
        isActive: _currentPage == 0,
      ),
      Step(
        title: const Text("Creados",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor)),
        content: _buildProgramList(context, "Creados"),
        isActive: _currentPage == 1,
      ),
      Step(
        title: const Text("Archivados",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor)),
        content: _buildProgramList(context, "Archivados"),
        isActive: _currentPage == 2,
      ),
    ];
  }

  Widget _buildProgramList(BuildContext context, String tipo) {
    List<PlantillaPost> lista = [];
    switch (tipo) {
      case "Activos":
        lista = trainingTemplates;
        break;
      case "Creados":
        lista = createdTrainingTemplates;
        break;
      case "Archivados":
        lista = arhivedTrainingTemplates;
        break;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text(tipo,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor)),
          ),
          ...lista.map((template) => _buildListItem(template, tipo)).toList(),
        ],
      ),
    );
  }

  Widget _buildListItem(PlantillaPost template, String tipo) {
    return GestureDetector(
      onTap: () {
        if (tipo == "Creados" || tipo == "Archivados") {
          _verMas();
        }
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(template.templateName,
              style: const TextStyle(color: primaryColor)),
          trailing: PopupMenuButton<String>(
            iconColor: primaryColor,
            color: mobileSearchColor,
            onSelected: (value) => _handleMenuItemSelected(value, template),
            itemBuilder: (BuildContext context) => _buildPopupMenuItems(tipo),
          ),
        ),
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildPopupMenuItems(String tipo) {
    switch (tipo) {
      case "Activos":
        return [
          const PopupMenuItem<String>(
              value: 'archivar',
              child: Text('Archivar', style: TextStyle(color: primaryColor))),
          const PopupMenuItem<String>(
              value: 'mas',
              child: Text('Ver más', style: TextStyle(color: primaryColor))),
          const PopupMenuItem<String>(
              value: 'delete_guardados',
              child: Text('Eliminar', style: TextStyle(color: primaryColor))),
        ];
      case "Creados":
        return [
          const PopupMenuItem<String>(
              value: 'edit',
              child: Text('Editar', style: TextStyle(color: primaryColor))),
          const PopupMenuItem<String>(
              value: 'delete_creados',
              child: Text('Eliminar', style: TextStyle(color: primaryColor))),
        ];
      case "Archivados":
        return [
          const PopupMenuItem<String>(
              value: 'mas',
              child: Text('Ver más', style: TextStyle(color: primaryColor))),
          const PopupMenuItem<String>(
              value: 'delete_archivados',
              child: Text('Eliminar', style: TextStyle(color: primaryColor))),
        ];
    }
    return [];
  }

  void _handleMenuItemSelected(String value, PlantillaPost template) {
    switch (value) {
      case 'archivar':
        _archivarTemplate(template.templateName);
        break;
      case 'mas':
        // Acción para 'Ver más'
        break;
      case 'edit':
        _editTemplate(template);
        break;
      case 'delete':
        _deleteTemplate(template.templateName);
        break;
      // Agregar más casos según sea necesario...
    }
  }
}
