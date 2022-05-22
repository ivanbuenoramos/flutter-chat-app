import 'package:chat_app/models/usuarios_response.dart';
import 'package:http/http.dart' as http;

import '../global/enviorments.dart';

import '../services/auth_services.dart';
import '../models/usuario.dart';

class UsuariosService {

  Future<List<Usuario>> getUsuarios() async {

    String? token = await AuthService.getToken();

    try {
      final resp = 
      await http.get(Uri.parse('${Environment.apiUrl}/usuarios'),
        headers: {
          'Content-Type': 'aplication/json',
          'x-token': token.toString()
        }
      );

      final usuariosResponse = usuariosResponseFromJson(resp.body);

      return usuariosResponse.usuarios;
      
    } catch (e) {
      return [];
    }
  }

}