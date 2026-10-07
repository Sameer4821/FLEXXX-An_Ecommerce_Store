class SellerModel {
  final String id;
  final String name;
  final double rating;
  final int totalSales;
  final String responseRate;
  final String returnPolicy;
  final bool isVerified;
  final String avatarUrl;

  const SellerModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.totalSales,
    required this.responseRate,
    required this.returnPolicy,
    this.isVerified = true,
    required this.avatarUrl,
  });
}
