import 'package:cerberus_pet_spa/modules/inventory/domain/entities/product_entity.dart';
import 'package:cerberus_pet_spa/modules/inventory/presentation/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProductScreen extends StatefulWidget {
  final ProductEntity product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late final TextEditingController nameController;

  late final TextEditingController descriptionController;

  late final TextEditingController stockController;

  late final TextEditingController minimumStockController;

  late final TextEditingController purchasePriceController;

  late final TextEditingController salePriceController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.product.name);

    descriptionController = TextEditingController(
      text: widget.product.description,
    );

    stockController = TextEditingController(
      text: widget.product.stock.toString(),
    );

    minimumStockController = TextEditingController(
      text: widget.product.minimumStock.toString(),
    );

    purchasePriceController = TextEditingController(
      text: widget.product.purchasePrice.toString(),
    );

    salePriceController = TextEditingController(
      text: widget.product.salePrice.toString(),
    );
  }

  void save() {
    final updated = ProductEntity(
      id: widget.product.id,

      name: nameController.text,

      description: descriptionController.text,

      stock: int.parse(stockController.text),

      minimumStock: int.parse(minimumStockController.text),

      purchasePrice: double.parse(purchasePriceController.text),

      salePrice: double.parse(salePriceController.text),

      active: true,

      createdAt: widget.product.createdAt,
    );

    context.read<ProductBloc>().add(UpdateProductEvent(updated));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Producto')),

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

              decoration: const InputDecoration(labelText: 'Stock'),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: minimumStockController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: 'Stock mínimo'),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: purchasePriceController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: 'Precio compra'),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: salePriceController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: 'Precio venta'),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 55,

              child: ElevatedButton(
                onPressed: save,

                child: const Text('Guardar Cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
