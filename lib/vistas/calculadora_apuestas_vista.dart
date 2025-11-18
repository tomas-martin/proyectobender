import 'package:flutter/material.dart';

class CalculadoraApuestasVista extends StatefulWidget {
  const CalculadoraApuestasVista({super.key});

  @override
  State<CalculadoraApuestasVista> createState() => _CalculadoraApuestasVistaState();
}

class _CalculadoraApuestasVistaState extends State<CalculadoraApuestasVista> {
  final _montoController = TextEditingController();
  final _cuotaController = TextEditingController();

  double _gananciaTotal = 0.0;
  double _gananciaNeta = 0.0;
  String _tipoApuesta = 'simple';

  @override
  void dispose() {
    _montoController.dispose();
    _cuotaController.dispose();
    super.dispose();
  }

  void _calcular() {
    final monto = double.tryParse(_montoController.text) ?? 0;
    final cuota = double.tryParse(_cuotaController.text) ?? 0;

    if (monto > 0 && cuota > 0) {
      setState(() {
        _gananciaTotal = monto * cuota;
        _gananciaNeta = _gananciaTotal - monto;
      });
    } else {
      setState(() {
        _gananciaTotal = 0;
        _gananciaNeta = 0;
      });
    }
  }

  void _limpiar() {
    setState(() {
      _montoController.clear();
      _cuotaController.clear();
      _gananciaTotal = 0;
      _gananciaNeta = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Calculadora de Apuestas'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _limpiar,
            tooltip: 'Limpiar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header informativo
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.greenAccent.withOpacity(0.2),
                    Colors.greenAccent.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.calculate, color: Colors.greenAccent, size: 32),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calcula tus ganancias',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Ingresa el monto y la cuota para ver tus posibles ganancias',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tipo de apuesta
            const Text(
              'Tipo de Apuesta',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Simple', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Una sola apuesta', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    value: 'simple',
                    groupValue: _tipoApuesta,
                    activeColor: Colors.greenAccent,
                    onChanged: (value) => setState(() => _tipoApuesta = value!),
                  ),
                  const Divider(color: Colors.white12, height: 1),
                  RadioListTile<String>(
                    title: const Text('Múltiple', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Multiplicador de cuotas', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    value: 'multiple',
                    groupValue: _tipoApuesta,
                    activeColor: Colors.greenAccent,
                    onChanged: (value) => setState(() => _tipoApuesta = value!),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Monto apostado
            const Text(
              'Monto Apostado',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _montoController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.attach_money, color: Colors.greenAccent),
                hintText: 'Ej: 1000',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.greenAccent, width: 2),
                ),
              ),
              onChanged: (_) => _calcular(),
            ),

            const SizedBox(height: 20),

            // Cuota
            const Text(
              'Cuota',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _cuotaController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.trending_up, color: Colors.greenAccent),
                hintText: 'Ej: 2.5',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.greenAccent, width: 2),
                ),
              ),
              onChanged: (_) => _calcular(),
            ),

            const SizedBox(height: 32),

            // Resultados
            if (_gananciaTotal > 0) ...[
              const Text(
                'Resultados',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Ganancia Total
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.greenAccent.withOpacity(0.3),
                      Colors.greenAccent.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.greenAccent.withOpacity(0.4)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.account_balance_wallet, color: Colors.greenAccent, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Ganancia Total',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\$${_gananciaTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Desglose
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    _buildResultRow(
                      'Monto apostado',
                      '\$${_montoController.text}',
                      Colors.white70,
                      Icons.payment,
                    ),
                    const Divider(color: Colors.white12, height: 24),
                    _buildResultRow(
                      'Ganancia neta',
                      '\$${_gananciaNeta.toStringAsFixed(2)}',
                      Colors.amber,
                      Icons.trending_up,
                    ),
                    const Divider(color: Colors.white12, height: 24),
                    _buildResultRow(
                      'Retorno',
                      '${(((_gananciaTotal / double.parse(_montoController.text)) - 1) * 100).toStringAsFixed(1)}%',
                      Colors.cyanAccent,
                      Icons.percent,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Botón calcular de nuevo
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _limpiar,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Nueva Apuesta'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ] else
            // Mensaje inicial
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.calculate_outlined,
                        size: 64,
                        color: Colors.white24,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Ingresa los datos para calcular',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}