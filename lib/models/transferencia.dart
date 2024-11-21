import 'package:hive/hive.dart';

part 'transferencia.g.dart';

@HiveType(typeId: 2)
class Transferencia {
  @HiveField(0)
  final String contaOrigem;

  @HiveField(1)
  final String contaDestino;

  @HiveField(2)
  final double valor;

  @HiveField(3)
  final DateTime data;

  Transferencia({
    required this.contaOrigem,
    required this.contaDestino,
    required this.valor,
    required this.data,
  });
}
