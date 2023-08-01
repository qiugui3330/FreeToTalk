import 'package:chatgpt_course/providers/models_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/authentication_service.dart';
import 'constants/constants.dart';
import 'providers/chats_provider.dart';
import 'auth/login_page.dart';
import 'screens/chat_screen.dart';
import 'database/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthenticationService _authService = AuthenticationService();
  late Future<User?> _loggedInUserFuture;

  @override
  void initState() {
    super.initState();
    _loggedInUserFuture = _authService.getLoggedInUser();
  }

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
          create: (_) => _authService,
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
        home: FutureBuilder<User?>(
          future: _loggedInUserFuture,
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data != null) {
                return ChatScreen(user: snapshot.data!);
              } else {
                return LoginPage();
              }
            } else {
              return Center(child: CircularProgressIndicator()); // Loading spinner
            }
          },
        ),
      ),
    );
  }
}
