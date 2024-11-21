import 'package:flutter/material.dart';
import 'package:house_app/models/despesa.dart';
import 'package:house_app/models/receita.dart';
import 'package:house_app/models/transferencia.dart';
import 'package:house_app/screens/ReportScreen.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/TransactionScreen.dart';
import 'screens/ProfileScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Hive
  await Hive.initFlutter();

  // Registro de adaptadores (iremos criar mais tarde)
  Hive.registerAdapter(ReceitaAdapter());
  Hive.registerAdapter(DespesaAdapter());
  Hive.registerAdapter(TransferenciaAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'House App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/transaction': (context) => const TransactionScreen(),
        '/reports': (context) => const ReportScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
