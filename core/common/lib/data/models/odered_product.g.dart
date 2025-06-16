// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'odered_product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OderedProductAdapter extends TypeAdapter<OderedProduct> {
  @override
  final int typeId = 0;

  @override
  OderedProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OderedProduct(
      id: fields[0] as int,
      title: fields[1] as String,
      price: fields[2] as double,
      description: fields[3] as String,
      image: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OderedProduct obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OderedProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
