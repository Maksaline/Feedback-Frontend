part of 'reply_cubit.dart';

@immutable
sealed class ReplyState {}

final class ReplyInitial extends ReplyState {}

final class ReplySet extends ReplyState {
  final Feedbacks feedback;
  final String parentId;
  ReplySet(this.feedback, this.parentId);
}