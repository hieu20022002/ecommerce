import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/Voucher.dart';

class VoucherScreen extends StatefulWidget {
  final Function(Voucher?) onVoucherSelected;

  VoucherScreen({required this.onVoucherSelected});

  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  int _shippingSelectedIndex = -1;
  int _discountSelectedIndex = -1;
  Voucher? _selectedShippingVoucher;
  Voucher? _selectedDiscountVoucher;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Create a list of vouchers
    final vouchers = [
      Voucher.freeShipping(
        name: 'Free Shipping ',
        validTill: DateTime.now().add(Duration(days: 7)),
        minSpend: 50000.0,
        image: 'assets/images/free_ship.jpg',
        usageLimit: 1,
      ),
      Voucher.freeShipping(
        name: 'Free Shipping',
        validTill: DateTime.now().add(Duration(days: 7)),
        minSpend: 50000.0,
        image: 'assets/images/free_ship.jpg',
        usageLimit: 1,
      ),
      Voucher.discount(
        name: '10% Off',
        validTill: DateTime.now().add(Duration(days: 7)),
        minSpend: 100000.0,
        maxDiscount: 20.0,
        discount: 10.0,
        image: 'assets/images/thoi_trang_voucher.jpg', // Set asset name
        usageLimit: 1,
      ),
    ];

    List<Voucher> shippingVouchers = vouchers
        .where((voucher) =>
            voucher.type == 'FreeShipping' &&
            voucher.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    List<Voucher> discountVouchers = vouchers
        .where((voucher) =>
            voucher.type == 'Discount' &&
            voucher.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Voucher',
          style: TextStyle(color: Colors.deepOrangeAccent),
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: 48),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'Shipping Voucher',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                  child: Text('1 voucher can be selected'),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final voucher = shippingVouchers[index];
                    bool isSelected = index == _shippingSelectedIndex;
                    return buildVoucherCard(
                      voucher: voucher,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _shippingSelectedIndex = isSelected ? -1 : index;
                          _selectedShippingVoucher =
                              isSelected ? null : voucher;
                        });
                        widget.onVoucherSelected(_selectedShippingVoucher);
                      },
                    );
                  },
                  childCount: shippingVouchers.length,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'Discount Voucher',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                  child: Text('1 voucher can be selected'),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final voucher = discountVouchers[index];
                    bool isSelected = index == _discountSelectedIndex;
                    return buildVoucherCard(
                      voucher: voucher,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _discountSelectedIndex = isSelected ? -1 : index;
                          _selectedDiscountVoucher =
                              isSelected ? null : voucher;
                        });
                        widget.onVoucherSelected(_selectedDiscountVoucher);
                      },
                    );
                  },
                  childCount: discountVouchers.length,
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter voucher code',
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      print('Search query: $_searchQuery');
                    },
                    child: Text('Apply'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVoucherCard({
    required Voucher voucher,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ), // Set shape of card to rectangle with no rounded corners
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Image.asset(
              voucher.image,
              width: 110,
            ), // Set width of image to make it larger
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    voucher.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // Set font weight to bold
                  Text(
                    NumberFormat('#,###', 'vi_VN').format(voucher.minSpend) +
                        "\₫",
                  ), // Display minimum spend
                  if (voucher.type == 'discount')
                    Text(
                        'Discount: ${voucher.discount}%'), // Display discount percentage
                  Text(
                      'Valid Till: ${DateFormat.yMMMd().format(voucher.validTill)}'),
                ],
              ),
            ),
            Theme(
              data: ThemeData(
                unselectedWidgetColor:
                    Colors.grey, // Set color for unselected checkbox
              ),
              child: Checkbox(
                value: isSelected,
                onChanged: (_) => onTap(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      8.0), // Set border radius for checkbox
                ),
                checkColor: Colors.white, // Set color for check icon
                activeColor:
                    Colors.deepOrangeAccent, // Set color for selected checkbox
              ),
            ),
          ],
        ),
      ),
    );
  }
}
