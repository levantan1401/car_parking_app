class Place {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double long;
  final String image;

  Place({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.long,
    required this.image,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      lat: json['lat'].toDouble() ?? 0.0,
      long: json['long'].toDouble() ?? 0.0,
      image: json['image'] ?? '',
    );
  }
}