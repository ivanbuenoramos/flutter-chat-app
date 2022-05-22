// ignore_for_file: unnecessary_new

import 'dart:io';

import 'package:chat_app/models/mensajes_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import '../services/services.dart';
import '../widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
   
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  List<ChatMessage> _message = [];

  final List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(chatService.usuarioPara.uid);

  }
    
  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await chatService.getChat(usuarioID);

    final history = chat.map((m) => new ChatMessage(
      texto: m.mensaje,
      uid: m.de,
      animationController: new AnimationController(vsync: this, duration: Duration(milliseconds: 0))..forward(),
    ));
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    
    ChatMessage message = new ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300)),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        
        elevation: 0.5,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            CircleAvatar(
              child: Text(usuarioPara.nombre.substring(0, 2), style: const TextStyle(fontSize: 14)),
              backgroundColor: Colors.blue[100],
              radius: 20,
            ),

            const SizedBox(width: 10),

            (usuarioPara.online)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(usuarioPara.nombre, style: const TextStyle(color: Colors.black87, fontSize: 17)),
                    const Text( 'En línea', style: TextStyle(color: Colors.black38, fontSize: 13)),
                  ],
                )
              : Text(usuarioPara.nombre, style: const TextStyle(color: Colors.black87, fontSize: 17)),
          ],
        ),
        leading: (Platform.isIOS)
          ? CupertinoButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.chevron_left, color: Colors.blue)
              )

          : IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(Icons.chevron_left, color: Colors.blue),
        ),
      ),
      body: Column(
        children: [

          Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: true,
            )
          ),

          const Divider(
            height: 1,
          ),

          Container(
            color: Colors.white,
            child: _inputChat(),
          )
        ],
      )
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [

            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (texto) {
                  setState(() {
                    if (texto.trim().length > 0) {
                      _estaEscribiendo = true;
                    } else {
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode,
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
              ? CupertinoButton(
                  child: const Text('Enviar'),
                  onPressed: _estaEscribiendo
                    ? () => _handleSubmit(_textController.text.trim())
                    : null,
                )
              : Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: IconTheme(
                  data: IconThemeData(color:Colors.blue[400]),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: _estaEscribiendo
                    ? () => _handleSubmit(_textController.text.trim())
                    : null,
                    icon: const Icon(Icons.send)
                  ),
                ),
              )
            )

          ],
        ),
      )
    );
  }

  _handleSubmit(String texto) {

    if (texto.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();  

    final newMessage = new ChatMessage(
      uid: authService.usuario!.uid,
      texto: texto,
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);

    newMessage.animationController.forward();

    setState(() { _estaEscribiendo = false; });

    socketService.emit('mensaje-personal', {
      'de': authService.usuario?.uid,
      'para': chatService.usuarioPara.uid,
      'mensaje': texto,
    });

  }

  @override
  void dispose() {
    
    for(ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}