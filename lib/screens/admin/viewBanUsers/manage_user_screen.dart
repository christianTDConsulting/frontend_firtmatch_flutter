import 'package:fit_match/models/user.dart';
import 'package:fit_match/services/auth_service.dart';
import 'package:fit_match/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class ManageUserScreen extends StatefulWidget {
  final User user;
  const ManageUserScreen({super.key, required this.user});
  @override
  State<StatefulWidget> createState() {
    return ManageUserScreenState();
  }
}

class ManageUserScreenState extends State<ManageUserScreen> {
  List<User> usuarios = [];

  @override
  void initState() {
    super.initState();
    initUsers();
  }

  @override
  Widget build(BuildContext context) {
    Widget listaUsers = ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: usuarios.length,
        separatorBuilder: (context, index) =>
            Divider(color: Theme.of(context).colorScheme.onBackground),
        itemBuilder: (context, index) {
          var usuario = usuarios[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: usuario.profile_picture != null
                  ? NetworkImage(usuario.profile_picture!)
                  : null,
              child: usuario.profile_picture == null
                  ? Icon(Icons.account_circle, size: 40)
                  : null,
            ),
            title: Text(usuario.username),
            subtitle: Text(usuario.email),
            trailing: IconButton(
              icon: Icon(
                usuario.banned ? Icons.remove_circle : Icons.block,
                color: usuario.banned ? Colors.green : Colors.red,
              ),
              onPressed: () {
                setState(() {
                  usuario.banned = !usuario.banned;
                });
                banUnbanUser(
                    widget.user.user_id as int, usuario.user_id as int);
              },
            ),
          );
        });

    Widget usersBody() {
      if (kIsWeb) {
        // Si es web, retorna solo la lista
        return listaUsers;
      } else {
        // Si no es web, usa LiquidPullToRefresh
        return LiquidPullToRefresh(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: () async {
            await initUsers();
          },
          child: listaUsers,
        );
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Gestionar usuarios"),
        ),
        body: usuarios.isEmpty
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
                      "No hay Usuarios",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            : usersBody());
  }

  Future<void> initUsers() async {
    try {
      UserMethods()
          .getAllUsers(widget.user.user_id as int)
          .then((value) => setState(() => usuarios = value));
    } catch (e) {
      print(e);
    }
  }

  Future<void> banUnbanUser(int userId, int banUserId) async {
    try {
      UserMethods().banUser(userId, banUserId);
    } catch (e) {
      print(e);
    }
  }
}
