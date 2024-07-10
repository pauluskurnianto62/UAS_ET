class User {
  final String uids;
  final String unames;
  final String upasswords;

  User({required this.uids, required this.unames, required this.upasswords });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
    uids: json['user_id'] as String,
    unames: json['user_name'] as String,
    upasswords: json['user_password'] as String,
    );
  }
}