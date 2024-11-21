import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simula um tempo de carregamento antes de ir para a próxima tela
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacementNamed('/welcome'); // Rota para a tela principal
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF1A1A1A), // Cor de fundo semelhante ao design
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/images/logo.png', // Caminho da logo
              width: 100,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
