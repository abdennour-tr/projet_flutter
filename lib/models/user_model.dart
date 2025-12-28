class AppUser {
  final String id;
  final String name;
  final String email;
  final String password;
  final String image;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.image,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'image': image,
      };
}
