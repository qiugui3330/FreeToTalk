import 'package:chatgpt_course/providers/models_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/authentication_service.dart';
import 'constants/constants.dart';
import 'providers/chats_provider.dart';
import 'screens/chat_screen.dart';
import 'auth/login_page.dart'; // 确保你的路径是正确的

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
        Provider(
          create: (_) => AuthenticationService(),
        ),
      ],
      child: MaterialApp(
        title: 'FreeToTalk',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: scaffoldBackgroundColor,
            appBarTheme: AppBarTheme(
              color: cardColor,
            )),
        home: LoginPage(),
      ),
    );
  }
}

