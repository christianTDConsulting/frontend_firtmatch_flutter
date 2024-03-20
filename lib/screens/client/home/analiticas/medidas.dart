import 'package:fit_match/models/medidas.dart';
import 'package:fit_match/models/user.dart';
import 'package:fit_match/screens/client/home/analiticas/nuevasMedidas.dart';
import 'package:fit_match/services/medidas_service.dart';
import 'package:flutter/material.dart';

class MedidasScreen extends StatefulWidget {
  final User user;

  const MedidasScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<MedidasScreen> createState() => _MedidasScreen();
}

class _MedidasScreen extends State<MedidasScreen> {
  bool isLoading = true;
  List<Medidas> medidas = [];

  @override
  @override
  void initState() {
    _initMedidas();
    super.initState();
  }

  void _initMedidas() async {
    List<Medidas> medidas =
        await MedidasMethods().getAllMedidas(widget.user.user_id as int);
    setState(() {
      this.medidas = medidas;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Medidas guardadas",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: buildViewMedidas(context),
    );
  }

  Widget buttonAdd(String label, VoidCallback onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.primary,
          ),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          constraints: const BoxConstraints(maxWidth: 600),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildViewMedidas(BuildContext context) {
    if (medidas.isEmpty && !isLoading) {
      return SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              buttonAdd("Añadir nuevas medidas", () => _addMedida(context),
                  Icons.add),
              const SizedBox(height: 20),
              buttonAdd("Ver estadísticas", () {}, Icons.bar_chart),
              const SizedBox(height: 20),
              const Text(
                'No hay datos Todavía',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    } else {
      return Column(
        children: [
          buttonAdd(
              "Añadir nuevas medidas", () => _addMedida(context), Icons.add),
          Expanded(
            // Wrap the ListView in an Expanded widget
            child: ListView.builder(
              itemCount: medidas.length,
              itemBuilder: (context, index) {
                return cardMedida(context, medidas[index]);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget cardMedida(BuildContext context, Medidas medida) {
    return Container();
  }

  _addMedida(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NuevaMedidaScreen(user: widget.user),
      ),
    );
  }
}
