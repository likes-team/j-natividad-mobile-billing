
import 'package:jnb_mobile/models/user_model.dart';
import 'package:jnb_mobile/services/user_service.dart';

class UserRepository {
  Future<User?> getUser() async {
    final User user = await UserService.getUser();

    if(user.id == null){
      return null;
    }

    return user;
  }
}
