class Provider{
  final String id;
  final String name;
  final String description;
  final String type;
  final String assignedBy;
  final int total;
  final int positive;
  final int negative;
  final List<double> location;
  final List<String> onlineHandles;
  final List<String> socialHandles;
  final DateTime createdAt;

  Provider({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.assignedBy,
    required this.total,
    required this.positive,
    required this.negative,
    required this.location,
    required this.onlineHandles,
    required this.socialHandles,
    required this.createdAt,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    List<double> locationList = [];
    locationList.add(json['location']['longitude']);
    locationList.add(json['location']['latitude']);

    String isoDate = json['createdAt'].toString().trim();
    DateTime date = DateTime.parse(isoDate);
    return Provider(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      assignedBy: json['assigned_by'],
      total: json['total_feedback'],
      positive: json['positive'],
      negative: json['negative'],
      location: locationList,
      onlineHandles: (json['online_handle'] as List<dynamic>).map((online) => online.toString()).toList(),
      socialHandles: (json['social_handle'] as List<dynamic>).map((social) => social.toString()).toList(),
      createdAt: date,
    );
  }
}

