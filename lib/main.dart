import 'package:chatgpt_course/providers/auth_provider.dart';
import 'package:chatgpt_course/providers/conversation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/authentication_service.dart';
import 'constants/theme_constants.dart';
import 'providers/messages_provider.dart';
import '/screens/auth/login_screen.dart';
import 'screens/chat_screen.dart';
import 'database/models/user_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ConversationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MessageProvider(
            Provider.of<ConversationProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
          child: MyApp(),
        ),
        Provider(
          create: (_) => AuthenticationService(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final AuthenticationService _authService = AuthenticationService();
  late Future<User?> _loggedInUserFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _loggedInUserFuture = _authService.getLoggedInUser();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final conversationProvider = Provider.of<ConversationProvider>(context, listen: false);
    final chatProvider = Provider.of<MessageProvider>(context, listen: false);

    switch (state) {
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        conversationProvider.clearCurrentConversation();
        chatProvider.clearChat();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FreeToTalk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: whiteColor,
          appBarTheme: AppBarTheme(
            color: lightGreyColor,
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
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
