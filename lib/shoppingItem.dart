class ShoppingItem {
  final String id;
  final String name;
  final bool needToBuy;

  const ShoppingItem({
    required this.id,
    required this.name,
    required this.needToBuy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'needToBuy': needToBuy,
    };
  }

  @override
  String toString() {
    return 'ShoppingItem{id: $id, name: $name needToBuy: $needToBuy}';
  }
}
