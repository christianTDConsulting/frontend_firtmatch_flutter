import 'package:fit_match/models/user.dart';
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

class _MedidasScreen extends State<MedidasScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  bool isLoading = true;

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Medidas guardadas",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        bottom:
            // TabBar aquí
            TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Mediciones realizadas',
              icon: Icon(Icons.list),
            ),
            Tab(text: 'Estadísticas', icon: Icon(Icons.bar_chart)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(child: buildViewMedidas(context)),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : buildGraphView(context),
        ],
      ),
    );
  }

  Widget buildViewMedidas(BuildContext context) {
    return Container();
  }

  Widget buildGraphView(BuildContext context) {
    return Container();
  }
}
