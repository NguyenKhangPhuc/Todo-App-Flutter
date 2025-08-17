class User {
  String? id;
  String username;
  String? password;
  
  User({this.id, required this.username, this.password});

  Map<String, dynamic> toJson(){
    return 
      {
        'username': username,
        'password': password,
      };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return (
      User(id: json['_id'], username: json['username'])
    );
  }
}