class Station {
  int id;
  String name;
  String address;
  double lat;
  double long;
  String image;
  int slot;
  int max;

  Station({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.long,
    required this.image,
    required this.slot,
    required this.max,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      lat: json['lat'].toDouble(),
      long: json['long'].toDouble(),
      image: json['image'],
      slot: json['slot'],
      max: json['max'],
    );
  }
}
