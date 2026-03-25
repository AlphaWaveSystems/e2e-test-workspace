import '../../domain/entities/item.dart';

class ItemModel extends Item {
  const ItemModel({
    required super.id,
    required super.title,
    super.description,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['body'] as String? ?? '',
    );
  }
}
