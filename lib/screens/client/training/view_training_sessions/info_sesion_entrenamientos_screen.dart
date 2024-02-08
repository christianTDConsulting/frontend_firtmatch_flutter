import 'package:fit_match/models/ejercicios.dart';
import 'package:fit_match/models/sesion_entrenamiento.dart';
import 'package:fit_match/models/user.dart';
import 'package:fit_match/screens/client/training/view_training_sessions/exercise/exercise_selection_screen.dart';
import 'package:fit_match/services/sesion_entrenamientos_service.dart';
import 'package:fit_match/utils/utils.dart';
import 'package:fit_match/widget/custom_button.dart';
import 'package:flutter/material.dart';

class InfoSesionEntrenamientoScreen extends StatefulWidget {
  final int templateId;
  final User user;
  final int sessionId;

  const InfoSesionEntrenamientoScreen({
    super.key,
    required this.sessionId,
    required this.templateId,
    required this.user,
  });
  @override
  _InfoSesionEntrenamientoScreen createState() =>
      _InfoSesionEntrenamientoScreen();
}

class _InfoSesionEntrenamientoScreen
    extends State<InfoSesionEntrenamientoScreen> {
  SesionEntrenamiento editingSesion = SesionEntrenamiento(
    sessionId: 0,
    templateId: 0,
    sessionName: '',
    sessionDate: DateTime.now(),
  );

  List<EjerciciosDetalladosAgrupados> _exercises = [];
  bool isLoading = true;
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
    initData();
  }

  void _setLoadingState(bool loading) {
    setState(() => isLoading = loading);
  }

  Future<void> initData() async {
    try {
      _setLoadingState(true);
      SesionEntrenamiento editingSesion = await SesionEntrenamientoMethods()
          .getSesionesEntrenamientoBySessionId(widget.sessionId);
      setState(() {
        this.editingSesion = editingSesion;
      });

      _tituloContoller.text = editingSesion.sessionName;
      _instruccionesContoller.text = editingSesion.notes ?? '';
    } catch (e) {
      print(e);
    } finally {
      _setLoadingState(false);
    }
  }

  void _addExercise() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExecriseSelectionScreen(user: widget.user),
      ),
    );
  }

  void _saveEntrenamiento() async {
    if (_formKey.currentState!.validate()) {
      try {
        SesionEntrenamiento sesion = SesionEntrenamiento(
          sessionId: editingSesion.sessionId,
          templateId: editingSesion.templateId,
          sessionName: _tituloContoller.text,
          notes: _instruccionesContoller.text,
          sessionDate: editingSesion.sessionDate,
        );

        int response =
            await SesionEntrenamientoMethods().editSesionEntrenamiento(sesion);

        if (response == 200) {
          showToast(
              context, 'Sesión de Entrenamiento actualizada correctamente');
          _navigateBack(context);
        }
      } catch (e) {
        showToast(context, e.toString(), exitoso: false);
      }
    }
  }

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
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
    if (_exercises.isEmpty) {
      return const Text(
        'No hay ejercicios todavía',
        style: TextStyle(fontSize: 18),
      );
    }
    return ListView.builder(
      itemCount: _exercises.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_exercises[index].ejerciciosDetallados.toString()),
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
