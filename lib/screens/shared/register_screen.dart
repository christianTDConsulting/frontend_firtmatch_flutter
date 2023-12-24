import 'dart:typed_data';

import 'package:fit_match/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fit_match/utils/colors.dart';
import 'package:fit_match/utils/dimensions.dart';
import 'package:fit_match/utils/utils.dart';
import 'package:fit_match/widget/date_picker.dart';
import 'package:fit_match/widget/text_field_input.dart';
import 'package:fit_match/screens/shared/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _pswController = TextEditingController();
  final _usernameController = TextEditingController();
  final _dobController = TextEditingController();
  final _otpController = TextEditingController();

  final _emailAuth = EmailAuth(sessionName: "Fit-Match");
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  Uint8List? _image;
  int _currentStep = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _pswController.dispose();
    _usernameController.dispose();
    _dobController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    bool result = await _emailAuth.sendOtp(
        recipientMail: _emailController.text, otpLength: 4);
    print(result ? "OTP sent successfully" : "Failed to send OTP");
  }

  Future<void> _verifyOTP() async {
    setState(() => _isLoading = true);
    bool result = await _emailAuth.validateOtp(
        recipientMail: _emailController.text, userOtp: _otpController.text);
    if (result) {
      // Si la verificación es exitosa, avanza al siguiente paso
      if (_currentStep < 2) {
        setState(() {
          _currentStep += 1;
        });
      }
    } else {
      // Mostrar mensaje de error si la verificación falla
      showToast(context, 'Verificación OTP fallida');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _signUpUser() async {
    setState(() => _isLoading = true);

    // Implement signup logic here

    setState(() => _isLoading = false);
  }

  Future<void> _selectImage() async {
    Uint8List? im = await pickImage(ImageSource.gallery);
    if (im != null) {
      setState(() => _image = im);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Redirigir al login al presionar el botón de retroceso
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: _buildLoginOption(context)),
        body: SafeArea(
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: blueColor, // Definir el color del Stepper
            ),
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepContinue: () async {
                if (_currentStep == 0) {
                  // Lógica para el primer paso: verificar campos y enviar OTP
                  if (_emailController.text.isNotEmpty &&
                      _pswController.text.isNotEmpty &&
                      _usernameController.text.isNotEmpty &&
                      _dobController.text.isNotEmpty) {
                    await _sendOTP();
                    setState(() {
                      _currentStep += 1;
                    });
                  } else {
                    showToast(context, 'Por favor, completa todos los campos');
                  }
                } else if (_currentStep < 2) {
                  // Avanzar al siguiente paso
                  setState(() {
                    _currentStep += 1;
                  });
                }
              },
              onStepCancel: _currentStep > 0
                  ? () => setState(() => _currentStep -= 1)
                  : null,
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: details.onStepContinue,
                      child: const Text('Continuar',
                          style: TextStyle(color: blueColor)),
                    ),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Atrás',
                          style: TextStyle(color: blueColor)),
                    ),
                  ],
                );
              },
              steps: _buildSteps(),
            ),
          ),
        ),
      ),
    );
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('Datos'),
        content: _buildUserDataStep(),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Verificación'),
        content: _buildVerificationStep(),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Sobre tí'),
        content: _buildPreferencesStep(),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
    ];
  }

  Widget _buildUserDataStep() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildImageSelector(),
          const SizedBox(height: 24),
          _buildEmailTextField(),
          const SizedBox(height: 24),
          _buildPasswordTextField(),
          const SizedBox(height: 24),
          _buildUsernameTextField(),
          const SizedBox(height: 24),
          DatepickerWidget(controller: _dobController),
        ],
      ),
    );
  }

  Widget _buildVerificationStep() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Introduce el código OTP',
              border: OutlineInputBorder(),
            ),
            maxLength: 4, // Limita la longitud a 4
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Acepta solo dígitos
            ],
          ),
        ),
        CustomButton(
          onTap: () {
            if (_otpController.text.length == 4) {
              _verifyOTP();
            } else {
              showToast(context, 'Por favor, introduce un código OTP válido');
            }
          },
          text: 'Verificar OTP',
        ),
      ],
    );
  }

  Widget _buildPreferencesStep() {
    // Aquí puedes colocar el widget para las preferencias del usuario
    return const Text('Pantalla de Preferencias');
  }

  /* EdgeInsets _getHorizontalPadding(BuildContext context) =>
      MediaQuery.of(context).size.width > webScreenSize
          ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 3)
          : const EdgeInsets.symmetric(horizontal: 32);
*/

  Widget _buildTitle() => const Text(
        'Bienvenido a Fit-Match',
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
      );

  Widget _buildLogo() => Image.asset(
        'assets/images/logo.png',
        color: primaryColor,
        height: 32,
      );

  Widget _buildDescription() => const Text(
        'Para empezar a usar Fit-Match, rellena los siguientes datos ',
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor),
      );

  Widget _buildImageSelector() => Stack(
        children: [
          CircleAvatar(
            radius: 64,
            backgroundImage: _image != null
                ? MemoryImage(_image!)
                : Image.asset('assets/images/user_placeholder.png').image,
            backgroundColor: Colors.red,
          ),
          Positioned(
            left: 80,
            child: IconButton(
                onPressed: _selectImage, icon: const Icon(Icons.add_a_photo)),
          ),
        ],
      );

  Widget _buildEmailTextField() => TextFieldInput(
        textEditingController: _emailController,
        hintText: 'Escribe tu correo',
        textInputType: TextInputType.emailAddress,
        validator: (value) => value == null || value.isEmpty
            ? 'Por favor, ingresa tu correo'
            : null,
      );

  Widget _buildPasswordTextField() => TextFieldInput(
        textEditingController: _pswController,
        hintText: 'Escribe tu contraseña',
        textInputType: TextInputType.text,
        isPsw: true,
        validator: (value) => value == null || value.isEmpty
            ? 'Por favor, ingresa tu contraseña'
            : null,
      );

  Widget _buildUsernameTextField() => TextFieldInput(
        textEditingController: _usernameController,
        hintText: 'Escribe tu nombre de usuario',
        textInputType: TextInputType.text,
        validator: (value) => value == null || value.isEmpty
            ? 'Por favor, ingresa tu nombre de usuario'
            : null,
      );

  Widget _buildRegisterButton() => InkWell(
        onTap: _sendOTP,
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            color: blueColor,
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: primaryColor)
              : const Text('Registrarse'),
        ),
      );

  Widget _buildLoginOption(BuildContext context) => Wrap(
        spacing: 25,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('¿Ya tienes cuenta?'),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginScreen())),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(' Iniciar sesión',
                  style:
                      TextStyle(color: blueColor, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      );
}
