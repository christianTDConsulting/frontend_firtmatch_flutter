// Importa los paquetes y archivos necesarios
import 'package:fit_match/utils/colors.dart';
import 'package:fit_match/widget/text_field_input.dart';
import 'package:flutter/material.dart';

// Define la pantalla de inicio de sesión como un widget de estado mutable
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pswController = TextEditingController();

  //Liberación de recursos
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _pswController.dispose();
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
                height: 12,
              ),
              // Muestra el logo
              Image.asset(
                'assets/images/logo.png', // Ruta al archivo SVG
                color: primaryColor, // Color del logo
                height: 64, // Altura del logo
              ),
              const SizedBox(
                height: 64, // Agrega un espacio vertical de 64 píxeles
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
                child: const Text('Iniciar sesión'),
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
                      '¿No tienes cuenta?',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(' Registrate aquí',
                          style: TextStyle(
                              color: blueColor, fontWeight: FontWeight.bold)),
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
