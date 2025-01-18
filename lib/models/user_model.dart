class User {
  final String id;
  final String name;
  final String profession;
  final List<double> location;
  final DateTime dob;

  User({
    required this.id,
    required this.name,
    required this.profession,
    required this.location,
    required this.dob,
  });

  factory User.fromJson(Map<String, dynamic> res) {
    final json = res['user'];
    List<double> locationList = [];
    if(json['location'] == null) {
      locationList = [0.0, 0.0];
    }
    else {
      locationList.add(json['location']['longitude']);
      locationList.add(json['location']['latitude']);
    }

    String isoDate = json['date_of_birth'].toString();
    DateTime date = DateTime.parse(isoDate);
    return User(
      id: json['_id'],
      name: json['name'],
      profession: json['profession'],
      location: locationList,
      dob: date,
    );
  }
}