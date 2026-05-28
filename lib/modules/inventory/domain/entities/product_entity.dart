class ProductEntity {
  final String id;

  final String name;

  final String description;

  final int stock;

  final int minimumStock;

  final double purchasePrice;

  final double salePrice;

  final bool active;

  final DateTime createdAt;

  ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.stock,
    required this.minimumStock,
    required this.purchasePrice,
    required this.salePrice,
    required this.active,
    required this.createdAt,
  });
}