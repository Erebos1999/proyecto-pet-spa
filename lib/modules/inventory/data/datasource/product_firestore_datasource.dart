import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class ProductFirestoreDatasource {
  final firestore = FirebaseFirestore.instance;

  Future<void> createProduct(ProductModel product) async {
    await firestore.collection('products').add(product.toMap());
  }

  Future<void> updateProduct(ProductModel product) async {
    await firestore
        .collection('products')
        .doc(product.id)
        .update(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await firestore.collection('products').doc(id).delete();
  }

  Future<List<ProductModel>> getProducts() async {
    final snapshot = await firestore.collection('products').get();

    return snapshot.docs.map((e) {
      final data = e.data();

      return ProductModel.fromMap(e.id, data);
    }).toList();
  }
}
