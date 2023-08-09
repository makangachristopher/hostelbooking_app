class User {
  final String uid;
  final String name;
  final String email;
  final String userType;
  final String profilePicture;
  final int phoneNumber;
  int? otherphoneNumber;
  String? location;
  String? hostelID;

  User(
      {required this.uid,
      required this.name,
      required this.email,
      required this.userType,
      required this.profilePicture,
      required this.phoneNumber});
}
