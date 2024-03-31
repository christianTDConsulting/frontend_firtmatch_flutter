import 'package:fit_match/models/notificaciones.dart';
import 'package:fit_match/models/user.dart';
import 'package:fit_match/services/notificaciones.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  final User user;
  const NotificationScreen({super.key, required this.user});
  @override
  State<StatefulWidget> createState() {
    return NotificationScreenState();
  }
}

class NotificationScreenState extends State<NotificationScreen> {
  List<Notificacion> notificaciones = [];

  @override
  void initState() {
    super.initState();
    initNotificaciones();
    marcarNotificacionesComoLeidas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificaciones"),
      ),
      body: notificaciones.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 60,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "No hay notificaciones",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: notificaciones.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Theme.of(context).colorScheme.onBackground),
              itemBuilder: (context, index) {
                var notificacion = notificaciones[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(
                      notificacion.read ? Icons.mail_outline : Icons.mail,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  title: Text(
                    notificacion.mensaje,
                    style: TextStyle(
                      fontWeight: notificacion.read
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy HH:mm')
                        .format(notificacion.timestamp),
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
    );
  }

  Future<void> marcarNotificacionesComoLeidas() async {
    await NotificacionesMethods().readNotificationes(widget.user.user_id);
  }

  Future<void> initNotificaciones() async {
    try {
      List<Notificacion> notific =
          await NotificacionesMethods().getNotificationes(widget.user.user_id);
      setState(() {
        notificaciones = notific;
      });
    } catch (e) {
      print(e);
    }
  }
}
