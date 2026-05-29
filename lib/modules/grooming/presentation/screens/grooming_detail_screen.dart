import 'package:cerberus_pet_spa/modules/inventory/data/models/product_model.dart';
import 'package:flutter/material.dart';

import '../../../appointments/data/datasource/appointment_firestore_datasource.dart';

import '../../../appointments/domain/entities/appointment_entity.dart';

import '../../../inventory/data/datasource/product_firestore_datasource.dart';

import '../../../inventory/domain/entities/product_entity.dart';

class GroomingDetailScreen extends StatefulWidget {
  final AppointmentEntity appointment;

  const GroomingDetailScreen({super.key, required this.appointment});

  @override
  State<GroomingDetailScreen> createState() => _GroomingDetailScreenState();
}

class _GroomingDetailScreenState extends State<GroomingDetailScreen> {
  final appointmentDatasource = AppointmentFirestoreDatasource();

  final productDatasource = ProductFirestoreDatasource();

  List<ProductEntity> products = [];

  bool loading = true;

  final Map<String, bool> checklist = {
    'Baño completo': false,
    'Limpieza de oídos': false,
    'Corte de uñas': false,
    'Secado': false,
    'Perfume': false,
  };

  final Map<String, int> usedProducts = {};

  @override
  void initState() {
    super.initState();

    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final data = await productDatasource.getProducts();
      debugPrint('Productos cargados: ${data.length}');

      for (final p in data) {
        debugPrint('PRODUCTO => ${p.name} | stock: ${p.stock}');
      }

      if (!mounted) return;

      setState(() {
        products = data;
        loading = false;
      });
    } catch (e, st) {
      // Evitar que la pantalla se quede en loading indefinidamente y mostrar error
      print('Error cargando productos: $e');
      print(st);

      if (!mounted) return;

      setState(() {
        products = [];
        loading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error cargando insumos: $e')));
    }
  }

  Future<void> finalizeService() async {
    final completed = checklist.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    final hasChecklist = completed.isNotEmpty;

    final hasUsedProducts = usedProducts.values.any((quantity) => quantity > 0);

    if (!hasChecklist) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe marcar al menos un item del checklist'),
        ),
      );

      return;
    }

    if (!hasUsedProducts) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe registrar al menos un insumo utilizado'),
        ),
      );

      return;
    }

    final used = <Map<String, dynamic>>[];

    for (final product in products) {
      final quantity = (usedProducts[product.id] ?? 0).clamp(0, 999);

      if (quantity > 0) {
        if (quantity > product.stock) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cantidad mayor al stock en ${product.name}'),
            ),
          );

          return;
        }

        final newStock = product.stock - quantity;

        await productDatasource.updateProduct(
          ProductModel(
            id: product.id,
            name: product.name,
            description: product.description,
            stock: newStock,
            minimumStock: product.minimumStock,
            purchasePrice: product.purchasePrice,
            salePrice: product.salePrice,
            active: product.active,
            createdAt: product.createdAt,
          ),
        );

        used.add({
          'productId': product.id,
          'name': product.name,
          'quantity': quantity,
        });
      }
    }

    await appointmentDatasource.finalizeAppointment(
      appointmentId: widget.appointment.id,
      checklist: completed,
      usedProducts: used,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Servicio finalizado')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;

    return Scaffold(
      appBar: AppBar(title: const Text('Ficha Grooming')),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),

              children: [
                Container(
                  padding: const EdgeInsets.all(22),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(24),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        appointment.petName,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text('Cliente: ${appointment.ownerName}'),

                      Text('Estado: ${appointment.status}'),

                      Text('Duración: ${appointment.durationMinutes} min'),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Servicios',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                ...appointment.services.map(
                  (service) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.spa, color: Color(0xff66c7d8)),

                      title: Text(service['name']),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Checklist Grooming',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                ...checklist.keys.map(
                  (item) => CheckboxListTile(
                    value: checklist[item],

                    onChanged: (value) {
                      setState(() {
                        checklist[item] = value ?? false;
                      });
                    },

                    title: Text(item),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Insumos usados',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                ...products.map((product) {
                  final quantity = usedProducts[product.id] ?? 0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(22),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Stock actual: ${product.stock}',
                              style: TextStyle(
                                color: product.stock <= product.minimumStock
                                    ? Colors.red
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            if (quantity > product.stock)
                              const Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Text(
                                  'Cantidad superior al stock',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (quantity > 0) {
                                  setState(() {
                                    usedProducts[product.id] = quantity - 1;
                                  });
                                }
                              },

                              icon: const Icon(Icons.remove),
                            ),

                            Text(quantity.toString()),

                            IconButton(
                              onPressed: () {
                                if (quantity >= product.stock) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'No hay suficiente stock de ${product.name}',
                                      ),
                                    ),
                                  );

                                  return;
                                }

                                setState(() {
                                  usedProducts[product.id] = quantity + 1;
                                });
                              },

                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 35),

                SizedBox(
                  height: 55,

                  child: ElevatedButton(
                    onPressed: finalizeService,

                    child: const Text('Finalizar Servicio'),
                  ),
                ),
              ],
            ),
    );
  }
}
