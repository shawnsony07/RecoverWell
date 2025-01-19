import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/screens/splash.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/start.dart';
import 'package:chat_app/screens/home.dart';
import 'package:chat_app/screens/auth.dart';
import 'package:chat_app/widgets/message_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _showStartScreen = true;

  void _hideStartScreen() {
    setState(() {
      _showStartScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MessageProvider()),
      ],
      child: MaterialApp(
        title: 'RecoverWell+',
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 127, 233, 219)),
        ),
        home: _showStartScreen
            ? StartScreen(onGetStarted: _hideStartScreen)
            : StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, snapshot) {
                  // Show splash screen while checking auth state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SplashScreen();
                  }

                  // If user is authenticated, show HomeScreen instead of ChatScreen
                  if (snapshot.hasData) {
                    return const HomeScreen();
                  }

                  // If not authenticated, show AuthScreen
                  return const AuthScreen();
                }),
      ),
    );
  }
}
