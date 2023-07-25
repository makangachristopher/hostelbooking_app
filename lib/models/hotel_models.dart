class HostelModel {
  final String hostelID;
  final String name;
  final String imageUrl;
  final List<String> relatedImagesUrls;
  final int price;
  final String university;
  final String location;
  final String description;
  final List<String> amenities;
  final String contactDetails;
  final bool doubleRoomsAvailability;
  final bool singleRoomsAvailability;

  HostelModel(
      {required this.hostelID,
      required this.name,
      required this.imageUrl,
      required this.relatedImagesUrls,
      required this.price,
      required this.university,
      required this.location,
      required this.description,
      required this.amenities,
      required this.contactDetails,
      required this.doubleRoomsAvailability,
      required this.singleRoomsAvailability});
}
