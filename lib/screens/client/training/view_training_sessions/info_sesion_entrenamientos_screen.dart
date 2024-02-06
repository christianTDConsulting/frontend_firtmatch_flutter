import 'package:fit_match/models/ejercicios.dart';
import 'package:fit_match/models/sesion_entrenamiento.dart';
import 'package:fit_match/models/user.dart';
import 'package:fit_match/screens/client/training/view_training_sessions/exercise/exercise_selection_screen.dart';
import 'package:fit_match/widget/custom_button.dart';
import 'package:flutter/material.dart';

class InfoSesionEntrenamientoScreen extends StatefulWidget {
  final int templateId;
  final User user;
  final SesionEntrenamiento? editingSesion;

  const InfoSesionEntrenamientoScreen({
    super.key,
    this.editingSesion,
    required this.templateId,
    required this.user,
  });
  @override
  _InfoSesionEntrenamientoScreen createState() =>
      _InfoSesionEntrenamientoScreen();
}

class _InfoSesionEntrenamientoScreen
    extends State<InfoSesionEntrenamientoScreen> {
  List<EjercicioDetallados> ejercicios = [];

  final TextEditingController _tituloContoller = TextEditingController();
  final TextEditingController _instruccionesContoller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _tituloContoller.dispose();
    _instruccionesContoller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void initSesionEntrenamients() async {
    if (_formKey.currentState?.validate() == true) {}
  }

  void _addExercise() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExecriseSelectionScreen(user: widget.user),
      ),
    );
  }

  void _saveEntrenamiento() {}

  void _navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sesión de Entrenamiento'),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              _navigateBack(context);
            },
          ),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTitle(context),
                    const SizedBox(height: 16),
                    _buildInstructions(context),
                    const SizedBox(height: 16),
                    _buildEntrenamientosList(context),
                    const SizedBox(height: 16),
                    _buildNewExerciseButton(context),
                    const SizedBox(height: 16),
                    _buildSaveButton(context),
                  ]),
            )));
  }

  Widget _buildEntrenamientosList(BuildContext context) {
    if (ejercicios.isEmpty) {
      return const Text(
        'No hay ejercicios todavía',
        style: TextStyle(fontSize: 18),
      );
    }
    return ListView.builder(
      itemCount: ejercicios.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(ejercicios[index].exerciseId.toString()),
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    return TextFormField(
      controller: _tituloContoller,
      decoration: const InputDecoration(
        labelText: 'Nombre de la sesión de entrenamiento',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, escribe el nombre de tu sesión de entrenamiento';
        }
        return null;
      },
    );
  }

  Widget _buildInstructions(BuildContext context) {
    return TextFormField(
      controller: _instruccionesContoller,
      decoration: const InputDecoration(
        labelText: 'Instrucciones de la sesión de entrenamiento',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildNewExerciseButton(BuildContext context) {
    return CustomButton(onTap: _addExercise, text: 'Añadir Ejercicio');
  }

  Widget _buildSaveButton(BuildContext context) {
    return CustomButton(
        onTap: _saveEntrenamiento, text: 'Guardar sesión de entrenamiento');
  }
}
