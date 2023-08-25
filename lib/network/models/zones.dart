import 'package:json_annotation/json_annotation.dart';

part 'zones.g.dart';

@JsonSerializable()
class Zones {
  final String name;
  bool active;

  Zones({required this.name, required this.active});

  factory Zones.fromJson(Map<String, dynamic> json) => _$ZonesFromJson(json);

  Map<String, dynamic> toJson() => _$ZonesToJson(this);
}
