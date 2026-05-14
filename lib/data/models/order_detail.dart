class OrderDetail {
  int? id;
  int? paymentOrderCode;
  String? name;
  String? voucherCode;
  DateTime? paidAt;
  int? totalAmount;

  OrderDetail({
    this.id,
    this.paymentOrderCode,
    this.name,
    this.voucherCode,
    this.paidAt,
    this.totalAmount,
  });

  factory OrderDetail.fromMap(
    Map<String, dynamic> map,
  ) {
    return OrderDetail(
      id: map['order_id'],
      paymentOrderCode: map['payment_order_code'],
      name: map['guest_name'],
      voucherCode: map['voucher_code'],
      paidAt: map['paid_at'] != null
          ? DateTime.parse(map['paid_at'])
          : null,
      totalAmount: map['total_amount'],
    );
  }
}