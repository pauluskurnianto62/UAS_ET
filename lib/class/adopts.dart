class Adopts {
  int id;
  int ids;
  String names;
  String types;
  String descriptions;
  String images;
  String status;
  String selectedUserName;
  String ownerName;
  int userCount;
  List<UserList> userlist;

  Adopts({
    required this.id,
    required this.ids,
    required this.names,
    required this.types,
    required this.descriptions,
    required this.images,
    required this.status,
    required this.userCount,
    required this.selectedUserName,
    required this.ownerName,
    required this.userlist,
  });

  factory Adopts.fromJson(Map<String, dynamic> json) {
    var userlistFromJson = json['userlist'] as List;
    List<UserList> userlistParsed =
        userlistFromJson.map((user) => UserList.fromJson(user)).toList();

    return Adopts(
      id: json['id'] ?? 0,
      ids: json['id'] ?? 0,
      names: json['name'] as String,
      types: json['type'] as String,
      descriptions: json['description'] as String,
      images: json['image'] as String,
      status: json['status'] as String,
      userCount: json['user_count'] ?? 0,
      selectedUserName: json['selected_user_name'] ?? "",
      ownerName: json['owner_name'] ?? "",
      userlist: userlistParsed,
    );
  }
}

class UserList {
  int id;
  int adoptId;
  int userId;
  String name;
  String description;

  UserList({
    required this.id,
    required this.adoptId,
    required this.userId,
    required this.name,
    required this.description,
  });

  factory UserList.fromJson(Map<String, dynamic> json) {
    return UserList(
      id: json['id'] ?? 0,
      adoptId: json['adopt_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['owner_name'] ?? "",
      description: json['description'] ?? "",
    );
  }
}
