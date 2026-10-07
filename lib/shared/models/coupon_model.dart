class CouponModel {
  final String code;
  final String title;
  final String description;
  final double discountPercent;
  final double maxDiscountAmount;
  final double minOrderAmount;
  final String expiryDate;
  final bool isApplied;

  const CouponModel({
    required this.code,
    required this.title,
    required this.description,
    required this.discountPercent,
    required this.maxDiscountAmount,
    required this.minOrderAmount,
    required this.expiryDate,
    this.isApplied = false,
  });

  double calculateSavings(double subtotal) {
    if (subtotal < minOrderAmount) return 0.0;
    double rawDiscount = (subtotal * discountPercent) / 100;
    return rawDiscount > maxDiscountAmount ? maxDiscountAmount : rawDiscount;
  }
}
