import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../modelos/recordatorio_pago.dart';
import '../modelos/propietario.dart';
import '../servicios/recordatorios_servicio.dart';
import '../servicios/email_servicio.dart';

class RecordatoriosViewModel extends ChangeNotifier {
  final RecordatoriosServicio _servicio = RecordatoriosServicio();
  final EmailServicio _emailServicio = EmailServicio();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<RecordatorioPago> _lista = [];
  List<RecordatorioPago> get recordatorios => _lista;

  bool cargando = true;
  String? error;

  StreamSubscription<QuerySnapshot>? _subscription;

  // ✅ Timer para verificación automática
  Timer? _verificacionTimer;

  RecordatoriosViewModel() {
    escucharRecordatorios();
    _iniciarVerificacionAutomatica();
  }

  /// 🆕 Verificación automática cada hora
  void _iniciarVerificacionAutomatica() {
    _verificacionTimer = Timer.periodic(
      const Duration(hours: 1),
          (_) => verificarYEnviarRecordatorios(),
    );

    // Verificar inmediatamente al iniciar
    Future.delayed(const Duration(seconds: 5), () {
      verificarYEnviarRecordatorios();
    });
  }

  /// Escuchar cambios en tiempo real
  void escucharRecordatorios() {
    try {
      cargando = true;
      error = null;
      notifyListeners();

      _subscription = _servicio.obtenerRecordatorios().listen(
            (snapshot) {
          debugPrint('📦 Recordatorios recibidos: ${snapshot.docs.length}');

          _lista = snapshot.docs.map((doc) {
            return RecordatorioPago.fromMap(doc.id, doc.data() as Map<String, dynamic>);
          }).toList();

          cargando = false;
          debugPrint('✅ Total recordatorios cargados: ${_lista.length}');
          notifyListeners();
        },
        onError: (e) {
          error = "Error al cargar recordatorios: $e";
          cargando = false;
          notifyListeners();
          debugPrint('❌ Error en stream de recordatorios: $e');
        },
      );
    } catch (e) {
      error = "Error de conexión: $e";
      cargando = false;
      notifyListeners();
      debugPrint('❌ Error iniciando stream: $e');
    }
  }

  /// 🆕 Verificar y enviar recordatorios automáticamente
  Future<void> verificarYEnviarRecordatorios() async {
    try {
      debugPrint('🔍 Verificando recordatorios para enviar emails...');

      final ahora = DateTime.now();
      int enviados = 0;

      for (final recordatorio in _lista) {
        // Saltar si ya está pagado
        if (recordatorio.estaPagado) continue;

        // Calcular días restantes
        final diasRestantes = recordatorio.fechaVencimiento.difference(ahora).inDays;

        // ✅ CONDICIÓN 1: Pago próximo (menos de 5 días)
        final esProximo = diasRestantes >= 0 && diasRestantes < 5;

        // ✅ CONDICIÓN 2: Pago vencido
        final esVencido = diasRestantes < 0;

        // Solo enviar si cumple condiciones Y no ha sido notificado
        if ((esProximo || esVencido) && !recordatorio.notificado) {
          final enviado = await enviarEmailRecordatorio(recordatorio, esVencido: esVencido);

          if (enviado) {
            enviados++;
            // Marcar como notificado
            await marcarEnviado(recordatorio.id);
          }
        }
      }

      if (enviados > 0) {
        debugPrint('✅ Se enviaron $enviados recordatorios por email');
      } else {
        debugPrint('ℹ️ No hay recordatorios pendientes de enviar');
      }
    } catch (e) {
      debugPrint('❌ Error verificando recordatorios: $e');
    }
  }

  /// 🆕 Enviar email de recordatorio
  Future<bool> enviarEmailRecordatorio(
      RecordatorioPago recordatorio, {
        bool esVencido = false,
      }) async {
    try {
      // Obtener datos del propietario
      final propietarioDoc = await _db
          .collection('propietarios')
          .doc(recordatorio.propietarioId)
          .get();

      if (!propietarioDoc.exists) {
        debugPrint('❌ Propietario no encontrado: ${recordatorio.propietarioId}');
        return false;
      }

      final propietarioData = propietarioDoc.data()!;
      final emailPropietario = propietarioData['email'] as String?;

      if (emailPropietario == null || emailPropietario.isEmpty) {
        debugPrint('❌ El propietario no tiene email registrado');
        return false;
      }

      debugPrint('📧 Enviando email a: $emailPropietario');

      // Enviar email
      final enviado = await _emailServicio.enviarRecordatorioPago(
        nombrePropietario: recordatorio.propietarioNombre,
        emailPropietario: emailPropietario,
        propiedad: recordatorio.propiedadTitulo,
        monto: recordatorio.monto,
        fechaVencimiento: recordatorio.fechaVencimiento,
        esVencido: esVencido,
      );

      if (enviado) {
        debugPrint('✅ Email enviado exitosamente a $emailPropietario');
      } else {
        debugPrint('❌ No se pudo enviar el email');
      }

      return enviado;
    } catch (e) {
      debugPrint('❌ Error enviando email: $e');
      return false;
    }
  }

  /// Agregar nuevo recordatorio
  Future<void> agregar(RecordatorioPago recordatorio) async {
    try {
      await _servicio.agregarRecordatorio(recordatorio.toMap());
      debugPrint('✅ Recordatorio agregado');
    } catch (e) {
      error = "Error al agregar recordatorio: $e";
      notifyListeners();
      debugPrint('❌ Error: $e');
      rethrow;
    }
  }

  /// Actualizar recordatorio
  Future<void> actualizar(String id, RecordatorioPago recordatorio) async {
    try {
      await _servicio.actualizarRecordatorio(id, recordatorio.toMap());
      debugPrint('✅ Recordatorio actualizado');
    } catch (e) {
      error = "Error al actualizar recordatorio: $e";
      notifyListeners();
      rethrow;
    }
  }

  /// Eliminar recordatorio
  Future<void> eliminar(String id) async {
    try {
      await _servicio.borrarRecordatorio(id);
      debugPrint('✅ Recordatorio eliminado');
    } catch (e) {
      error = "Error al eliminar recordatorio: $e";
      notifyListeners();
      rethrow;
    }
  }

  /// Marcar como enviado
  Future<void> marcarEnviado(String id) async {
    try {
      await _servicio.marcarComoEnviado(id);
      debugPrint('✅ Recordatorio marcado como enviado');
    } catch (e) {
      error = "Error: $e";
      notifyListeners();
      rethrow;
    }
  }

  /// Obtener recordatorios vencidos
  List<RecordatorioPago> get recordatoriosVencidos =>
      _lista.where((r) => r.estaVencido).toList();

  /// Obtener recordatorios próximos
  List<RecordatorioPago> get recordatoriosProximos =>
      _lista.where((r) => r.estaProximo && !r.estaVencido).toList();

  /// Contadores
  int get cantidadVencidos => recordatoriosVencidos.length;
  int get cantidadProximos => recordatoriosProximos.length;

  /// Obtener recordatorios de una propiedad
  List<RecordatorioPago> recordatoriosPorPropiedad(String propiedadId) {
    return _lista.where((r) => r.propiedadId == propiedadId).toList();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _verificacionTimer?.cancel();
    debugPrint('🔌 RecordatoriosViewModel disposed');
    super.dispose();
  }
}