class OrderEntity {
  final int id;
  final String reference;
  final String status;
  final String paymentMethod;
  final int quantity;
  final double totalAmount;
  final int annonceId;
  final String annonceTitle;
  final double annoncePrice;

  OrderEntity({
    required this.id,
    required this.reference,
    required this.status,
    required this.paymentMethod,
    required this.quantity,
    required this.totalAmount,
    required this.annonceId,
    required this.annonceTitle,
    required this.annoncePrice,
  });

  factory OrderEntity.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final annonce = data['annonce'] ?? {};
    return OrderEntity(
      id: data['id'],
      reference: data['reference'],
      status: data['status'],
      paymentMethod: data['paymentMethod'],
      quantity: data['quantity'],
      totalAmount: (data['totalAmount'] is String)
          ? double.tryParse(data['totalAmount']) ?? 0
          : (data['totalAmount'] as num).toDouble(),
      annonceId: annonce['id'] ?? 0,
      annonceTitle: annonce['title'] ?? '',
      annoncePrice: (annonce['price'] is String)
          ? double.tryParse(annonce['price']) ?? 0
          : (annonce['price'] as num?)?.toDouble() ?? 0,
    );
  }
}
