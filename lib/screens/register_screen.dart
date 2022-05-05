import 'package:chat_app/helpers/mostrar_alerta.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat_app/widgets/widgets.dart';
import 'package:chat_app/services/auth_services.dart';

class RegisterScreen extends StatelessWidget {
   
  const RegisterScreen({Key? key}) : super(key: key);
  
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
                Logo(text: 'Registro'),
                _Form(),
                Labels(ruta: 'login', textButtonLabel: '¿Ya tienes cuenta?', textButton: 'Iniciar sesión'),
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

  final nameCtrl = TextEditingController();
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
            icon: Icons.person,
            placeholder: 'Nombre de usuario',
            textController: nameCtrl,
          ),

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

              final registerOk = await authServices.register(emailCtrl.text.trim(), passCtrl.text.trim(), nameCtrl.text.trim());

              if (registerOk == true) {
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                mostrarAlerta(context, 'Registro incorrecto', registerOk);
              }
            },
          ),
        ],
      ),
    );
  }
}