class BookingModel {
  final String bookingID;
  final String userID;
  final String hostelID;
  List<DateTime> bookingDates;
  Map<String, dynamic> paymentDetails;
  String status;

  BookingModel({

    required this.bookingID,
    required this.userID,
    required this.hostelID,
    required this.bookingDates,
    required this.paymentDetails,
    required this.status

  });
}
