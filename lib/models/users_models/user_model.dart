
class UserModel {
  final String id;
  final String email;
  final String userType;

  UserModel({required this.id, required this.email, required this.userType});

  // Convert a UserModel into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'userType': userType,
    };
  }

  // Create a UserModel from a Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      userType: map['userType'],
    );
  }
}
