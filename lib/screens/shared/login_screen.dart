// Importa los paquetes y archivos necesarios
import 'package:fit_match/screens/shared/register_screen.dart';
import 'package:fit_match/screens/client/view_trainers_screen.dart';
import 'package:fit_match/services/auth_service.dart';
import 'package:fit_match/utils/colors.dart';
import 'package:fit_match/widget/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define la pantalla de inicio de sesión como un widget de estado mutable
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pswController = TextEditingController();
  bool _isLoading = false;
  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    initSharedPreference();
  }

  void initSharedPreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  //Liberación de recursos
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _pswController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _pswController.text,
    );
    if (res == "succes") {
      var my_token = AuthMethods().token;
      preferences.setString('token', my_token);
      /* Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ViewTrainers(token: my_token),
      ));*/
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define la estructura básica del widget
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                textInputType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu correo electrónico';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                textEditingController: _pswController,
                hintText: 'Escribe tu contraseña',
                textInputType: TextInputType.text,
                isPsw: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu nombre de usuario';
                  }
                  return null;
                },
              ),

              const SizedBox(
                height: 24,
              ),
              // Botón de inicio de sesión
              InkWell(
                onTap: loginUser,
                child: Container(
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
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    )),
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
