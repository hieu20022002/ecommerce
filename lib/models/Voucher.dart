class Voucher {
  final String name;
  final String type;
  final DateTime validTill;
  final double minSpend;
  final double maxDiscount;
  final double discount;
  final String image; // New property to store image URL
  final int usageLimit; // New property to limit voucher usage

  Voucher({
    this.name = "",
    required this.type,
    required this.validTill,
    this.minSpend = 0.0,
    this.maxDiscount = double.infinity,
    this.discount = 0.0,
    this.image = "", // Initialize new property
    this.usageLimit = 1, // Initialize new property
  });

  factory Voucher.freeShipping({
    required String name,
    required DateTime validTill,
    double minSpend = 0.0,
    String image = "", // New parameter for image URL
    int usageLimit = 1, // New parameter for usage limit
  }) {
    return Voucher(
      name: name,
      type: 'FreeShipping',
      validTill: validTill,
      minSpend: minSpend,
      image: image, // Set new property
      usageLimit: usageLimit, // Set new property
    );
  }

  factory Voucher.discount({
    required String name,
    required DateTime validTill,
    double minSpend = 0.0,
    double maxDiscount = double.infinity,
    required double discount,
    String image = "", // New parameter for image URL
    int usageLimit = 1, // New parameter for usage limit
  }) {
    return Voucher(
      name: name,
      type: 'Discount',
      validTill: validTill,
      minSpend: minSpend,
      maxDiscount: maxDiscount,
      discount: discount,
      image: image, // Set new property
      usageLimit: usageLimit, // Set new property
    );
  }
}
