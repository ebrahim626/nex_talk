class AuthResponseModel {
  final String token;
  final String username;
  final String email;
  final String userId;

  AuthResponseModel({
    required this.token,
    required this.username,
    required this.email,
    required this.userId,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
    'username': username,
    'email': email,
    'userId': userId,
  };
}

