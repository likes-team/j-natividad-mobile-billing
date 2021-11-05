import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jnb_mobile/modules/authentication/models/user.dart';
import 'package:jnb_mobile/repositories/user_repository.dart';
import 'package:jnb_mobile/utilities/shared_preference.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserRepository _userRepository;
  final UserPreferences _userPreferences = UserPreferences();

  LoginCubit({UserRepository userRepository}) :
    _userRepository = userRepository,
    super(LoginState());

  Future<void> login({@required String username, @required String password}) async{
    emit(state.copyWith(status: LoginStatus.loading));

    if(username == '' || password == ''){
      emit(state.copyWith(status: LoginStatus.error, statusMessage: "Please complete required fields to continue"));
    }

    try{
      await _userRepository.login(username, password);

      
    } catch(err){
      emit(state.copyWith(status: LoginStatus.error));
    }
  }
}
