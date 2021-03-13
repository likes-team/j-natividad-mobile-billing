import 'package:flutter/material.dart';
import 'package:jnb_mobile/modules/authentication/providers/user.dart';
import 'package:jnb_mobile/modules/profile/components/profile_template.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  final defaultPicture = 'assets/image/default-avatar.jpg';

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      return ProfileTemplate(
        firstname: userProvider.user.fname ?? 'fname',
        lastname: userProvider.user.lname ?? 'lname',
        username: userProvider.user.username ?? 'username',
        picturepath: defaultPicture,
      );
    });
  }
}
