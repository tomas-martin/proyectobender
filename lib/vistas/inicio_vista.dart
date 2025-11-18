import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vista_modelos/navigation_viewmodel.dart';
import '../servicios/biometric_auth_servicio.dart';
import '../widgets/barra_inferior.dart';
import 'tablero_vista.dart';
import 'propiedades_vista.dart';
import 'pagos_vista.dart';
import 'finanzas_vista.dart';
import 'propietarios_vista.dart';

class InicioVista extends StatefulWidget {
  const InicioVista({super.key});

  @override
  State<InicioVista> createState() => _InicioVistaState();
}

class _InicioVistaState extends State<InicioVista> {
  bool _mostrarPantallaInicio = true;
  bool _autenticando = false;
  bool _intentoFallido = false;
  String _mensajeDebug = '';
  final BiometricAuthServicio _biometricAuth = BiometricAuthServicio();

  @override
  void initState() {
    super.initState();
    print('═══════════════════════════════════════');
    print('🚀 INICIANDO APP - InicioVista');
    print('═══════════════════════════════════════');

    // Lanzar autenticación automática
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        print('⏰ Timer activado - iniciando autenticación');
        _autenticarAutomaticamente();
      }
    });
  }

  Future<void> _autenticarAutomaticamente() async {
    if (_autenticando) {
      print('⚠️ Ya hay una autenticación en progreso');
      return;
    }

    print('\n═══════════════════════════════════════');
    print('🔐 INICIANDO PROCESO DE AUTENTICACIÓN');
    print('═══════════════════════════════════════');

    setState(() {
      _autenticando = true;
      _intentoFallido = false;
      _mensajeDebug = 'Verificando dispositivo...';
    });

    try {
      // Verificar soporte
      print('\n1️⃣ Verificando soporte biométrico...');
      final soporta = await _biometricAuth.dispositivoSoportaBiometria();

      if (!soporta) {
        print('❌ Dispositivo no soporta biometría');
        if (mounted) {
          setState(() {
            _autenticando = false;
            _mensajeDebug = 'Biometría no disponible en este dispositivo';
          });
        }
        return;
      }

      print('✅ Dispositivo soporta biometría');

      // Verificar configuración
      print('\n2️⃣ Verificando configuración...');
      final hayConfig = await _biometricAuth.hayBiometriaConfigurada();

      if (!hayConfig) {
        print('❌ No hay biometría configurada');
        if (mounted) {
          setState(() {
            _autenticando = false;
            _mensajeDebug = 'No hay huella digital configurada en el dispositivo';
          });
        }
        return;
      }

      print('✅ Hay biometría configurada');

      // Intentar autenticar
      print('\n3️⃣ Lanzando diálogo de autenticación...');
      if (mounted) {
        setState(() {
          _mensajeDebug = 'Mostrando diálogo de huella...';
        });
      }

      final autenticado = await _biometricAuth.autenticar();

      print('\n═══════════════════════════════════════');
      print(autenticado ? '✅ AUTENTICACIÓN EXITOSA' : '❌ AUTENTICACIÓN FALLIDA');
      print('═══════════════════════════════════════\n');

      if (mounted) {
        if (autenticado) {
          // ÉXITO - Ir al tablero
          setState(() {
            _mostrarPantallaInicio = false;
            _mensajeDebug = '¡Autenticación exitosa!';
          });
        } else {
          // FALLÓ - Mostrar opción de reintentar
          setState(() {
            _autenticando = false;
            _intentoFallido = true;
            _mensajeDebug = 'Autenticación cancelada o incorrecta';
          });
        }
      }
    } catch (e, stackTrace) {
      print('\n❌❌❌ ERROR CRÍTICO ❌❌❌');
      print('Error: $e');
      print('StackTrace: $stackTrace');

      if (mounted) {
        setState(() {
          _autenticando = false;
          _intentoFallido = true;
          _mensajeDebug = 'Error: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationViewModel>(context);

    final paginas = const [
      TableroVista(),
      PropiedadesVista(),
      PagosVista(),
      FinanzasVista(),
      PropietariosVista(),
    ];

    return WillPopScope(
      onWillPop: () async {
        nav.cambiarIndice(0);
        setState(() => _mostrarPantallaInicio = false);
        return false;
      },
      child: Scaffold(
        appBar: _mostrarPantallaInicio
            ? null
            : AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => nav.cambiarIndice(0),
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _mostrarPantallaInicio
              ? _buildPantallaInicio(context)
              : IndexedStack(index: nav.indiceActual, children: paginas),
        ),
        bottomNavigationBar:
        _mostrarPantallaInicio ? null : BarraInferior(viewModel: nav),
      ),
    );
  }

  Widget _buildPantallaInicio(BuildContext context) {
    return Container(
      key: const ValueKey('inicio'),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.grey[900]!],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Logo
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/bender.png',
                      width: 180,
                      height: 180,
                      errorBuilder: (context, error, stack) => const Icon(
                        Icons.android,
                        color: Colors.amber,
                        size: 180,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                const Text(
                  'Bienvenido a Bender Inmobiliaria',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                const Text(
                  'Gestiona tus propiedades con estilo',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 50),

                // Estado de autenticación
                if (_autenticando)
                  _buildAutenticando()
                else if (_intentoFallido)
                  _buildFallido()
                else
                  _buildInicial(),

                const SizedBox(height: 30),

                // Mensaje de debug (solo en desarrollo)
                if (_mensajeDebug.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _mensajeDebug,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Botón saltar
                TextButton(
                  onPressed: () {
                    print('👤 Usuario eligió entrar sin autenticación');
                    setState(() => _mostrarPantallaInicio = false);
                  },
                  child: const Text(
                    'Entrar sin autenticación',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAutenticando() {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.8, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.4 * value),
                      blurRadius: 20 * value,
                      spreadRadius: 5 * value,
                    ),
                  ],
                ),
                child: const Icon(Icons.fingerprint, size: 45, color: Colors.black),
              ),
            );
          },
          onEnd: () {
            if (mounted && _autenticando) setState(() {});
          },
        ),
        const SizedBox(height: 20),
        const Text(
          'Verificando identidad...',
          style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        const Text(
          'Usa tu huella digital o PIN',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildFallido() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.red.withOpacity(0.5), width: 2),
          ),
          child: const Icon(Icons.error_outline, size: 45, color: Colors.red),
        ),
        const SizedBox(height: 20),
        const Text(
          'Autenticación cancelada',
          style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            print('🔄 Usuario solicitó reintentar');
            _autenticarAutomaticamente();
          },
          icon: const Icon(Icons.fingerprint),
          label: const Text('Intentar de nuevo'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ],
    );
  }

  Widget _buildInicial() {
    return Column(
      children: const [
        Icon(Icons.info_outline, color: Colors.white54, size: 48),
        SizedBox(height: 16),
        Text(
          'Preparando autenticación...',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}