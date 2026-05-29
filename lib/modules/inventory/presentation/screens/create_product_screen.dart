import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product_entity.dart';
import '../bloc/product_bloc.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final nameController = TextEditingController();

  final descriptionController = TextEditingController();

  final stockController = TextEditingController();

  final minimumStockController = TextEditingController();

  final purchasePriceController = TextEditingController();

  final salePriceController = TextEditingController();

  void save() {
    final product = ProductEntity(
      id: '',

      name: nameController.text,

      description: descriptionController.text,

      stock: int.parse(stockController.text),

      minimumStock: int.parse(minimumStockController.text),

      purchasePrice: double.parse(purchasePriceController.text),

      salePrice: double.parse(salePriceController.text),

      active: true,

      createdAt: DateTime.now(),
    );

    context.read<ProductBloc>().add(CreateProductEvent(product));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Producto')),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: ListView(
          children: [
            TextField(
              controller: nameController,

              decoration: const InputDecoration(labelText: 'Nombre'),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: descriptionController,

              maxLines: 3,

              decoration: const InputDecoration(labelText: 'Descripción'),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: stockController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: 'Stock Actual'),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: minimumStockController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: 'Stock Mínimo'),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: purchasePriceController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: 'Precio Compra'),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: salePriceController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: 'Precio Venta'),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 55,

              child: ElevatedButton(
                onPressed: save,

                child: const Text('Guardar Producto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
