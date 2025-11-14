import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vista_modelos/navigation_viewmodel.dart';

class ErroresVista extends StatelessWidget {
  const ErroresVista({super.key});

  static const List<String> errores = [
    'Error 404: Archivo de renta no encontrado',
    'Error 500: Servidor de Bender sobrecalentado',
    'Error 403: Acceso denegado, falta propina',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Errores'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: errores.length,
        itemBuilder: (context, i) => Card(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading:
            const Icon(Icons.error_outline, color: Colors.redAccent),
            title: Text(
              errores[i],
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
