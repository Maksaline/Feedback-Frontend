import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/feedback_model.dart';

part 'reply_state.dart';

class ReplyCubit extends Cubit<ReplyState> {
  ReplyCubit() : super(ReplyInitial());

  void setFeedback(Feedbacks feedback, String parentId) {
    emit(ReplySet(feedback, parentId));
  }

  void clearFeedback() {
    emit(ReplyInitial());
  }
}
