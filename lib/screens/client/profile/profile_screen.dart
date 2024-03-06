import 'dart:typed_data';

import 'package:fit_match/models/user.dart';
import 'package:fit_match/providers/get_jwt_token.dart';
import 'package:fit_match/providers/theme_provider.dart';
import 'package:fit_match/screens/shared/login_screen.dart';
import 'package:fit_match/utils/dimensions.dart';
import 'package:fit_match/widget/edit_Icon.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ViewProfileScreen extends StatefulWidget {
  final User user;

  const ViewProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreen();
}

class _ViewProfileScreen extends State<ViewProfileScreen> {
  final coverHeight = 200.0;
  final mobileprofileHeight = 250;
  final webProfileHeight = 400;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Uint8List im = await image.readAsBytes();
      setState(() {});
    }
  }

  _logOut(BuildContext context) async {
    removeToken();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          buildTop(),
          buildUsername(),
          buildOpciones(),
        ],
      ),
    );
  }

  Widget buildOpciones() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1000),
      padding: const EdgeInsets.symmetric(horizontal: 48),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildOptionItem(
            icon: Icons.person_outline_outlined,
            onTap: () {},
            title: 'Información personal',
          ),
          const Divider(), // Divider entre elementos
          _buildOptionItem(
            icon: Icons.settings,
            onTap: () {},
            title: 'Configuraciones',
            isExpandable: true,
            contentExpanded: buildConfiguraciones(),
          ),
          const Divider(), // Divider entre elementos
          _buildOptionItem(
            icon: Icons.security,
            onTap: () {},
            title: 'Seguridad',
            isExpandable: true,
            contentExpanded: buildSeguridad(),
          ),
          const Divider(), // Divider entre elementos
          _buildOptionItem(
            icon: Icons.logout,
            onTap: () {
              _logOut(context);
            },
            title: "Cerrar sesión",
            iconColor: Theme.of(context).colorScheme.secondary,
            arrow: false,
          ),
        ],
      ),
    );
  }

  Widget buildUsername() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        alignment: Alignment.center,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.user.username,
              style: Theme.of(context).textTheme.headlineSmall),
        ]));
  }

  Widget buildTop() {
    final double width = MediaQuery.of(context).size.width;
    final profileHeight =
        width < webScreenSize ? mobileprofileHeight : webProfileHeight;
    final bottom = profileHeight / 6;
    final top = coverHeight - profileHeight / 3;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCover(),
        ),
        Positioned(top: top, child: buildProfileImage()),
      ],
    );
  }

  Widget buildCover() {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      width: double.infinity,
      height: coverHeight,
    );
  }

  Widget buildProfileImage() {
    final double width = MediaQuery.of(context).size.width;
    final profileHeight =
        width < webScreenSize ? mobileprofileHeight : webProfileHeight;
    final double circleSize = profileHeight / 2;

    final double imageSize = circleSize * 0.9;
    return Stack(
      children: [
        Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        Positioned(
          left: (circleSize - imageSize) / 2,
          top: (circleSize - imageSize) / 2,
          child: Stack(
            children: [
              CircleAvatar(
                radius: imageSize / 2,
                backgroundImage: NetworkImage(widget.user.profile_picture),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              Positioned(
                top: 0,
                child: (EditIcon(
                  color: Theme.of(context).colorScheme.primary,
                  onTap: _selectImage,
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget buildConfiguraciones() {
  //   /*
  //   Hay dos  apartados:
  //   El primer es un apartado contiene un titulito que pone "Tema"  una columna que consiste en  un switch button con logos que representen modo oscuro y
  //   claro para cambiar el tema de la app.
  //   El segundo apartado tendrá un titulito que pone "Preferencia de unidades de medidas" y
  //   unos radio buttons que permiten al usuario cambiar la unidad de medida entre sistema imperial y métrico
  //   */
  // }
  Widget buildConfiguraciones() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primer apartado: Tema
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'Tema',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: Colors.yellow),
              const SizedBox(width: 8),
              const Text('Modo Claro'),
              const SizedBox(width: 8),
              Switch(
                value: themeProvider.currentTheme == ThemeEnum.Dark,
                onChanged: (value) {
                  themeProvider
                      .changeTheme(value ? ThemeEnum.Dark : ThemeEnum.Light);
                },
              ),
              const SizedBox(width: 8),
              const Icon(Icons.nightlight_round, color: Colors.blue),
              const SizedBox(width: 8),
              const Text('Modo Oscuro'),
            ],
          ),
          const Divider(),
          // Segundo apartado: Preferencia de unidades de medidas
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              'Preferencia de unidades de medidas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: const Text('Sistema Imperial'),
            leading: Radio(
              value: 'imperial',
              groupValue:
                  'imperial', // Deberías manejar el grupo de radio adecuadamente
              onChanged: (value) {
                // Aquí deberías manejar el cambio de la unidad de medida
              },
            ),
          ),
          ListTile(
            title: const Text('Sistema Métrico'),
            leading: Radio(
              value: 'metric',
              groupValue:
                  'imperial', // Deberías manejar el grupo de radio adecuadamente
              onChanged: (value) {
                // Aquí deberías manejar el cambio de la unidad de medida
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSeguridad() {
    return Container();
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color? iconColor,
    bool arrow = true,
    bool isExpandable = false,
    Widget? contentExpanded,
  }) {
    final iconArrow = arrow ? const Icon(Icons.arrow_forward_ios) : null;
    final textStyle = TextStyle(
        fontSize: 14, color: Theme.of(context).colorScheme.onBackground);
    const contentPadding = EdgeInsets.symmetric(vertical: 0, horizontal: 16);

    if (isExpandable) {
      return Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(icon,
              color: iconColor ?? Theme.of(context).colorScheme.onBackground),
          title: Text(title, style: textStyle),
          trailing: iconArrow,
          tilePadding: contentPadding,
          children: contentExpanded != null
              ? [
                  Padding(
                    padding: const EdgeInsets.only(left: 72),
                    child: contentExpanded,
                  )
                ]
              : [],
        ),
      );
    } else {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(icon,
                  color:
                      iconColor ?? Theme.of(context).colorScheme.onBackground),
              const SizedBox(width: 8),
              Text(title),
              const Spacer(),
              if (arrow) iconArrow!,
            ],
          ),
        ),
      );
    }
  }

  // Widget _buildOptionItem({
  //   required IconData icon,
  //   required String title,
  //   VoidCallback? onTap,
  //   Color? iconColor,
  //   bool arrow = true,
  //   bool isExpandable = false,
  //   Widget? contentExpanded,
  // }) {
  //   if (isExpandable) {
  //     return ExpansionTile(
  //       leading: Icon(icon, color: iconColor),
  //       title: Text(title),
  //       children: contentExpanded != null ? [contentExpanded] : [],
  //     );
  //   } else {
  //     return MouseRegion(
  //       cursor: SystemMouseCursors.click,
  //       child: GestureDetector(
  //         onTap: onTap,
  //         child: Row(
  //           children: [
  //             Icon(icon, color: iconColor),
  //             const SizedBox(width: 8), // Espacio entre el ícono y el texto
  //             Text(title),

  //             const Spacer(), // Espacio para que la flecha se alinee a la derecha
  //             if (arrow == true) const Icon(Icons.arrow_forward_ios), // Flecha
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  // }
}
