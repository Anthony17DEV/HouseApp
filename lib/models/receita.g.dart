// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receita.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReceitaAdapter extends TypeAdapter<Receita> {
  @override
  final int typeId = 0;

  @override
  Receita read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Receita(
      descricao: fields[0] as String,
      valor: fields[1] as double,
      data: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Receita obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.descricao)
      ..writeByte(1)
      ..write(obj.valor)
      ..writeByte(2)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceitaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
