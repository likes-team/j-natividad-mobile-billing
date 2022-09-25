import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jnb_mobile/models/areas.dart';
import 'package:jnb_mobile/models/sub_areas.dart';

part 'delivery_filter_state.dart';

class DeliveryFilterCubit extends Cubit<DeliveryFilterState> {
  DeliveryFilterCubit() : super(DeliveryFilterState());

  final String _areasBoxName = "sub_areas";

  void selectArea(String? area) {}

  void selectSubArea(String? subArea){}

}
