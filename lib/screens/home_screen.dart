import 'package:flutter/material.dart';
import 'package:puntos_ventas_tt/screens/screens.dart';

class HomeScreen extends StatelessWidget {
  static String routePage = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackButton(),
          _HomeBody(),
        ],
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        AyudaPventaScreen(),
      ],
    );
  }
}
