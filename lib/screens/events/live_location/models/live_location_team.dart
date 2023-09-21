import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:latlong2/latlong.dart';

class LiveLocationTeam {
  final Team team;
  final LatLng? location;

  LiveLocationTeam({required this.team, this.location});
}