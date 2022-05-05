import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat_app/widgets/widgets.dart';
import 'package:chat_app/services/auth_services.dart';
import '../helpers/mostrar_alerta.dart';


class LoginScreen extends StatelessWidget {
   
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: const [
                Logo(text: 'Messenger'),
                _Form(),
                Labels(ruta: 'register', textButtonLabel: '¿No tienes cuenta?', textButton: 'Crear una ahora'),
                Text('Terminos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200)),
              ]
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authServices = Provider.of<AuthService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [

          CustomInput(
            icon: Icons.mail_outlined,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),

          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            isPassword: true,
            textController: passCtrl,
          ),

          BotonAzul(
            text: 'Ingresar', 
            onPressed: authServices.autenticando ? null : ()  async {

              FocusScope.of(context).unfocus();

              final loginOk = await authServices.login(emailCtrl.text.trim(), passCtrl.text.trim());

              if (loginOk) {

                Navigator.pushReplacementNamed(context, 'usuarios');

              } else {
                mostrarAlerta(context, 'Login incorrecto', 'Revise sus credenciales nuevamente');
              }
            },
          ),
        ],
      ),
    );
  }
}