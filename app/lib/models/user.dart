class AppUser {
  final String id;
  final String username;
  final String name;
  final String email;
  final String role;

  AppUser({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.role,
  });

  AppUser copyWith({
    String? id,
    String? username,
    String? name,
    String? email,
    String? role,
  }) {
    return AppUser(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: (json['id'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "name": name,
      "email": email,
      "role": role,
    };
  }
}
