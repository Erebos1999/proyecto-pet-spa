import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/product_bloc.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();

    context.read<ProductBloc>().add(LoadProductsEvent());
  }

  void deleteProduct(String id) {
    showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: const Text('Eliminar producto'),

          content: const Text('¿Seguro que deseas eliminar este producto?'),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('Cancelar'),
            ),

            ElevatedButton(
              onPressed: () {
                context.read<ProductBloc>().add(DeleteProductEvent(id));

                Navigator.pop(context);
              },

              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fa),

      appBar: AppBar(title: const Text('Inventario')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/create-product');
        },

        child: const Icon(Icons.add),
      ),

      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductLoaded) {
            if (state.products.isEmpty) {
              return const Center(child: Text('No hay productos'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),

              itemCount: state.products.length,

              itemBuilder: (_, i) {
                final product = state.products[i];

                final lowStock = product.stock <= product.minimumStock;

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(24),
                  ),

                  child: ListTile(
                    contentPadding: const EdgeInsets.all(20),

                    leading: CircleAvatar(
                      backgroundColor: lowStock
                          ? Colors.red
                          : const Color(0xff66c7d8),

                      child: const Icon(Icons.inventory_2, color: Colors.white),
                    ),

                    title: Text(product.name),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const SizedBox(height: 6),

                        Text('Stock: ${product.stock}'),

                        Text('Venta: Bs ${product.salePrice}'),

                        if (lowStock)
                          const Padding(
                            padding: EdgeInsets.only(top: 6),

                            child: Text(
                              'Stock Bajo',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        IconButton(
                          onPressed: () {
                            context.push('/edit-product', extra: product);
                          },

                          icon: const Icon(Icons.edit),
                        ),

                        IconButton(
                          onPressed: () {
                            deleteProduct(product.id);
                          },

                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
