abstract class MatchEvent {}
class StartFindEvent extends MatchEvent {
  final String uid;
  StartFindEvent(this.uid);
}
class StopFindEvent extends MatchEvent {
  final String uid;
  StopFindEvent(this.uid);
}
class RoomFoundEvent extends MatchEvent{
  final String? roomId;
  RoomFoundEvent(this.roomId);
}