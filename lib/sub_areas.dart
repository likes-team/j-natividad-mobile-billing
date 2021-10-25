import 'package:hive/hive.dart';

part 'sub_areas.g.dart';

@HiveType(typeId: 3)
class SubArea {
  @HiveField(0)
  final String subAreaID;

  @HiveField(1)
  final String subAreaName;

  @HiveField(2)
  final String subAreaDescription;

  SubArea({
    this.subAreaID,
    this.subAreaName,
    this.subAreaDescription,
  });
}
