import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'deliver_state.dart';

class DeliverCubit extends Cubit<DeliverState> {
  DeliverCubit() : super(DeliverInitial());
}
