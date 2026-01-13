class LostFoundItem {
  final int id;
  final String type;
  final String title;
  final String description;
  final String location;
  final String contact;
  final String status;
  final String createdAt;

  LostFoundItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.location,
    required this.contact,
    required this.status,
    required this.createdAt,
  });

  factory LostFoundItem.fromJson(Map<String, dynamic> json) {
    return LostFoundItem(
      id: int.parse(json['id'].toString()),
      type: (json['type'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      location: (json['location'] ?? '').toString(),
      contact: (json['contact'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      createdAt: (json['created_at'] ?? '').toString(),
    );
  }
}
