import 'package:hive/hive.dart';

part 'despesa.g.dart';

@HiveType(typeId: 1)
class Despesa {
  @HiveField(0)
  final String descricao;

  @HiveField(1)
  final double valor;

  @HiveField(2)
  final DateTime data;

  Despesa({required this.descricao, required this.valor, required this.data});
}
