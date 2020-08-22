// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlarmData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmAdapter extends TypeAdapter<Alarm> {
  @override
  final typeId = 0;

  @override
  Alarm read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Alarm(
      label: fields[1] as String,
      repeat: (fields[3] as List)?.cast<int>(),
      state: fields[2] as bool,
      time: fields[0] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Alarm obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.state)
      ..writeByte(3)
      ..write(obj.repeat);
  }
}
