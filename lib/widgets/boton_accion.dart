import 'package:flutter/material.dart';

class BotonAccion extends StatelessWidget {
  final IconData icono;
  final String texto;
  final Color color;
  final VoidCallback onTap;

  const BotonAccion({super.key, required this.icono, required this.texto, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icono, color: color, size: 30),
            const SizedBox(height: 8),
            Flexible(child: Text(texto, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 13), textAlign: TextAlign.center)),
          ]),
        ),
      ),
    );
  }
}
