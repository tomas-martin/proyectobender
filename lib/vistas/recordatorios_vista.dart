import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vista_modelos/recordatorios_vm.dart';
import '../modelos/recordatorio_pago.dart';
import 'agregar_recordatorio_vista.dart';
import '../widgets/barra_inferior.dart';
import '../vista_modelos/navigation_viewmodel.dart';

class RecordatoriosVista extends StatelessWidget {
  const RecordatoriosVista({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RecordatoriosViewModel>(context);
    final nav = Provider.of<NavigationViewModel>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Recordatorios (${vm.cantidadVencidos} vencidos)'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => vm.escucharRecordatorios(),
          ),
        ],
      ),
      body: vm.cargando
          ? const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      )
          : vm.recordatorios.isEmpty
          ? _buildEmptyState()
          : Column(
        children: [
          _buildResumen(vm),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: 80,
              ),
              itemCount: vm.recordatorios.length,
              itemBuilder: (context, i) {
                final r = vm.recordatorios[i];
                return _buildRecordatorioCard(context, r, vm);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AgregarRecordatorioVista(),
            ),
          );
        },
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('Crear Recordatorio'),
      ),
      bottomNavigationBar: BarraInferior(viewModel: nav),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'No hay recordatorios',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Se crean automáticamente con los pagos pendientes',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResumen(RecordatoriosViewModel vm) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withOpacity(0.2),
            Colors.orange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildEstadistica(
            'Vencidos',
            vm.cantidadVencidos.toString(),
            Colors.red,
            Icons.warning,
          ),
          Container(width: 1, height: 40, color: Colors.white12),
          _buildEstadistica(
            'Próximos',
            vm.cantidadProximos.toString(),
            Colors.orange,
            Icons.schedule,
          ),
          Container(width: 1, height: 40, color: Colors.white12),
          _buildEstadistica(
            'Total',
            vm.recordatorios.length.toString(),
            Colors.white70,
            Icons.list,
          ),
        ],
      ),
    );
  }

  Widget _buildEstadistica(
      String label,
      String value,
      Color color,
      IconData icon,
      ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordatorioCard(
      BuildContext context,
      RecordatorioPago recordatorio,
      RecordatoriosViewModel vm,
      ) {
    final Color statusColor = recordatorio.estaVencido
        ? Colors.red
        : recordatorio.estaProximo
        ? Colors.orange
        : Colors.green;

    return Card(
      color: recordatorio.estaPagado
          ? Colors.green.withOpacity(0.1)
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: recordatorio.estaPagado
            ? BorderSide(color: Colors.green.withOpacity(0.3))
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _mostrarDetalle(context, recordatorio, vm),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  recordatorio.estaPagado
                      ? Icons.check_circle
                      : recordatorio.estaVencido
                      ? Icons.error
                      : Icons.schedule,
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            recordatorio.propiedadTitulo,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: recordatorio.estaPagado
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        if (recordatorio.estaPagado)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'PAGADO',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 14, color: Colors.purple),
                        const SizedBox(width: 4),
                        Text(
                          recordatorio.propietarioNombre,
                          style: const TextStyle(
                            color: Colors.purple,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '\$${recordatorio.monto.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            recordatorio.estaVencido
                                ? 'VENCIDO'
                                : recordatorio.estaProximo
                                ? 'PRÓXIMO'
                                : 'AL DÍA',
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          recordatorio.fechaFormateada,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    if (recordatorio.estaVencido && !recordatorio.estaPagado) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${recordatorio.diasHastaVencimiento.abs()} días de retraso',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    if (recordatorio.estaProximo && !recordatorio.estaPagado) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Vence en ${recordatorio.diasHastaVencimiento} días',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.3),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 REEMPLAZAR el método _mostrarDetalle en recordatorios_vista.dart

  void _mostrarDetalle(
      BuildContext context,
      RecordatorioPago recordatorio,
      RecordatoriosViewModel vm,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomContext) {
        final statusColor = recordatorio.estaVencido
            ? Colors.red
            : recordatorio.estaProximo
            ? Colors.orange
            : Colors.green;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      recordatorio.estaPagado
                          ? Icons.check_circle
                          : Icons.schedule,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recordatorio.propiedadTitulo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Vence: ${recordatorio.fechaFormateada}',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (recordatorio.estaPagado)
                    const Icon(Icons.check_circle, color: Colors.green, size: 32),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white12),
              const SizedBox(height: 12),

              // Información
              _buildInfoRow(
                Icons.person,
                'Propietario',
                recordatorio.propietarioNombre,
                Colors.purple,
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.attach_money,
                'Monto',
                '\$${recordatorio.monto.toStringAsFixed(0)}',
                Colors.amber,
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.info,
                'Estado',
                recordatorio.estado.toUpperCase(),
                statusColor,
              ),

              // 🆕 Mostrar si ya fue notificado
              if (recordatorio.notificado) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check, color: Colors.blue, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Email enviado el ${recordatorio.fechaNotificacion != null ? "${recordatorio.fechaNotificacion!.day}/${recordatorio.fechaNotificacion!.month}/${recordatorio.fechaNotificacion!.year}" : "fecha desconocida"}',
                          style: const TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // 🔥 BOTÓN DE ENVIAR NOTIFICACIÓN
              if (!recordatorio.estaPagado && !recordatorio.notificado)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(bottomContext);

                      // Mostrar loading
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(
                          child: CircularProgressIndicator(color: Colors.amber),
                        ),
                      );

                      try {
                        // Enviar email
                        final esVencido = recordatorio.estaVencido;
                        final enviado = await vm.enviarEmailRecordatorio(
                          recordatorio,
                          esVencido: esVencido,
                        );

                        if (context.mounted) {
                          Navigator.pop(context); // Cerrar loading

                          if (enviado) {
                            // Marcar como enviado
                            await vm.marcarEnviado(recordatorio.id);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Email enviado exitosamente'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('❌ No se pudo enviar el email. Verifica que el propietario tenga email registrado.'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 4),
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          Navigator.pop(context); // Cerrar loading
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('❌ Error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Enviar Email Ahora'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),

              // 🆕 BOTÓN PARA REENVIAR (si ya fue enviado pero no pagado)
              if (!recordatorio.estaPagado && recordatorio.notificado)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.pop(bottomContext);

                      // Confirmar reenvío
                      final confirmar = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          backgroundColor: const Color(0xFF1E1E1E),
                          title: const Text(
                            '¿Reenviar email?',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            'Se volverá a enviar el recordatorio de pago al propietario.',
                            style: TextStyle(color: Colors.white70),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext, false),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(dialogContext, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text('Reenviar'),
                            ),
                          ],
                        ),
                      );

                      if (confirmar == true && context.mounted) {
                        // Mostrar loading
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(
                            child: CircularProgressIndicator(color: Colors.amber),
                          ),
                        );

                        try {
                          final esVencido = recordatorio.estaVencido;
                          final enviado = await vm.enviarEmailRecordatorio(
                            recordatorio,
                            esVencido: esVencido,
                          );

                          if (context.mounted) {
                            Navigator.pop(context);

                            if (enviado) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('✅ Email reenviado'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('❌ No se pudo reenviar el email'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('❌ Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reenviar Email'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // Botones de editar y eliminar
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(bottomContext);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AgregarRecordatorioVista(recordatorio: recordatorio),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.amber,
                        side: const BorderSide(color: Colors.amber),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(bottomContext);
                        _confirmarEliminar(context, recordatorio, vm);
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Eliminar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(color: Colors.white54, fontSize: 13),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _confirmarEliminar(
      BuildContext context,
      RecordatorioPago recordatorio,
      RecordatoriosViewModel vm,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          '¿Eliminar recordatorio?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          recordatorio.propiedadTitulo,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await vm.eliminar(recordatorio.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Recordatorio eliminado'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}