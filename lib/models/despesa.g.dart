// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'despesa.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DespesaAdapter extends TypeAdapter<Despesa> {
  @override
  final int typeId = 1;

  @override
  Despesa read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Despesa(
      descricao: fields[0] as String,
      valor: fields[1] as double,
      data: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Despesa obj) {
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
      other is DespesaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
