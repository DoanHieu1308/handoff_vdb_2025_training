// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_link_meta.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostLinkMetaAdapter extends TypeAdapter<PostLinkMeta> {
  @override
  final int typeId = 1;

  @override
  PostLinkMeta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostLinkMeta(
      id: fields[0] as String?,
      postLinkUrl: fields[1] as String?,
      postLinkTitle: fields[2] as String?,
      postLinkDescription: fields[3] as String?,
      postLinkImage: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PostLinkMeta obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.postLinkUrl)
      ..writeByte(2)
      ..write(obj.postLinkTitle)
      ..writeByte(3)
      ..write(obj.postLinkDescription)
      ..writeByte(4)
      ..write(obj.postLinkImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostLinkMetaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
