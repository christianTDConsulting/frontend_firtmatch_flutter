// Importa los paquetes y archivos necesarios
import 'package:fit_match/utils/colors.dart';
import 'package:fit_match/widget/date_picker.dart';
import 'package:fit_match/widget/text_field_input.dart';
import 'package:flutter/material.dart';

// Define la pantalla de inicio de sesión como un widget de estado mutable
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pswController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  //Liberación de recursos
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _pswController.dispose();
    _usernameController.dispose();
    _dobController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define la estructura básica del widget
    return Scaffold(
      body: SafeArea(
        child: Container(
          // Agrega un relleno horizontal al contenedor
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double
              .infinity, // Ancho del contenedor igual al ancho de la pantalla
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              const Text(
                'Bienvenido a Fit-Match',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(
                height: 24,
              ),

              Image.asset(
                'assets/images/logo.png', // Ruta al archivo SVG
                color: primaryColor, // Color del logo
                height: 64, // Altura del logo
              ),
              const SizedBox(
                height: 24,
              ),

              const Text(
                'Para empezar a usar Fit-Match, rellena los siguientes datos ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(
                height: 24,
              ),

              const SizedBox(
                height: 32, // Agrega un espacio vertical de 64 píxeles
              ),
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Escribe tu correo',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  textEditingController: _pswController,
                  hintText: 'Escribe tu contraseña',
                  textInputType: TextInputType.text,
                  isPsw: true),

              const SizedBox(
                height: 24,
              ),
              // DatePicker(dateController: _dobController),

              const SizedBox(
                height: 24,
              ),
              // Botón de inicio de sesión
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  color: blueColor,
                ),
                child: const Text('Registrarse'),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              //ir al registro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      '¿Ya tienes cuenta?',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
