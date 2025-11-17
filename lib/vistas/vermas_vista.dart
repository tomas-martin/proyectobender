import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vista_modelos/navigation_viewmodel.dart';
import 'propietarios_vista.dart';

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
          // Propietarios
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.people, color: Colors.purple),
              ),
              title: const Text('Propietarios', style: TextStyle(color: Colors.white, fontSize: 16)),
              subtitle: const Text('Gestionar dueños de propiedades', style: TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PropietariosVista()),
                );
              },
            ),
          ),

          // Recordatorios
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.alarm, color: Colors.amberAccent),
              ),
              title: const Text('Recordatorios', style: TextStyle(color: Colors.white, fontSize: 16)),
              subtitle: const Text('Configurar avisos automáticos', style: TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Próximamente disponible')),
                );
              },
            ),
          ),

          // Exportar finanzas
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.file_download, color: Colors.lightBlueAccent),
              ),
              title: const Text('Exportar finanzas', style: TextStyle(color: Colors.white, fontSize: 16)),
              subtitle: const Text('Generar reportes en PDF o Excel', style: TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Próximamente disponible')),
                );
              },
            ),
          ),

          // Configuración avanzada
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.settings, color: Colors.greenAccent),
              ),
              title: const Text('Configuración avanzada', style: TextStyle(color: Colors.white, fontSize: 16)),
              subtitle: const Text('Personalizar la aplicación', style: TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Próximamente disponible')),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Información de la app
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              children: const [
                Icon(Icons.android, color: Colors.amber, size: 48),
                SizedBox(height: 12),
                Text(
                  'Inmobiliaria Bender',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Versión 1.0.0',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                SizedBox(height: 8),
                Text(
                  'Gestión completa de propiedades e inquilinos',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}