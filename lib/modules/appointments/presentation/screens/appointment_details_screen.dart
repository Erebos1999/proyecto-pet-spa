import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cerberus_pet_spa/modules/auth/data/datasource/user_firestore_datasource.dart';

import '../../../notifications/data/datasource/lib/modules/notifications/data/datasource/emailjs_datasource.dart';
import '../../../notifications/data/datasource/lib/modules/notifications/data/datasource/notification_firestore_datasource.dart';
import '../../domain/entities/appointment_entity.dart';

import '../../../inventory/data/datasource/product_firestore_datasource.dart';
import '../../../inventory/data/models/product_model.dart';
import '../../../inventory/domain/entities/product_entity.dart';

import '../../data/datasource/appointment_firestore_datasource.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final AppointmentEntity appointment;

  const AppointmentDetailsScreen({super.key, required this.appointment});

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  late List<String> checklist;

  late List<String> requiredChecklist;

  final notesController = TextEditingController();

  final productDatasource = ProductFirestoreDatasource();

  final appointmentDatasource = AppointmentFirestoreDatasource();
  final notificationDatasource = NotificationFirestoreDatasource();

  final emailDatasource = EmailjsDatasource();
  final userDatasource = UserFirestoreDatasource();

  List<ProductEntity> products = [];

  bool loadingProducts = true;

  final Map<String, int> usedProducts = {};

  @override
  void initState() {
    super.initState();

    requiredChecklist = widget.appointment.services
        .map((e) => e['name'].toString())
        .toList();

    checklist = List.from(widget.appointment.completedChecklist);

    notesController.text = widget.appointment.notes;

    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final data = await productDatasource.getProducts();

      if (!mounted) return;

      setState(() {
        products = data.where((e) => e.active).toList();

        loadingProducts = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingProducts = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error cargando productos: $e')));
    }
  }

  bool get canCloseService {
    final allChecklistCompleted = requiredChecklist.every(
      (item) => checklist.contains(item),
    );

    final hasProducts = usedProducts.values.any((e) => e > 0);

    final invalidStock = products.any((product) {
      final qty = usedProducts[product.id] ?? 0;

      return qty > product.stock;
    });

    return allChecklistCompleted && hasProducts && !invalidStock;
  }

  void toggleItem(String item) {
    setState(() {
      if (checklist.contains(item)) {
        checklist.remove(item);
      } else {
        checklist.add(item);
      }
    });
  }

  Future<void> finalizeService() async {
    try {
      final used = <Map<String, dynamic>>[];

      for (final product in products) {
        final quantity = usedProducts[product.id] ?? 0;

        if (quantity <= 0) continue;

        if (quantity > product.stock) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Stock insuficiente en ${product.name}')),
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

        if (newStock <= product.minimumStock) {
          await notificationDatasource.createNotification(
            type: 'low_stock',
            title: 'Stock bajo',
            message: '${product.name} tiene stock bajo ($newStock)',
            productId: product.id,
          );

          final adminEmails = await userDatasource.getAdminEmails();

          for (final email in adminEmails) {
            await emailDatasource.sendEmail(
              toEmail: email,
              title: 'ALERTA STOCK BAJO',
              message:
                  'El producto ${product.name} tiene stock bajo.\n\nStock actual: $newStock\nStock mínimo: ${product.minimumStock}',
            );
          }
        }

        if (quantity >= 5) {
          await notificationDatasource.createNotification(
            type: 'high_consumption',

            title: 'Consumo elevado',

            message: 'Consumo elevado detectado en ${product.name}',

            productId: product.id,

            groomerId: widget.appointment.groomerId,
          );
        }

        used.add({
          'productId': product.id,
          'name': product.name,
          'quantity': quantity,
        });
      }

      await appointmentDatasource.finalizeAppointment(
        appointmentId: widget.appointment.id,
        checklist: checklist,
        usedProducts: used,
      );
      final ownerEmail = await userDatasource.getUserEmail(
        widget.appointment.ownerId,
      );

      if (ownerEmail != null && ownerEmail.isNotEmpty) {
        await emailDatasource.sendEmail(
          toEmail: ownerEmail,
          title: 'Mascota lista para recoger',
          message:
              'Hola ${widget.appointment.ownerName}, la mascota ${widget.appointment.petName} ya está lista para recoger.',
        );
      }
      await notificationDatasource.createNotification(
        type: 'pickup',

        title: 'Mascota lista',

        message: '${widget.appointment.petName} está listo para recoger',

        appointmentId: widget.appointment.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Servicio finalizado')));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error finalizando servicio: $e')));
    }
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;

    return Scaffold(
      backgroundColor: const Color(0xfff4f7fb),

      appBar: AppBar(title: const Text('Detalle Servicio')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: const Color(0xff66c7d8).withOpacity(0.15),

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: const Icon(
                          Icons.pets,
                          size: 40,
                          color: Color(0xff66c7d8),
                        ),
                      ),

                      const SizedBox(width: 18),

                      Expanded(
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

                            const SizedBox(height: 4),

                            Text(appointment.ownerName),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: infoCard(
                          'Inicio',
                          DateFormat('HH:mm').format(appointment.startTime),
                          Icons.schedule,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: infoCard(
                          'Fin',
                          DateFormat('HH:mm').format(appointment.endTime),
                          Icons.timer,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  infoCard(
                    'Groomer',
                    appointment.groomerName,
                    Icons.content_cut,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            sectionTitle('Servicios'),

            ...appointment.services.map((service) => serviceCard(service)),

            const SizedBox(height: 30),

            sectionTitle('Checklist Grooming'),

            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                children: requiredChecklist
                    .map(
                      (item) => CheckboxListTile(
                        value: checklist.contains(item),

                        title: Text(item),

                        activeColor: const Color(0xff66c7d8),

                        onChanged: (_) {
                          toggleItem(item);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 30),

            sectionTitle('Insumos utilizados'),

            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),

              child: loadingProducts
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: products.map((product) {
                        final quantity = usedProducts[product.id] ?? 0;

                        final invalid = quantity > product.stock;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 18),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          product.name,

                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text('Stock: ${product.stock}'),
                                      ],
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (quantity > 0) {
                                            setState(() {
                                              usedProducts[product.id] =
                                                  quantity - 1;
                                            });
                                          }
                                        },

                                        icon: const Icon(Icons.remove),
                                      ),

                                      Text(quantity.toString()),

                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            usedProducts[product.id] =
                                                quantity + 1;
                                          });
                                        },

                                        icon: const Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              if (invalid)
                                const Padding(
                                  padding: EdgeInsets.only(top: 6),

                                  child: Text(
                                    'Cantidad supera el stock',

                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),

            const SizedBox(height: 30),

            sectionTitle('Observaciones'),

            TextField(
              controller: notesController,

              maxLines: 5,

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                hintText: 'Agregar observaciones del servicio...',
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Total',

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        'Bs ${appointment.total.toStringAsFixed(2)}',

                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,

                          color: Color(0xff66c7d8),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,

                    height: 55,

                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canCloseService
                            ? const Color(0xff66c7d8)
                            : Colors.grey,
                      ),

                      onPressed: canCloseService ? finalizeService : null,

                      icon: const Icon(Icons.check),

                      label: Text(
                        canCloseService
                            ? 'Cerrar Servicio'
                            : 'Checklist incompleto',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget infoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        children: [
          Icon(icon, color: const Color(0xff66c7d8)),

          const SizedBox(height: 10),

          Text(title, style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 6),

          Text(
            value,
            textAlign: TextAlign.center,

            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget serviceCard(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: const Color(0xff66c7d8).withOpacity(0.12),

              borderRadius: BorderRadius.circular(18),
            ),

            child: const Icon(Icons.spa, color: Color(0xff66c7d8)),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  service['name'],

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text('${service['duration']} min'),
              ],
            ),
          ),

          Text(
            'Bs ${service['price']}',

            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
