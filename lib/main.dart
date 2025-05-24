// ignore_for_file: prefer_const_constructors

import 'package:chat/providers/auth_service.dart';
import 'package:chat/screens/auth_screen.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'utils/color_scheme_person.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  final token = await messaging.getToken();
  print('FCM Token: $token');

  //print('User granted permission: ${settings.authorizationStatus}');
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyChatApp(),
    ),
  );
}

class MyChatApp extends StatelessWidget {
  const MyChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorSchemePers,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorSchemePers.primary,
            foregroundColor: Colors.white,
          ),
        ),
        useMaterial3: true,
      ),
      home: Consumer<AuthService>(
        builder: (ctx, authService, _) {
          final user = authService.currentUser;
          if (user != null) {
            return ChatScreen(user: user);
          } else {
            return AuthScreen();
          }
        },
      ),
    );
  }
}
