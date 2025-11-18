import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailServicio {
  // ⚠️ IMPORTANTE: Reemplaza esta API key con tu clave real de Resend
  // Obtén tu clave en: https://resend.com/api-keys
  static const String _apiKey = 're_YeHaXymi_JPwVcAjKEimfhCTMh2QjiDt4';
  static const String _apiUrl = 'https://api.resend.com/emails';

  // Email del remitente (debe estar verificado en Resend)
  static const String _fromEmail = 'onboarding@resend.dev'; // Cambia esto por tu dominio verificado
  static const String _fromName = 'Bender Inmobiliaria';

  /// Enviar recordatorio de pago por email
  Future<bool> enviarRecordatorioPago({
    required String nombrePropietario,
    required String emailPropietario,
    required String propiedad,
    required double monto,
    required DateTime fechaVencimiento,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'from': '$_fromName <$_fromEmail>',
          'to': [emailPropietario],
          'subject': '🔔 Recordatorio de Pago - $propiedad',
          'html': _generarHtmlRecordatorio(
            nombrePropietario,
            propiedad,
            monto,
            fechaVencimiento,
          ),
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Email enviado exitosamente');
        return true;
      } else {
        print('❌ Error enviando email: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error al enviar email: $e');
      return false;
    }
  }

  /// Enviar notificación de pago recibido
  Future<bool> enviarConfirmacionPago({
    required String nombrePropietario,
    required String emailPropietario,
    required String propiedad,
    required double monto,
    required DateTime fechaPago,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'from': '$_fromName <$_fromEmail>',
          'to': [emailPropietario],
          'subject': '✅ Confirmación de Pago - $propiedad',
          'html': _generarHtmlConfirmacion(
            nombrePropietario,
            propiedad,
            monto,
            fechaPago,
          ),
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Confirmación de pago enviada');
        return true;
      } else {
        print('❌ Error enviando confirmación: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error: $e');
      return false;
    }
  }

  /// Enviar alerta de pago vencido
  Future<bool> enviarAlertaVencimiento({
    required String nombrePropietario,
    required String emailPropietario,
    required String propiedad,
    required double monto,
    required int diasVencido,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'from': '$_fromName <$_fromEmail>',
          'to': [emailPropietario],
          'subject': '⚠️ URGENTE: Pago Vencido - $propiedad',
          'html': _generarHtmlVencido(
            nombrePropietario,
            propiedad,
            monto,
            diasVencido,
          ),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error: $e');
      return false;
    }
  }

  // ========================================
  // PLANTILLAS HTML
  // ========================================

  String _generarHtmlRecordatorio(
      String nombre,
      String propiedad,
      double monto,
      DateTime fecha,
      ) {
    final fechaStr = '${fecha.day}/${fecha.month}/${fecha.year}';

    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; background: white; border-radius: 8px; overflow: hidden; }
        .header { background: linear-gradient(135deg, #FFC107 0%, #FF9800 100%); padding: 30px; text-align: center; }
        .header h1 { color: white; margin: 0; font-size: 28px; }
        .content { padding: 30px; }
        .info-box { background: #FFF3E0; border-left: 4px solid #FFC107; padding: 15px; margin: 20px 0; }
        .amount { font-size: 32px; color: #FFC107; font-weight: bold; text-align: center; margin: 20px 0; }
        .button { display: inline-block; background: #FFC107; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; }
        .footer { background: #f9f9f9; padding: 20px; text-align: center; font-size: 12px; color: #666; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>🏠 Bender Inmobiliaria</h1>
        </div>
        <div class="content">
          <h2>Hola $nombre,</h2>
          <p>Te recordamos que tienes un pago pendiente para la propiedad:</p>
          
          <div class="info-box">
            <strong>🏢 Propiedad:</strong> $propiedad<br>
            <strong>📅 Fecha de vencimiento:</strong> $fechaStr
          </div>
          
          <p style="text-align: center;">Monto a pagar:</p>
          <div class="amount">\$$monto</div>
          
          <p>Por favor, realiza el pago antes de la fecha de vencimiento para evitar recargos.</p>
          
          <p style="text-align: center; margin-top: 30px;">
            <a href="#" class="button">Ver Detalles</a>
          </p>
          
          <p style="color: #666; font-size: 14px; margin-top: 30px;">
            Si ya realizaste el pago, por favor ignora este mensaje.
          </p>
        </div>
        <div class="footer">
          <p>Este es un mensaje automático de Bender Inmobiliaria</p>
          <p>© 2025 Bender Inmobiliaria - Todos los derechos reservados</p>
        </div>
      </div>
    </body>
    </html>
    ''';
  }

  String _generarHtmlConfirmacion(
      String nombre,
      String propiedad,
      double monto,
      DateTime fecha,
      ) {
    final fechaStr = '${fecha.day}/${fecha.month}/${fecha.year}';

    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; background: white; border-radius: 8px; overflow: hidden; }
        .header { background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%); padding: 30px; text-align: center; }
        .header h1 { color: white; margin: 0; font-size: 28px; }
        .content { padding: 30px; }
        .check-icon { text-align: center; font-size: 64px; color: #4CAF50; margin: 20px 0; }
        .info-box { background: #E8F5E9; border-left: 4px solid #4CAF50; padding: 15px; margin: 20px 0; }
        .footer { background: #f9f9f9; padding: 20px; text-align: center; font-size: 12px; color: #666; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>✅ Pago Confirmado</h1>
        </div>
        <div class="content">
          <div class="check-icon">✓</div>
          
          <h2 style="text-align: center;">¡Gracias $nombre!</h2>
          <p style="text-align: center;">Hemos recibido tu pago correctamente.</p>
          
          <div class="info-box">
            <strong>🏢 Propiedad:</strong> $propiedad<br>
            <strong>💰 Monto:</strong> \$$monto<br>
            <strong>📅 Fecha de pago:</strong> $fechaStr
          </div>
          
          <p style="color: #666; margin-top: 30px;">
            Tu comprobante de pago ha sido registrado en nuestro sistema.
            Gracias por tu puntualidad.
          </p>
        </div>
        <div class="footer">
          <p>Bender Inmobiliaria - Tu aliado en bienes raíces</p>
        </div>
      </div>
    </body>
    </html>
    ''';
  }

  String _generarHtmlVencido(
      String nombre,
      String propiedad,
      double monto,
      int diasVencido,
      ) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; background: white; border-radius: 8px; overflow: hidden; }
        .header { background: linear-gradient(135deg, #f44336 0%, #d32f2f 100%); padding: 30px; text-align: center; }
        .header h1 { color: white; margin: 0; font-size: 28px; }
        .content { padding: 30px; }
        .alert-box { background: #FFEBEE; border-left: 4px solid #f44336; padding: 15px; margin: 20px 0; }
        .urgent { font-size: 18px; color: #f44336; font-weight: bold; text-align: center; margin: 20px 0; }
        .footer { background: #f9f9f9; padding: 20px; text-align: center; font-size: 12px; color: #666; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>⚠️ PAGO VENCIDO</h1>
        </div>
        <div class="content">
          <h2>Estimado/a $nombre,</h2>
          
          <div class="urgent">
            Tu pago está vencido hace $diasVencido días
          </div>
          
          <div class="alert-box">
            <strong>🏢 Propiedad:</strong> $propiedad<br>
            <strong>💰 Monto adeudado:</strong> \$$monto<br>
            <strong>⏰ Días de atraso:</strong> $diasVencido días
          </div>
          
          <p style="color: #d32f2f; font-weight: bold;">
            Es urgente que regularices tu situación lo antes posible para evitar recargos adicionales.
          </p>
          
          <p>Por favor, contáctanos para coordinar el pago o resolver cualquier inconveniente.</p>
          
          <p style="margin-top: 30px;">
            📞 Teléfono: +54 261 123-4567<br>
            📧 Email: contacto@benderinmobiliaria.com
          </p>
        </div>
        <div class="footer">
          <p>Bender Inmobiliaria</p>
        </div>
      </div>
    </body>
    </html>
    ''';
  }
}