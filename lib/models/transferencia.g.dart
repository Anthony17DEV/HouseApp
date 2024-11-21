// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transferencia.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransferenciaAdapter extends TypeAdapter<Transferencia> {
  @override
  final int typeId = 2;

  @override
  Transferencia read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transferencia(
      contaOrigem: fields[0] as String,
      contaDestino: fields[1] as String,
      valor: fields[2] as double,
      data: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Transferencia obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.contaOrigem)
      ..writeByte(1)
      ..write(obj.contaDestino)
      ..writeByte(2)
      ..write(obj.valor)
      ..writeByte(3)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransferenciaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
