class Group {
  Group({
    required this.id,
    required this.name,
    required this.promotionId,
    required this.users,
    required this.accessCode,
  });

  final int id;
  final String name;
  final int promotionId;
  final List<int> users;
  final String accessCode;

  factory Group.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'promotionId': int promotionId,
        'accessCode': String accessCode,
        'users': List<int> users,
      } =>
        Group(
          id: id,
          name: name,
          promotionId: promotionId,
          users: users,
          accessCode: accessCode,
        ),
      _ => throw const FormatException("Failed to load group"),
    };
  }
}
