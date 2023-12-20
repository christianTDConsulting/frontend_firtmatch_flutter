import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final Widget child;
  final VoidCallback onClose;

  CustomDialog({required this.child, required this.onClose});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    double dialogWidth =
        width > 600 ? 600 : width * 0.9; // Ajustar ancho máximo

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Container(
            width: dialogWidth,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Hace que el dialogo sea del tamaño de su contenido
              children: [
                child,
              ],
            ),
          ),
          Positioned(
            top:
                -15.0, // Ajustar posición para alinear con la esquina del diálogo
            right: -15.0,
            child: CircleAvatar(
              backgroundColor: Colors.red, // Color de fondo del botón cerrar
              radius: 15,
              child: IconButton(
                icon: Icon(Icons.close,
                    size: 20.0, color: Colors.white), // Icono blanco
                onPressed: onClose,
                padding:
                    EdgeInsets.zero, // Remover padding extra para alinear icono
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void show(BuildContext context, Widget child, VoidCallback onClose) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(onClose: onClose, child: child);
      },
    );
  }
}
