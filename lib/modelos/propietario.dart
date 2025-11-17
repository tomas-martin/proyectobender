import 'package:cloud_firestore/cloud_firestore.dart';

class Propietario {
  final String id;
  final String nombre;
  final String telefono;
  final String email;
  final String? direccion;
  final String? notas;
  final DateTime fechaRegistro;

  Propietario({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.email,
    this.direccion,
    this.notas,
    DateTime? fechaRegistro,
  }) : fechaRegistro = fechaRegistro ?? DateTime.now();

  // Leer desde Firestore
  factory Propietario.fromMap(String id, Map<String, dynamic> data) {
    return Propietario(
      id: id,
      nombre: data['nombre']?.toString() ?? 'Sin nombre',
      telefono: data['telefono']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      direccion: data['direccion']?.toString(),
      notas: data['notas']?.toString(),
      fechaRegistro: (data['fechaRegistro'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'telefono': telefono,
      'email': email,
      'direccion': direccion,
      'notas': notas,
      'fechaRegistro': Timestamp.fromDate(fechaRegistro),
    };
  }

  // Crear copia con cambios
  Propietario copyWith({
    String? id,
    String? nombre,
    String? telefono,
    String? email,
    String? direccion,
    String? notas,
    DateTime? fechaRegistro,
  }) {
    return Propietario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      direccion: direccion ?? this.direccion,
      notas: notas ?? this.notas,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
    );
  }

  // Formatear fecha para mostrar
  String get fechaFormateada {
    return '${fechaRegistro.day}/${fechaRegistro.month}/${fechaRegistro.year}';
  }
}