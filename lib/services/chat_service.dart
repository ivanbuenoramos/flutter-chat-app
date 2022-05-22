
import 'package:chat_app/global/enviorments.dart';
import 'package:chat_app/models/mensajes_response.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/models/usuario.dart';
import 'package:flutter/material.dart';
import 'auth_services.dart';

class ChatService with ChangeNotifier {

  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioID) async{
    final uri = Uri.parse('${Environment.apiUrl}/mensajes/$usuarioID');
    final resp = await http.get(uri, 
    headers: {
      'Content-Type': 'aplication/json',
      'x-token': await AuthService.getToken()
    });

    final mensajesResp = menasjesResponseFromJson(resp.body);
    return mensajesResp.mensajes;
  }

}