import 'package:dartz/dartz.dart' as dartz;
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<dartz.Either<Failure, OrderEntity>> createOrder({
    required int annonceId,
    required int quantity,
    required String paymentMethod,
  }) async {
    try {
      final order = await remoteDataSource.createOrder(
        annonceId: annonceId,
        quantity: quantity,
        paymentMethod: paymentMethod,
      );
      return dartz.Right(order);
    } on DioException catch (e) {
      return dartz.Left(_handleDioError(e));
    } catch (e) {
      return dartz.Left(ServerFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<dartz.Either<Failure, OrderEntity>> payOrder(
      {required int orderId}) async {
    try {
      final order = await remoteDataSource.payOrder(orderId: orderId);
      return dartz.Right(order);
    } on DioException catch (e) {
      return dartz.Left(_handleDioError(e));
    } catch (e) {
      return dartz.Left(ServerFailure('Erreur inattendue: $e'));
    }
  }

  Future<dartz.Either<Failure, Map<String, dynamic>>> getOrderStatus(
      {required int orderId}) async {
    try {
      final status = await remoteDataSource.getOrderStatus(orderId: orderId);
      return dartz.Right(status);
    } on DioException catch (e) {
      return dartz.Left(_handleDioError(e));
    } catch (e) {
      return dartz.Left(ServerFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<dartz.Either<Failure, String>> initiatePaymentUrl({
    required int orderId,
    required String operator,
  }) async {
    try {
      final url = await remoteDataSource.initiatePaymentUrl(
        orderId: orderId,
        operator: operator,
      );
      return dartz.Right(url);
    } on DioException catch (e) {
      return dartz.Left(_handleDioError(e));
    } catch (e) {
      return dartz.Left(ServerFailure('Erreur inattendue: $e'));
    }
  }

  Failure _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure('Délai de connexion dépassé');
    }
    final message = error.response?.data['message'] ?? 'Erreur serveur';
    return ServerFailure(message);
  }
}
