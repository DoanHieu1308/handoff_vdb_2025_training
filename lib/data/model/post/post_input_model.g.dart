// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_input_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostInputModelAdapter extends TypeAdapter<PostInputModel> {
  @override
  final int typeId = 0;

  @override
  PostInputModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostInputModel(
      id: fields[0] as String?,
      title: fields[1] as String?,
      content: fields[2] as String?,
      privacy: fields[3] as String?,
      hashtags: (fields[4] as List?)?.cast<String>(),
      friends_tagged: (fields[5] as List?)?.cast<String>(),
      images: (fields[6] as List?)?.cast<String>(),
      videos: (fields[7] as List?)?.cast<String>(),
      postLinkMeta: fields[8] as PostLinkMeta?,
      userId: fields[9] as String?,
      createdAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PostInputModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.privacy)
      ..writeByte(4)
      ..write(obj.hashtags)
      ..writeByte(5)
      ..write(obj.friends_tagged)
      ..writeByte(6)
      ..write(obj.images)
      ..writeByte(7)
      ..write(obj.videos)
      ..writeByte(8)
      ..write(obj.postLinkMeta)
      ..writeByte(9)
      ..write(obj.userId)
      ..writeByte(10)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostInputModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
