import 'package:flutter/material.dart';

class AvisosVista extends StatelessWidget {
  const AvisosVista({super.key});

  static const List<String> avisos = [
    'Recordatorio: cobrar rentas mañana',
    'Aviso: inspección mensual',
    'Bender está de mal humor, cobrar YA',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Avisos'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false, // 👈 NO MÁS BOTÓN ATRÁS
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: avisos.length,
        itemBuilder: (context, i) => Card(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.notification_important,
                color: Colors.amberAccent),
            title: Text(
              avisos[i],
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
