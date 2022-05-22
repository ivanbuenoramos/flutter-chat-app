import 'package:chat_app/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {

  final String texto;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    Key? key,
    required this.texto,
    required this.uid,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: (uid == authService.usuario!.uid)
          ? _myMessage()
          : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 4, left: 70, right: 5),
        child: Text(texto, style: const TextStyle(color: Colors.white)),
        decoration: const BoxDecoration(
          color: Color(0xff4D9EF6),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            topLeft: Radius.circular(15),
            topRight: Radius.circular(2),
            bottomRight: Radius.circular(15),),
        ),
      )
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 4, left: 5, right: 70),
        child: Text(texto, style: const TextStyle(color: Colors.black87)),
        decoration: const BoxDecoration(
          color:Color(0xffE4E5E8),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            topLeft: Radius.circular(15),
            topRight: Radius.circular(2),
            bottomRight: Radius.circular(15),),
        ),
      )
    );
  }
}