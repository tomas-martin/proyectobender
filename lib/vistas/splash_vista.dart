import 'dart:async';
import 'package:flutter/material.dart';

class SplashVista extends StatefulWidget {
  const SplashVista({super.key});

  @override
  State<SplashVista> createState() => _SplashVistaState();
}

class _SplashVistaState extends State<SplashVista> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();

    // después de 1.6s vamos al home
    Timer(const Duration(milliseconds: 1600), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: ScaleTransition(
          scale: _anim,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // si tenés asset, se muestra; sino se muestra un avatar con B
              Image.asset(
                'assets/images/bender.png',
                width: 140,
                height: 140,
                errorBuilder: (context, _, __) {
                  return CircleAvatar(radius: 70, backgroundColor: color, child: const Text('B', style: TextStyle(fontSize: 64, color: Colors.black)));
                },
              ),
              const SizedBox(height: 12),
              const Text('Inmobiliaria Bender', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Transformá tus propiedades... o robalas (con estilo)', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
