import '../../domain/entities/product_entity.dart';
import '../datasource/product_firestore_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl {
  final ProductFirestoreDatasource datasource;

  ProductRepositoryImpl(
    this.datasource,
  );

  Future<void> createProduct(
    ProductEntity product,
  ) async {
    await datasource.createProduct(
      ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        stock: product.stock,
        minimumStock: product.minimumStock,
        purchasePrice: product.purchasePrice,
        salePrice: product.salePrice,
        active: product.active,
        createdAt: product.createdAt,
      ),
    );
  }

  Future<void> updateProduct(
    ProductEntity product,
  ) async {
    await datasource.updateProduct(
      ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        stock: product.stock,
        minimumStock: product.minimumStock,
        purchasePrice: product.purchasePrice,
        salePrice: product.salePrice,
        active: product.active,
        createdAt: product.createdAt,
      ),
    );
  }

  Future<void> deleteProduct(
    String id,
  ) async {
    await datasource.deleteProduct(id);
  }

  Future<List<ProductEntity>> getProducts() async {
    return await datasource.getProducts();
  }
}