class Provider{
  final String id;
  final String name;
  final String description;
  final String type;
  final String assignedBy;
  final int total;
  final int positive;
  final int negative;
  final List<String> posFeedbacks;
  final List<String> negFeedbacks;
  final List<double> location;
  final List<String> onlineHandles;
  final List<String> socialHandles;
  final String age;

  Provider({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.assignedBy,
    required this.total,
    required this.positive,
    required this.negative,
    required this.posFeedbacks,
    required this.negFeedbacks,
    required this.location,
    required this.onlineHandles,
    required this.socialHandles,
    required this.age,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    List<double> locationList = [];
    locationList.add(json['location']['longitude']);
    locationList.add(json['location']['latitude']);

    String isoDate = json['createdAt'].toString().trim();
    DateTime date = DateTime.parse(isoDate);

    final totalVotes = json['positive'] + json['negative'];

    final age = DateTime.now().difference(date);
    String ageString = '';
    if (age.inDays > 0) {
      ageString += '${age.inDays} days ';
    } else if (age.inHours > 0) {
      ageString = '${age.inHours} hours ';
    } else if (age.inMinutes > 0) {
      ageString = '${age.inMinutes} minutes ';
    } else {
      ageString = '${age.inSeconds} seconds ';
    }
    return Provider(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      assignedBy: json['assigned_by'],
      total: totalVotes,
      positive: json['positive'],
      negative: json['negative'],
      posFeedbacks: (json['pos_voters'] as List<dynamic>).map((pos) => pos.toString()).toList(),
      negFeedbacks: (json['neg_voters'] as List<dynamic>).map((neg) => neg.toString()).toList(),
      location: locationList,
      onlineHandles: (json['online_handle'] as List<dynamic>).map((online) => online.toString()).toList(),
      socialHandles: (json['social_handle'] as List<dynamic>).map((social) => social.toString()).toList(),
      age: ageString,
    );
  }
}

