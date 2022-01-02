
import 'package:jnb_mobile/models/user_model.dart';
import 'package:jnb_mobile/utilities/shared_preference.dart';

class UserRepository {
  Future<User> getUser() async {
    final User user = await UserPreferences.getUser();

    if(user.id == null){
      return null;
    }

    return user;
  }
}
