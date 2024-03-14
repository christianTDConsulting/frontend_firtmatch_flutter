import 'package:fit_match/models/ejercicios.dart';
import 'package:fit_match/models/registros.dart';
import 'package:fit_match/models/sesion_entrenamiento.dart';
import 'package:fit_match/models/user.dart';
import 'package:flutter/material.dart';

class EstadisticasRegistroScreen extends StatefulWidget {
  final User user;
  final SesionEntrenamiento session;

  const EstadisticasRegistroScreen(
      {Key? key, required this.user, required this.session})
      : super(key: key);

  @override
  State<EstadisticasRegistroScreen> createState() =>
      _EstadisticasRegistroScreen();
}

class _EstadisticasRegistroScreen extends State<EstadisticasRegistroScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<RegistroDeSesion> registros = [];
  late int selectedEjercicioId;
  bool isLoading = false;

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    selectedEjercicioId = getFirstNonNulldetailedExerciseId(
        widget.session.ejerciciosDetalladosAgrupados)!;
    loadRegistros();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int? getFirstNonNulldetailedExerciseId(
      List<EjerciciosDetalladosAgrupados>? agrupados) {
    if (agrupados == null) return null;

    for (var grupo in agrupados) {
      for (var ejercicioDetallado in grupo.ejerciciosDetallados) {
        if (ejercicioDetallado.detailedExerciseId != null) {
          return ejercicioDetallado.detailedExerciseId;
        }
      }
    }
    return null;
  }

  void loadRegistros() async {
    setState(() {
      isLoading = true;
    });

    setState(() {
      isLoading = false;
    });
  }

  void onEjercicioChanged(int? newValue) {
    loadRegistros();

    setState(() {
      selectedEjercicioId = newValue!;
    });
  }

  //SCREEN

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> dropdownItems = [];
    if (widget.session.ejerciciosDetalladosAgrupados != null) {
      for (var group in widget.session.ejerciciosDetalladosAgrupados!) {
        for (var exercise in group.ejerciciosDetallados) {
          dropdownItems.add(
            DropdownMenuItem(
              value: exercise.detailedExerciseId,
              child: Text(
                  exercise.ejercicio != null
                      ? exercise.ejercicio!.name
                      : "Ejercicio no especificado",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
          );
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.session.sessionName,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // DropdownButton aquí
              DropdownButton<int>(
                value:
                    selectedEjercicioId, // Asegúrate de definir y manejar esta variable
                onChanged: (int? newValue) {
                  onEjercicioChanged(newValue);
                },
                items: dropdownItems,
              ),
              // TabBar aquí
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Gráfico'),
                  Tab(text: 'Lista'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildGraphView(context),
          buildListView(context),
        ],
      ),
    );
  }

  Widget buildGraphView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(),
      ),
    );
  }

  Widget buildListView(BuildContext context) {
    return ListView.builder(
      itemCount: registros.length,
      itemBuilder: (context, index) {
        // Configura la visualización de tus items de la lista aquí.
        return const ListTile(
          title: Text('...'),
          subtitle: Text('...'),
        );
      },
    );
  }
}
