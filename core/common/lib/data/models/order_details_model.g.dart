// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderDetailsModelAdapter extends TypeAdapter<OrderDetailsModel> {
  @override
  final int typeId = 1;

  @override
  OrderDetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderDetailsModel(
      userId: fields[0] as int,
      date: fields[1] as String,
      products: (fields[2] as List).cast<OderedProduct>(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderDetailsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.products);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDetailsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
