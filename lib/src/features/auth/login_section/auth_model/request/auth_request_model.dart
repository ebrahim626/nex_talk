
class AuthRequestModel {
  final String userName;
  final String email;
  final String password;

  AuthRequestModel({
    required this.userName,
    required this.email,
    required this.password,
  });



  Map<String, dynamic> toJson() => {
    'username': userName,
    'email': email,
    'password': password,
  };
}

