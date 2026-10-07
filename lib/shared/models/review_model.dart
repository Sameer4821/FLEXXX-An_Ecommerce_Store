class ReviewModel {
  final String id;
  final String userName;
  final String userAvatar;
  final double rating;
  final String date;
  final String title;
  final String comment;
  final bool verifiedPurchase;
  final List<String> photoUrls;
  final int helpfulCount;

  const ReviewModel({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.date,
    required this.title,
    required this.comment,
    this.verifiedPurchase = true,
    this.photoUrls = const [],
    this.helpfulCount = 0,
  });
}
