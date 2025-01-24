import 'package:dio/dio.dart';
import 'package:feedback/models/feedback_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackCubit extends Cubit<List<Feedbacks>> {
  FeedbackCubit() : super([]);
  final dio = Dio();

  void getFeedbacks(String id) async {
    final response = await dio.get('http://localhost:3000/api/feedbacks?to=$id');
    final responseData = response.data;
    if(responseData.isEmpty) {
      emit([]);
      return;
    }
    List<dynamic> jsonList = response.data;
    for(int i = 0; i < jsonList.length; i++) {
      final user = await dio.get('http://localhost:3000/api/users/${jsonList[i]['user']}');
      String name = user.data['name'];
      jsonList[i]['name'] = name;
    }
    List<Feedbacks> feedbacks = jsonList.map((e) => Feedbacks.fromJson(e)).toList();
    emit(feedbacks);
  }

  void giveVote(String id, String userId, bool isUpvote,  String parentId) async {
    final response = await dio.put('http://localhost:3000/api/feedbacks/vote/$id', data: {
      'userId': userId,
      'action': isUpvote ? 'upvote' : 'downvote',
    });
    if(response.statusCode == 200) {
      getFeedbacks(parentId);
    }
  }
}
