class User {
  final int id;
  final String name;
  final String email;
  final String alamat;

  User({required this.id, required this.name, required this.email, required this.alamat});

  factory User.formJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      alamat: json['alamat'],
    );
  }
}
