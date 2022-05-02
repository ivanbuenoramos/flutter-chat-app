import 'package:flutter/material.dart';

import 'package:chat_app/screens/screns.dart';


final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios'  : (_) => UsuariosScreen(),
  'chat'      : (_) => ChatScreen(),
  'loading'   : (_) => LoadingScreen(),
  'login'    : (_) => LoginScreen(),
  'register'  : (_) => RegisterScreen(),
};