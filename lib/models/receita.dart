import 'package:hive/hive.dart';

part 'receita.g.dart';

@HiveType(typeId: 0)
class Receita {
  @HiveField(0)
  final String descricao;

  @HiveField(1)
  final double valor;

  @HiveField(2)
  final DateTime data;

  Receita({required this.descricao, required this.valor, required this.data});
}
