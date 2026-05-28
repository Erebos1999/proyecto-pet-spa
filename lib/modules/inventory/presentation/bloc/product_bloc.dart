import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/datasource/product_firestore_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product_entity.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc
    extends Bloc<ProductEvent, ProductState> {
  final repository = ProductRepositoryImpl(
    ProductFirestoreDatasource(),
  );

  ProductBloc() : super(ProductInitial()) {
    on<LoadProductsEvent>(_loadProducts);

    on<CreateProductEvent>(_createProduct);

    on<UpdateProductEvent>(_updateProduct);

    on<DeleteProductEvent>(_deleteProduct);
  }

  Future<void> _loadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());

      final products =
          await repository.getProducts();

      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _createProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      await repository.createProduct(
        event.product,
      );

      add(LoadProductsEvent());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _updateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      await repository.updateProduct(
        event.product,
      );

      add(LoadProductsEvent());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _deleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      await repository.deleteProduct(
        event.id,
      );

      add(LoadProductsEvent());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}