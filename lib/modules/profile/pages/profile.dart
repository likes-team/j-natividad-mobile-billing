import 'package:flutter/material.dart';
import 'package:jnb_mobile/modules/profile/components/profile_template.dart';

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
    return ProfileTemplate(
      firstname: 'Carlo',
      lastname: 'Dalisay',
      username: 'carlo.lang.malakas',
      picturepath: defaultPicture,
    );
  }
}
