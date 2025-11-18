import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthServicio {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Verifica si el dispositivo tiene capacidades biométricas
  Future<bool> dispositivoSoportaBiometria() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      print('🔐 canCheckBiometrics: $canAuthenticateWithBiometrics');
      print('🔐 isDeviceSupported: ${await _auth.isDeviceSupported()}');
      print('🔐 canAuthenticate: $canAuthenticate');

      return canAuthenticate;
    } catch (e) {
      print('❌ Error verificando soporte: $e');
      return false;
    }
  }

  /// Obtiene los tipos de biometría disponibles
  Future<List<BiometricType>> obtenerBiometriasDisponibles() async {
    try {
      final List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();

      print('🔐 Biometrías disponibles:');
      for (var biometric in availableBiometrics) {
        print('  - $biometric');
      }

      if (availableBiometrics.isEmpty) {
        print('⚠️ No hay biometrías configuradas en el dispositivo');
      }

      return availableBiometrics;
    } catch (e) {
      print('❌ Error obteniendo biometrías: $e');
      return [];
    }
  }

  /// Autentica al usuario usando biometría
  Future<bool> autenticar() async {
    try {
      // Paso 1: Verificar que el dispositivo soporte biometría
      print('🔐 PASO 1: Verificando soporte del dispositivo...');
      final canAuthenticate = await dispositivoSoportaBiometria();

      if (!canAuthenticate) {
        print('❌ El dispositivo no soporta autenticación');
        return false;
      }

      // Paso 2: Verificar biometrías disponibles
      print('🔐 PASO 2: Obteniendo biometrías disponibles...');
      final availableBiometrics = await obtenerBiometriasDisponibles();

      if (availableBiometrics.isEmpty) {
        print('❌ No hay biometrías configuradas');
        return false;
      }

      // Paso 3: Intentar autenticar
      print('🔐 PASO 3: Lanzando diálogo de autenticación...');

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Verifica tu identidad para continuar',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          useErrorDialogs: true,
          sensitiveTransaction: false,
        ),
      );

      print('🔐 RESULTADO: ${didAuthenticate ? "✅ ÉXITO" : "❌ FALLÓ"}');
      return didAuthenticate;

    } on PlatformException catch (e) {
      print('❌ PlatformException capturada:');
      print('   Código: ${e.code}');
      print('   Mensaje: ${e.message}');
      print('   Detalles: ${e.details}');

      // Manejar códigos específicos
      if (e.code == 'NotAvailable') {
        print('⚠️ Autenticación biométrica no disponible');
      } else if (e.code == 'NotEnrolled') {
        print('⚠️ No hay huellas registradas');
      } else if (e.code == 'LockedOut') {
        print('⚠️ Bloqueado temporalmente por muchos intentos');
      } else if (e.code == 'PermanentlyLockedOut') {
        print('⚠️ Bloqueado permanentemente');
      } else if (e.code == 'PasscodeNotSet') {
        print('⚠️ No hay PIN/contraseña configurado');
      }

      return false;
    } catch (e, stackTrace) {
      print('❌ Error inesperado: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Verifica si hay biometría configurada
  Future<bool> hayBiometriaConfigurada() async {
    try {
      final biometrias = await obtenerBiometriasDisponibles();
      return biometrias.isNotEmpty;
    } catch (e) {
      print('❌ Error verificando configuración: $e');
      return false;
    }
  }

  /// Cancela autenticación en progreso
  Future<void> cancelarAutenticacion() async {
    try {
      await _auth.stopAuthentication();
      print('🔐 Autenticación cancelada');
    } catch (e) {
      print('❌ Error cancelando: $e');
    }
  }
}