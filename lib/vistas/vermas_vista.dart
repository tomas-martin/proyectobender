import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vista_modelos/navigation_viewmodel.dart';

class VerMasVista extends StatelessWidget {
  const VerMasVista({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Ver más'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: const ListTile(
              leading: Icon(Icons.alarm, color: Colors.amberAccent),
              title: Text('Recordatorios', style: TextStyle(color: Colors.white, fontSize: 16)),
              subtitle: Text('Configurar avisos automáticos', style: TextStyle(color: Colors.white70)),
            ),
          ),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: const ListTile(
              leading: Icon(Icons.file_download, color: Colors.lightBlueAccent),
              title: Text('Exportar finanzas', style: TextStyle(color: Colors.white, fontSize: 16)),
              subtitle: Text('Generar reportes en formato PDF o Excel', style: TextStyle(color: Colors.white70)),
            ),
          ),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: const ListTile(
              leading: Icon(Icons.settings, color: Colors.greenAccent),
              title: Text('Configuración avanzada', style: TextStyle(color: Colors.white, fontSize: 16)),
              subtitle: Text('Personalizá la experiencia de tu aplicación', style: TextStyle(color: Colors.white70)),
            ),
          ),
        ],
      ),
    );
  }
}