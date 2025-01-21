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
    final userId = responseData[0]['user'];
    final user = await dio.get('http://localhost:3000/api/users/$userId');
    String name = user.data['name'];
    List<dynamic> jsonList = response.data;
    List<Feedbacks> feedbacks = jsonList.map((e) => Feedbacks.fromJson(e, name)).toList();
    emit(feedbacks);
  }
}
