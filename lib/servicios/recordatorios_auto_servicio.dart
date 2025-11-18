import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/pago.dart';
import '../modelos/recordatorio_pago.dart';

/// Servicio para generar recordatorios automáticamente desde pagos
class RecordatoriosAutoServicio {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Generar recordatorios automáticos desde pagos pendientes
  Future<void> generarRecordatoriosAutomaticos() async {
    try {
      print('🔄 Iniciando generación automática de recordatorios...');

      // 1. Obtener todos los pagos pendientes y morosos
      final pagosPendientes = await _db
          .collection('pagos')
          .where('estado', whereIn: ['pendiente', 'moroso'])
          .get();

      print('📦 Pagos pendientes encontrados: ${pagosPendientes.docs.length}');

      // 2. Obtener recordatorios existentes
      final recordatoriosExistentes = await _db
          .collection('recordatorios')
          .get();

      // Crear un Set con los IDs de pagos que ya tienen recordatorio
      final pagosCubiertos = <String>{};
      for (var doc in recordatoriosExistentes.docs) {
        final data = doc.data();
        final pagoId = data['pagoId'] as String?;
        if (pagoId != null) {
          pagosCubiertos.add(pagoId);
        }
      }

      print('✅ Recordatorios existentes: ${pagosCubiertos.length}');

      // 3. Crear recordatorios para pagos que no tienen
      int creados = 0;
      for (var doc in pagosPendientes.docs) {
        final pago = Pago.fromMap(doc.id, doc.data());

        // Si ya tiene recordatorio, saltar
        if (pagosCubiertos.contains(doc.id)) {
          continue;
        }

        // Crear recordatorio automático
        await _crearRecordatorioDesdePago(doc.id, pago);
        creados++;
      }

      print('✅ Recordatorios creados: $creados');
      print('🎉 Generación automática completada');

    } catch (e) {
      print('❌ Error en generación automática: $e');
      rethrow;
    }
  }

  /// Crear un recordatorio desde un pago
  Future<void> _crearRecordatorioDesdePago(String pagoId, Pago pago) async {
    try {
      // Calcular fecha de vencimiento (7 días después de la fecha del pago)
      final fechaVencimiento = pago.fecha.add(const Duration(days: 7));

      final recordatorio = RecordatorioPago(
        id: '', // Firebase generará el ID
        propiedadId: pago.propiedadId,
        propiedadTitulo: pago.propiedadTitulo,
        propietarioId: pago.propietarioId ?? '',
        propietarioNombre: pago.propietarioNombre ?? 'Sin propietario',
        monto: pago.monto,
        fechaVencimiento: fechaVencimiento,
        estado: pago.estado, // Hereda el estado del pago
        notificado: false,
      );

      // Guardar en Firebase con el pagoId vinculado
      final data = recordatorio.toMap();
      data['pagoId'] = pagoId; // ⭐ Vincular con el pago
      data['generadoAutomaticamente'] = true; // Marcar como automático

      await _db.collection('recordatorios').add(data);

      print('✅ Recordatorio creado para pago: ${pago.propiedadTitulo}');
    } catch (e) {
      print('❌ Error creando recordatorio: $e');
    }
  }

  /// Actualizar recordatorios cuando cambian los pagos
  Future<void> sincronizarRecordatoriosConPagos() async {
    try {
      print('🔄 Sincronizando recordatorios con pagos...');

      // Obtener todos los recordatorios automáticos
      final recordatorios = await _db
          .collection('recordatorios')
          .where('generadoAutomaticamente', isEqualTo: true)
          .get();

      int actualizados = 0;
      int eliminados = 0;

      for (var doc in recordatorios.docs) {
        final data = doc.data();
        final pagoId = data['pagoId'] as String?;

        if (pagoId == null) continue;

        // Buscar el pago correspondiente
        final pagoDoc = await _db.collection('pagos').doc(pagoId).get();

        if (!pagoDoc.exists) {
          // El pago fue eliminado, eliminar el recordatorio
          await doc.reference.delete();
          eliminados++;
          continue;
        }

        final pago = Pago.fromMap(pagoDoc.id, pagoDoc.data()!);

        // Si el pago está pagado, eliminar el recordatorio
        if (pago.estaPagado) {
          await doc.reference.delete();
          eliminados++;
          print('✅ Recordatorio eliminado (pago completado): ${pago.propiedadTitulo}');
          continue;
        }

        // Actualizar el estado del recordatorio según el pago
        if (data['estado'] != pago.estado) {
          await doc.reference.update({'estado': pago.estado});
          actualizados++;
          print('✅ Recordatorio actualizado: ${pago.propiedadTitulo}');
        }
      }

      print('✅ Sincronización completada');
      print('   - Actualizados: $actualizados');
      print('   - Eliminados: $eliminados');

    } catch (e) {
      print('❌ Error en sincronización: $e');
    }
  }

  /// Eliminar recordatorios de pagos que ya fueron pagados
  Future<void> limpiarRecordatoriosPagados() async {
    try {
      final recordatorios = await _db
          .collection('recordatorios')
          .where('estado', isEqualTo: 'pagado')
          .get();

      for (var doc in recordatorios.docs) {
        await doc.reference.delete();
      }

      print('✅ ${recordatorios.docs.length} recordatorios de pagos completados eliminados');
    } catch (e) {
      print('❌ Error limpiando recordatorios: $e');
    }
  }

  /// Crear recordatorio automático cuando se crea un pago
  Future<void> crearRecordatorioParaNuevoPago(String pagoId, Pago pago) async {
    try {
      // Solo crear recordatorio si el pago está pendiente o moroso
      if (!pago.estaPagado) {
        await _crearRecordatorioDesdePago(pagoId, pago);
        print('✅ Recordatorio automático creado para nuevo pago');
      }
    } catch (e) {
      print('❌ Error creando recordatorio para nuevo pago: $e');
    }
  }

  /// Eliminar recordatorio cuando se marca un pago como pagado
  Future<void> eliminarRecordatorioDePago(String pagoId) async {
    try {
      final recordatorios = await _db
          .collection('recordatorios')
          .where('pagoId', isEqualTo: pagoId)
          .get();

      for (var doc in recordatorios.docs) {
        await doc.reference.delete();
        print('✅ Recordatorio eliminado (pago marcado como pagado)');
      }
    } catch (e) {
      print('❌ Error eliminando recordatorio: $e');
    }
  }
}