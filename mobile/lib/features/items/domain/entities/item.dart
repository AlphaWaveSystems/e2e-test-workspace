class Item {
  final int id;
  final String title;
  final String description;

  const Item({
    required this.id,
    required this.title,
    this.description = '',
  });
}
