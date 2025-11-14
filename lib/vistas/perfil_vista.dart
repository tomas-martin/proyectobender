import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vista_modelos/navigation_viewmodel.dart';

class PerfilVista extends StatelessWidget {
  const PerfilVista({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen de perfil
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/bender.png',
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, __) => const CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.grey,
                      child: Text(
                        'B',
                        style: TextStyle(fontSize: 48, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Nombre
              Text(
                'Bender Bending Rodríguez',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),

              // Info secundaria
              Text(
                'Robot Serial #2716057',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),

              // Tarjeta informativa
              Card(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: const [
                      ListTile(
                        leading: Icon(Icons.email, color: Colors.amberAccent),
                        title: Text('bender@planetaexpreso.com',
                            style: TextStyle(color: Colors.white)),
                      ),
                      Divider(color: Colors.white12),
                      ListTile(
                        leading: Icon(Icons.location_on, color: Colors.lightBlueAccent),
                        title: Text('Ciudad Nueva, Marte',
                            style: TextStyle(color: Colors.white)),
                      ),
                      Divider(color: Colors.white12),
                      ListTile(
                        leading: Icon(Icons.star, color: Colors.greenAccent),
                        title: Text('Cuenta Premium Activa',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}