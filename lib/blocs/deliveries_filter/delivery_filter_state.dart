part of 'delivery_filter_cubit.dart';

class DeliveryFilterState extends Equatable {
  final String? selectedArea;
  final String? selectedSubArea;
  final List<SubArea>? subAreaList;
  final List<Area>? areaList;

  const DeliveryFilterState({this.selectedArea, this.selectedSubArea, this.subAreaList, this.areaList});

  DeliveryFilterState copyWith({
    String? selectedArea,
    String? selectedSubArea,
    List<SubArea>? subAreaList,
    List<Area>? areaList,
  }) {
    return DeliveryFilterState(
      selectedArea: selectedArea ?? this.selectedArea,
      selectedSubArea: selectedSubArea ?? this.selectedSubArea,
      subAreaList: subAreaList ?? this.subAreaList,
      areaList: areaList ?? this.areaList 
    );
  }

  @override
  List<Object?> get props => [
    selectedArea, 
    selectedSubArea,
    subAreaList,
    areaList
  ];
}
