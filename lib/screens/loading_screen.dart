import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/usuarios_screen.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
   
  const LoadingScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Text('Cargando...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authServices = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final autenticado = await authServices.isLoggedIn();

    if (autenticado) {

      socketService.connect();

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:  (_, __, ___) => UsuariosScreen(),
          transitionDuration: const Duration(milliseconds: 0),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:  (_, __, ___) => LoginScreen(),
          transitionDuration: const Duration(milliseconds: 0),
        ),
      );
    }
  }
}