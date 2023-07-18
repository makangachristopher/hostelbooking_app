class ReviewModel {
  final String reviewID;
  final String userID;
  final String hostelID;
  final double rating;
  final String comment;

  ReviewModel({
    required this.reviewID,
    required this.userID,
    required this.hostelID,
    required this.rating,
    required this.comment,
  });
}
