part of 'login_cubit.dart';

enum LoginStatus {
  loading,
  success,
  error
}

class LoginState extends Equatable {
  final LoginStatus status;
  final String statusMessage;

  const LoginState({this.status, this.statusMessage});

  LoginState copyWith({LoginStatus status, String statusMessage}) {
    return LoginState(
      status: status ?? this.status,
      statusMessage: statusMessage ?? this.statusMessage
    );
  }

  @override
  List<Object> get props => [status, statusMessage];
}
