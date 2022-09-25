import 'package:hive/hive.dart';
import 'package:jnb_mobile/models/sub_areas.dart';

part 'areas.g.dart';

@HiveType(typeId: 2)
class Area {
  @HiveField(0)
  final String? areaID;

  @HiveField(1)
  final String? areaName;

  @HiveField(2)
  final String? areaDescription;

  @HiveField(3)
  final List<SubArea>? subAreas;

  Area({
    this.areaID,
    this.areaName,
    this.areaDescription,
    this.subAreas,
  });
}
