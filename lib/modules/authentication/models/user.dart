class User {
  int userID;
  String username;
  String fname;
  String lname;
  String email;
  String phone;

  User({
    this.userID,
    this.username,
    this.fname,
    this.lname,
    this.email,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
      userID: responseData['id'],
      username: responseData['username'],
      fname: responseData['fname'],
      lname: responseData['lname'],
      email: responseData['email'],
      phone: responseData['phone'],
    );
  }
}
