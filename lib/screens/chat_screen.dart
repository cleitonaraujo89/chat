// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'dart:async';

import 'package:chat/widgets/messages.dart';
import 'package:chat/widgets/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/auth_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});

  final User user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _loading = true;

  late final StreamSubscription<RemoteMessage> _onMessageSub;
  late final StreamSubscription<RemoteMessage> _onMessageOpenedAppSub;

  @override
  void initState() {
    super.initState();
    _loadScreen();

    // 1) Mensagens recebidas com o app em primeiro plano
    _onMessageSub = FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      final notif = msg.notification;
      if (notif != null) {
        print('🔔 onMessage: ${notif.title} / ${notif.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(notif.body ?? 'Nova notificação'),
            duration: Duration(seconds: 8),
          ),
        );
      }
    });

    // 2) Mensagens que abrem o app (quando o usuário clica na notificação)
    _onMessageOpenedAppSub =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      print('onMessageOpenedApp: ${msg.data}');
      // navegue para a tela desejada com base em msg.data
    });

    // 3) Verifica se o app foi aberto a partir de uma notificação enquanto estava encerrado
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? msg) {
      if (msg != null) {
        print('🚀 getInitialMessage: ${msg.data}');
        // trate o deep link aqui
      }
    });
  }

  Future<void> _loadScreen() async {
    //inicia um cronometro
    final stopwatch = Stopwatch()..start();
    // await Future.delayed(const Duration(milliseconds: 8000));

    // Exemplo: Pré-carregar as últimas 50 mensagens para o cache de imagens,
    // como você tinha na SplashScreen.
    // Isso é o que a animação de 8 segundos deveria estar "esperando".

    try {
      final query = await FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      final docs = query.docs;

      for (final doc in docs) {
        final imageUrl = doc['userImage'] as String?;
        if (imageUrl != null && imageUrl.isNotEmpty) {
          // essa chamada vai baixar e armazenar em cache
          await precacheImage(NetworkImage(imageUrl), context);
        }
      }
    } catch (e) {
      print('Erro ao pré-carregar dados do chat: $e');
    } finally {
      final elapsed = stopwatch.elapsed;
      if (elapsed < const Duration(seconds: 2)) {
        // Mínimo de 2 segundos
        await Future.delayed(const Duration(seconds: 2) - elapsed);
      }
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _onMessageSub.cancel();
    _onMessageOpenedAppSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Flutter Chat'),
        actions: [
          if (!_loading)
            DropdownButtonHideUnderline(
              child: DropdownButton(
                iconDisabledColor: Colors.white,
                iconEnabledColor: Colors.white,
                icon: Icon(Icons.more_vert),
                items: [
                  DropdownMenuItem(
                    value: 'logout',
                    child: Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.black,
                          ),
                          SizedBox(width: 12),
                          Text('Sair'),
                        ],
                      ),
                    ),
                  )
                ],
                onChanged: (item) async {
                  if (item == 'logout') {
                    await Provider.of<AuthService>(context, listen: false)
                        .signOut();
                  }
                },
              ),
            )
        ],
      ),
      body: Stack(children: [
        SafeArea(
          child: Column(
            children: [
              Expanded(child: Messages(user: widget.user)),
              NewMessage(user: widget.user),
            ],
          ),
        ),
        _loading
            ? Container(
                color: theme.primaryColor,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Lottie.asset('assets/images/animacao_chat.json'),
                      Positioned(
                        top: screenHeight * 0.3,
                        child: SizedBox(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.5,
                          child: Lottie.asset(
                              'assets/images/animacao_loading2.json'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(),
      ]),
    );
  }
}
