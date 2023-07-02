import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce/models/Voucher.dart';

class OrderDetails extends StatelessWidget {
  final double merchandiseSubtotal;
  final double shippingSubtotal;
  final Voucher? selectedDiscountVoucher;
  final Voucher? selectedShippingVoucher;

  OrderDetails({
    required this.merchandiseSubtotal,
    required this.shippingSubtotal,
    required this.selectedDiscountVoucher,
    required this.selectedShippingVoucher,
  });

  double calculateTotalPayment() {
    double total = merchandiseSubtotal + shippingSubtotal;
    double shippingDiscountSubtotal;

    // Áp dụng chiết khấu từ Voucher giảm giá sản phẩm nếu có
    if (selectedDiscountVoucher != null) {
      //nếu có mã free ship thì cho trừ đúng bằng khoảng giá ship lun
      total -= merchandiseSubtotal * selectedDiscountVoucher!.discount / 100;
    }

    // Áp dụng chiết khấu từ Voucher giảm giá vận chuyển nếu có
    if (selectedShippingVoucher != null) {
      total -= shippingSubtotal;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    double updatedTotalPayment = calculateTotalPayment();

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.payment),
              SizedBox(width: 8),
              Text('Payment Details'),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Merchandise Subtotal'),
              Text(NumberFormat('#,###', 'vi_VN').format(merchandiseSubtotal) +
                  '₫'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shipping Subtotal'),
              Text(NumberFormat('#,###', 'vi_VN').format(shippingSubtotal) +
                  '₫'),
            ],
          ),
          if (selectedDiscountVoucher != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Discount from Product Voucher'),
                Text(NumberFormat('-#,###', 'vi_VN').format(
                        merchandiseSubtotal *
                            selectedDiscountVoucher!.discount /
                            100) +
                    '₫'),
              ],
            ),
          if (selectedShippingVoucher != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Discount from Shipping Voucher'),
                Text(NumberFormat('-#,###', 'vi_VN').format(shippingSubtotal) +
                    '₫'),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Payment',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                  NumberFormat('#,###', 'vi_VN').format(updatedTotalPayment) +
                      '₫',
                  style: TextStyle(color: Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }
}
