import 'package:handoff_vdb_2025/core/enums/enums.dart';

class PostOptionItem {
  final PostOptionType type;
  String name;
  String icon;
  bool selected;

  PostOptionItem({
    required this.type,
    required this.name,
    required this.icon,
    this.selected = false,
  });

  PostOptionItem copyWith({
    String? name,
    String? icon,
    bool? selected,
  }) {
    return PostOptionItem(
      type: type,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      selected: selected ?? this.selected,
    );
  }
}