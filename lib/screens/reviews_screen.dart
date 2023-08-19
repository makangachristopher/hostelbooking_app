import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Review {
  final double rating;
  final String reviewText;

  Review({required this.rating, required this.reviewText});
}

List<Review> _reviews = []; // List to store reviews

class ReviewsScreen extends StatelessWidget {
  final String hostelName;

  ReviewsScreen({required this.hostelName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews for $hostelName'),
      ),
      body: ListView.builder(
        itemCount: _reviews.length,
        itemBuilder: (context, index) {
          Review review = _reviews[index];
          return ListTile(
            title: Text('Rating: ${review.rating}'),
            subtitle: Text(review.reviewText),
            trailing: Text(
                'User: John Doe'), // You can replace with actual user's name
          );
        },
      ),
    );
  }
}
