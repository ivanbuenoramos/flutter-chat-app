import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/usuario.dart';
import '../services/services.dart';

class UsuariosScreen extends StatefulWidget {   
  UsuariosScreen({Key? key}) : super(key: key);

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {

  final usuariosService = new UsuariosService();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];


  // final usuarios = [
  //   Usuario(uid: '1', nombre: 'María', email: 'test1@test.com', online: true),
  //   Usuario(uid: '2', nombre: 'Melissa', email: 'test2@test.com', online: false),
  //   Usuario(uid: '3', nombre: 'Fernando', email: 'test3@test.com', online: true),
  // ];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authServices = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authServices.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chats', style: const TextStyle(color: Colors.black87, fontSize: 18)),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app, color: Colors.black87),
          onPressed: () {
            socketService.disconnect();
            //socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online) 
              ? Icon(Icons.check_circle, color: Colors.blue[400])
              : const Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue,
        ),
        child: _listViewUsuarios(),
      ),
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
      separatorBuilder: (_, i) => const Divider(),
      itemCount: usuarios.length,
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre, style: TextStyle(fontSize: 16)),
      subtitle: Text(usuario.email, style: TextStyle(fontSize: 14)),
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Text(usuario.nombre.substring(0, 2)),
          ),
          if (usuario.online)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green[400],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);

        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, "chat");
      },
    );
  }

  _cargarUsuarios() async {
    
    usuarios = await usuariosService.getUsuarios();
    setState(() {});
    // await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}