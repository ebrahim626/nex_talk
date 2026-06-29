
class AuthRequestModel {
  final String? userName;
  final String email;
  final String password;

  AuthRequestModel({
    this.userName,
    required this.email,
    required this.password,
  });



  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    if(userName != null)
      'username': userName,
  };
}

