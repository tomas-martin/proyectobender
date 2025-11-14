import 'package:flutter/material.dart';

class TarjetaPropiedad extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final IconData icono;
  final Color color;

  const TarjetaPropiedad({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icono, color: color),
        ),
        title: Text(titulo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(descripcion, style: const TextStyle(color: Colors.white70)),
        trailing: ElevatedButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Función Premium - Próximamente'))),
          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.black),
          child: const Text('Activar'),
        ),
      ),
    );
  }
}