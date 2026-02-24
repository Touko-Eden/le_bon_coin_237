import 'package:flutter/material.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/core/network/dio_client.dart';
import 'package:secondmain_237/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:secondmain_237/features/orders/domain/entities/order.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  late final OrderRemoteDataSource _ds;
  late Future<List<OrderEntity>> _future;

  @override
  void initState() {
    super.initState();
    _ds = OrderRemoteDataSource(client: DioClient());
    _future = _load();
  }

  Future<List<OrderEntity>> _load() async {
    final res = await _ds.client.get('/orders/my');
    final list = (res.data['data'] as List<dynamic>? ?? []);
    return list.map((e) => OrderEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes commandes')),
      body: FutureBuilder<List<OrderEntity>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('Aucune commande'));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final o = items[index];
              return ListTile(
                title: Text(o.annonceTitle.isNotEmpty ? o.annonceTitle : 'Annonce #${o.annonceId}'),
                subtitle: Text('Réf: ${o.reference} • ${o.status.toUpperCase()}'),
                trailing: Text('${o.totalAmount.toStringAsFixed(0)} FCFA'),
              );
            },
          );
        },
      ),
    );
  }
}
