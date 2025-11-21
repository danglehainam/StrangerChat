abstract class MatchState {}

class MatchInitial extends MatchState {}
class MatchLoading extends MatchState {}
class MatchWaiting extends MatchState {}
class MatchFound extends MatchState {
  final String roomId;
  MatchFound(this.roomId);
}
class MatchError extends MatchState {
  final String message;
  MatchError(this.message);
}