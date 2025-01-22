class Feedbacks {
  final String id;
  final String name;
  final String title;
  final String description;
  final bool isPositive;
  final String dp;
  final int upvotes;
  final int downvotes;
  final int comments;
  final String age;
  final List<String> upvoters;
  final List<String> downvoters;

  Feedbacks({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.isPositive,
    required this.dp,
    required this.upvotes,
    required this.downvotes,
    required this.comments,
    required this.age,
    required this.upvoters,
    required this.downvoters,
  });

  factory Feedbacks.fromJson(Map<String, dynamic> json, String name) {
    String isoDate = json['createdAt'].toString().trim();
    DateTime date = DateTime.parse(isoDate);
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
    return Feedbacks(
      id: json['_id'],
      name: name,
      title: json['title'],
      description: json['description'],
      isPositive: json['positive'],
      dp: 'default.png',
      upvotes: json['upvote'],
      downvotes: json['downvote'],
      comments: json['comments'],
      age: ageString,
      upvoters: (json['upvoters'] as List<dynamic>).map((pos) => pos.toString()).toList(),
      downvoters: (json['downvoters'] as List<dynamic>).map((pos) => pos.toString()).toList(),
    );
  }
}