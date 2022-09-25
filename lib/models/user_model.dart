import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String? username;
  final String? fname;
  final String? lname;
  final String? email;
  final String? phone;

  const User({
    this.id,
    this.username,
    this.fname,
    this.lname,
    this.email,
    this.phone,
  });

  static const empty = User();

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
      id: responseData['_id'],
      username: responseData['username'],
      fname: responseData['fname'],
      lname: responseData['lname'],
      email: responseData['email'],
      phone: responseData['phone'],
    );
  }
  
  @override
  List<Object?> get props => [id];
}
