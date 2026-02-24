import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/errors/failures.dart';
import '../entities/order.dart';

abstract class OrderRepository {
  Future<dartz.Either<Failure, OrderEntity>> createOrder({
    required int annonceId,
    required int quantity,
    required String paymentMethod,
  });

  Future<dartz.Either<Failure, OrderEntity>> payOrder({required int orderId});
  Future<dartz.Either<Failure, String>> initiatePaymentUrl({
    required int orderId,
    required String operator,
  });
}
