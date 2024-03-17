import 'package:fit_match/models/ejercicios.dart';
import 'package:fit_match/models/registros.dart';
import 'package:fit_match/models/sesion_entrenamiento.dart';
import 'package:fit_match/models/user.dart';
import 'package:fit_match/services/registro_service.dart';
import 'package:fit_match/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  List<RegistroSet> registros = [];
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

  Future<void> loadRegistros() async {
    setState(() {
      isLoading = true;
    });

    try {
      registros = await RegistroMethods()
          .getAllRegistersByUserIdAndDetailedExerciseId(
              widget.user.user_id as int, selectedEjercicioId);
    } catch (e) {
      print(e);
    }

    setState(() {
      registros = registros;
      isLoading = false;
    });
  }

  Future<void> onEjercicioChanged(int? newValue) async {
    setState(() {
      selectedEjercicioId = newValue!;
    });
    await loadRegistros();
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
                    color: Theme.of(context).colorScheme.onPrimary,
                  )),
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
          preferredSize: const Size.fromHeight(kToolbarHeight + 100),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // DropdownButton aquí
              DropdownButton<int>(
                iconEnabledColor: Theme.of(context).colorScheme.onPrimary,
                value:
                    selectedEjercicioId, // Asegúrate de definir y manejar esta variable
                dropdownColor: Theme.of(context).colorScheme.primary,
                focusColor: Theme.of(context).colorScheme.primary,
                onChanged: (int? newValue) {
                  onEjercicioChanged(newValue);
                },
                items: dropdownItems,
              ),
              // TabBar aquí
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: 'Gráfico',
                    icon: Icon(Icons.bar_chart),
                  ),
                  Tab(text: 'Lista', icon: Icon(Icons.list)),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : buildGraphView(context),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : buildListView(context),
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
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: buildTitleListView(
                  _getRegisterTypeOfActiveDetailedExercise()),
            ),
          ),
          Expanded(
            // Hace que la lista ocupe el espacio restante
            child: ListView.builder(
              itemCount: registros.length,
              itemBuilder: (context, index) {
                final registro = registros[index];

                // Determina los widgets a incluir basado en el tipo de registro
                List<Widget> rowContent = [
                  Expanded(
                    flex: 2,
                    child: Text(
                      DateFormat.yMMMMd('es_ES').format(registro.timestamp),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ];

                switch (_getRegisterTypeOfActiveDetailedExercise()) {
                  case 4: // AMRAP
                    rowContent.add(const Expanded(
                      child: Text("AMRAP",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ));
                    break;
                  case 5: // Tiempo
                    rowContent.add(Expanded(
                      child: Text("${registro.time} min",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ));
                    break;
                  case 6: // Rango de tiempo
                    rowContent.addAll([
                      Expanded(
                        child: Text("${registro.time} min",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text(
                            "${_getWeight(registro.weight!)} ${_getSystemUnit()}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ]);
                    break;
                  default: // Otro tipo
                    rowContent.addAll([
                      Expanded(
                        child: Text("${registro.reps} reps",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text(
                            "${_getWeight(registro.weight!)} ${_getSystemUnit()}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ]);
                }

                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: rowContent,
                  ),
                  subtitle: const Divider(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getRegisterTypeOfActiveDetailedExercise() {
    for (var group in widget.session.ejerciciosDetalladosAgrupados!) {
      for (var exercise in group.ejerciciosDetallados) {
        if (exercise.detailedExerciseId == selectedEjercicioId) {
          return exercise.registerTypeId;
        }
      }
    }
    return 0;
  }

  List<Widget> _getTitlesBasedInRegisterType(int registerTypeId) {
    switch (registerTypeId) {
      case 4: // AMRAP
        return [
          const Expanded(
            child: Text(
              "AMRAP",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ];
      case 5: // Tiempo
        return [
          const Expanded(
            child: Text(
              "Tiempo",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ];
      case 6: // Rango de tiempo
        return [
          const Expanded(
            child: Text(
              "Tiempo",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              "Peso",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ];
      default: // Para los demás casos
        return [
          const Expanded(
            child: Text(
              "Repeticiones",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              "Peso",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ];
    }
  }

  List<Widget> buildTitleListView(int registerTypeId) {
    // Obtener los widgets basados en el tipo de registro
    List<Widget> titles = _getTitlesBasedInRegisterType(registerTypeId);

    // Comenzamos con el widget de 'Fecha'
    List<Widget> listViewTitles = [
      const Expanded(
        child: Text(
          'Fecha',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];

    // Añadir los widgets obtenidos a la lista
    listViewTitles.addAll(titles);

    return listViewTitles;
  }

  _getWeight(double weight) {
    if (widget.user.system == 'imperial') {
      return fromKgToLbs(weight);
    } else if (widget.user.system == 'metrico') {
      return weight;
    }
  }

  _getSystemUnit() {
    if (widget.user.system == 'imperial') {
      return 'lbs';
    } else if (widget.user.system == 'metrico') {
      return 'kg';
    }
  }
}
