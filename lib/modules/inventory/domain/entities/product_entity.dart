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
    ProductEntity copyWith({
    String? id,
    String? name,
    String? description,
    int? stock,
    int? minimumStock,
    double? purchasePrice,
    double? salePrice,
    bool? active,
    DateTime? createdAt,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      minimumStock:
          minimumStock ?? this.minimumStock,
      purchasePrice:
          purchasePrice ?? this.purchasePrice,
      salePrice:
          salePrice ?? this.salePrice,
      active: active ?? this.active,
      createdAt:
          createdAt ?? this.createdAt,
    );
  }
}
