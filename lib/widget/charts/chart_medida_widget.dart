import 'dart:math';

import 'package:fit_match/models/medidas.dart';
import 'package:fit_match/utils/dimensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LineChartMedidaSample extends StatefulWidget {
  final List<StatMedida> statMedidas;
  final String unit;

  const LineChartMedidaSample({
    super.key,
    required this.statMedidas,
    required this.unit,
  });

  @override
  State<LineChartMedidaSample> createState() => LineChartState();
}

class LineChartState extends State<LineChartMedidaSample> {
  List<Color> gradientColors = [
    const Color(0xFF50E4FF),
    const Color(0xFF2196F3),
  ];

  late double originalMinX;
  late double originalMaxX;
  late double originalMinY;
  late double originalMaxY;

  late List<FlSpot> spots;
  late String system;

  List<FlSpot> getSpotsFromStatsMedida(List<StatMedida> medidas) {
    return medidas.asMap().entries.map((entry) {
      double value = entry.value.value;
      double date = entry.value.date.millisecondsSinceEpoch.toDouble();

      return FlSpot(date, value);
    }).toList();
  }

  @override
  void initState() {
    print(widget.statMedidas);
    super.initState();
    _initSpots();
  }

  _initSpots() {
    List<FlSpot> spotsSinNormalizar =
        getSpotsFromStatsMedida(widget.statMedidas);
//deberían estar ordenados pero por si acaso
    spotsSinNormalizar.sort((a, b) => a.x.compareTo(b.x));

// Un pequeño valor para incrementar los puntos con el mismo valor de x.
    double increment = 0.001;
//Para que no tengan los mismos valores de x
    for (int i = 1; i < spotsSinNormalizar.length; i++) {
      if (spotsSinNormalizar[i].x == spotsSinNormalizar[i - 1].x) {
        // Encuentra el próximo valor único de x incrementando ligeramente.
        double nextUniqueX = spotsSinNormalizar[i].x + increment;
        // Asegúrate de que este nuevo valor también sea único.
        while (spotsSinNormalizar.any((spot) => spot.x == nextUniqueX)) {
          nextUniqueX += increment;
        }
        // Asigna el nuevo valor único a x.
        spotsSinNormalizar[i] = FlSpot(nextUniqueX, spotsSinNormalizar[i].y);
      }
    }

// Ahora puedes proceder con la normalización y otros pasos como antes.

    originalMinX = spotsSinNormalizar.isNotEmpty
        ? spotsSinNormalizar.map((spot) => spot.x).reduce(min)
        : 0.0;
    originalMaxX = spotsSinNormalizar.isNotEmpty
        ? spotsSinNormalizar.map((spot) => spot.x).reduce(max)
        : 0.0;

    originalMinY = spotsSinNormalizar.isNotEmpty
        ? spotsSinNormalizar.map((spot) => spot.y).reduce(min)
        : 0.0;
    originalMaxY = spotsSinNormalizar.isNotEmpty
        ? spotsSinNormalizar.map((spot) => spot.y).reduce(max)
        : 0.0;

    spots = spotsSinNormalizar.map((spot) {
      double x = normalizeTimestamp(spot.x, originalMinX, originalMaxX, 0, 10);
      double y = spot.y;
      return FlSpot(x, y);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double aspectRatio = width > webScreenSize ? 1.70 : 0.75;
    final int totalLabels = spots.length;
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          mainData(aspectRatio, totalLabels),
        ),
      ),
    );
  }

  double normalizeTimestamp(double value, double minOriginal,
      double maxOriginal, double minNew, double maxNew) {
    if (maxOriginal == minOriginal) {
      return minNew;
    }
    return (value - minOriginal) /
            (maxOriginal - minOriginal) *
            (maxNew - minNew) +
        minNew;
  }

  double desnormalizeValue(double normalizedValue, double originalMin,
      double originalMax, double newMin, double newMax) {
    // Verifica si el rango original es de un solo punto
    if (originalMin == originalMax) {
      // Devuelve el valor único, ya que no hay un rango para mapear
      return originalMin;
    }

    // Procede con la desnormalización si hay un rango válido
    return originalMin +
        ((normalizedValue - newMin) *
            (originalMax - originalMin) /
            (newMax - newMin));
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Theme.of(context).colorScheme.onBackground,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    // Desnormaliza el valor para convertirlo de vuelta a un timestamp
    double desnormalizedValue =
        desnormalizeValue(value, originalMinX, originalMaxX, 0, 10);

    // Convierte el valor desnormalizado de timestamp a fecha

    var date = DateTime.fromMillisecondsSinceEpoch(desnormalizedValue.toInt());
    var formattedDate = DateFormat("MMM d").format(date);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(formattedDate, style: style),
    );
  }

  Widget leftTitleWidgets(
    double value,
    TitleMeta meta,
  ) {
    // return const SizedBox.shrink();
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    return Text('${value.toInt()} ${widget.unit}', style: style);
  }

  double calculateBottomInterval() {
    final double totalRange = originalMaxX - originalMinX;

    const double minVisibleInterval = 86400000; // 1 día en milisegundos.

    // Calcula el número de intervalos visibles basado en el ancho del gráfico y un ancho estimado por etiqueta.
    // Ajusta el 'labelWidth' según el tamaño medio de tus etiquetas para evitar el solapamiento.
    double width = MediaQuery.of(context).size.width -
        40; // Ajusta según el padding/margen de tu gráfico.
    const double labelWidth = 60; // Estimación del ancho por etiqueta.
    int numLabels = (width / labelWidth).floor();

    // Asegúrate de no dividir por cero.
    if (numLabels == 0) {
      return totalRange; // Solo muestra una etiqueta si no hay suficiente espacio.
    }

    // Calcula el intervalo de tiempo (en milisegundos) entre etiquetas para evitar el solapamiento.
    double interval = totalRange / numLabels;

    // Asegura que el intervalo no sea menor que el mínimo establecido.
    interval = max(interval, minVisibleInterval);

    // Convierte el intervalo de milisegundos a la unidad que estés usando en el eje X.
    // Si estás normalizando las fechas a otro rango (por ejemplo, 0 a 10), necesitarás convertir este intervalo.
    // De lo contrario, si estás usando milisegundos directamente, puedes devolver este valor.
    return normalizeTimestamp(interval, originalMinX, originalMaxX, 0, 10) -
        normalizeTimestamp(0, originalMinX, originalMaxX, 0, 10);
  }

  LineChartData mainData(double aspectRatio, int totalLabels) {
    const double marginFactor = 0.00; // El margen es el 5% del rango total

    double minX =
        spots.isNotEmpty ? spots.map((spot) => spot.x).reduce(min) : 0.0;
    double maxX =
        spots.isNotEmpty ? spots.map((spot) => spot.x).reduce(max) : 0.0;
    double rangeX = maxX - minX; // El rango total en el eje X
    minX -= rangeX * marginFactor; // Resta el margen al mínimo
    maxX += rangeX * marginFactor; // Añade el margen al máximo

    double minY =
        spots.isNotEmpty ? spots.map((spot) => spot.y).reduce(min) : 0.0;
    double maxY =
        spots.isNotEmpty ? spots.map((spot) => spot.y).reduce(max) : 0.0;
    double rangeY = maxY - minY; // El rango total en el eje Y
    minY -= rangeY * marginFactor; // Resta el margen al mínimo
    maxY += rangeY * marginFactor; // Añade el margen al máximo
    double visibleRange =
        originalMaxX - originalMinX; // Actualiza esto según el zoom

    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueAccent,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final dataIndex = spots.indexWhere(
                  (spot) => spot.x == barSpot.x && spot.y == barSpot.y);
              if (dataIndex != -1) {
                String text = spots[dataIndex].y.toString() + " ${widget.unit}";
                return LineTooltipItem(
                  text,
                  TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                );
              }
              return null;
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: calculateBottomInterval(),
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
