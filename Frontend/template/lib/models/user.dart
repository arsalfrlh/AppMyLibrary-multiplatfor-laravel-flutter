class User {
  final int id;
  final String name;
  final String alamat;
  final String email;

  User({required this.id, required this.name, required this.alamat, required this.email});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      name: json['name'],
      alamat: json['alamat'],
      email: json['email'],
    );
  }
}
