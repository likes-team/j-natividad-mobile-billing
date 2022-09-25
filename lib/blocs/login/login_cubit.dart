import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jnb_mobile/models/user_model.dart';
import 'package:jnb_mobile/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginCubit({required AuthenticationRepository authenticationRepository}) :
    _authenticationRepository = authenticationRepository,
    super(LoginState());

  Future<void> login({required String username, required String password}) async{
    emit(state.copyWith(status: LoginStatus.loading));

    if(username == '' || password == ''){
      emit(state.copyWith(status: LoginStatus.error, statusMessage: "Please complete required fields to continue"));
    }

    try{
      await _authenticationRepository.login(username, password);
      emit(state.copyWith(status: LoginStatus.success, statusMessage: "Success"));
    } catch(err){
      print(err);
      emit(state.copyWith(status: LoginStatus.error, statusMessage: err.toString()));
    }
  }
}
