import 'package:dio/dio.dart';
import 'package:secondmain_237/core/constants/api_constants.dart';
import 'package:secondmain_237/core/network/dio_client.dart';
import '../../domain/entities/order.dart';

class OrderRemoteDataSource {
  final DioClient client;

  OrderRemoteDataSource({required this.client});

  Future<OrderEntity> createOrder({
    required int annonceId,
    required int quantity,
    required String paymentMethod,
  }) async {
    final res = await client.post(
      ApiConstants.orders,
      data: {
        'annonceId': annonceId,
        'quantity': quantity,
        'paymentMethod': paymentMethod,
      },
    );
    return OrderEntity.fromJson(res.data);
  }

  Future<OrderEntity> payOrder({required int orderId}) async {
    final res = await client.post(ApiConstants.initiatePay(orderId));
    final redirectUrl =
        res.data['data']?['redirectUrl'] ?? res.data['redirect_url'];
    if (redirectUrl == null) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiConstants.initiatePay(orderId)),
        error: 'URL de paiement introuvable',
      );
    }
    // Retourner l'ordre actuel (lancement du paiement côté navigateur)
    final orderRes = await client.get(ApiConstants.orderById(orderId));
    return OrderEntity.fromJson(orderRes.data);
  }

  Future<Map<String, dynamic>> getOrderStatus({required int orderId}) async {
    final res = await client.get(ApiConstants.orderStatus(orderId));
    return res.data['data'] ?? {};
  }

  Future<String> initiatePaymentUrl(
      {required int orderId, required String operator}) async {
    final res = await client.post(
      ApiConstants.initiatePay(orderId),
      data: {'operator': operator},
    );
    final redirectUrl = res.data['data']?['redirectUrl'] ??
        res.data['redirect_url'] ??
        res.data['url'];
    if (redirectUrl == null) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiConstants.initiatePay(orderId)),
        error: 'URL de paiement introuvable',
      );
    }
    return redirectUrl;
  }
}
