class ListParkingModel {
  int id;
  String name;
  String address;
  String description;
  double lat;
  double long;
  List<String> image;
  int slot;
  int max;
  int search_number;

  ListParkingModel({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.lat,
    required this.long,
    required this.image,
    required this.slot,
    required this.max,
    required this.search_number,
  });

  factory ListParkingModel.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['image'] != null) {
      images = List<String>.from(json['image']);
    }
    return ListParkingModel(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      address: json['address'],
      description: json['description'],
      lat: json['lat'].toDouble(),
      long: json['long'].toDouble(),
      image: images,
      slot: json['slot'],
      max: json['max'],
      search_number: json['search_number'],
    );
  }
}
