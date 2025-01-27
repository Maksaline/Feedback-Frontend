import 'package:dio/dio.dart';
import 'package:feedback/models/feedback_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserFeedbackCubit extends Cubit<List<Feedbacks>> {
  UserFeedbackCubit() : super([]);
  final dio = Dio();

  void getFeedbacks(String user) async {
    final response = await dio.get('http://localhost:3000/api/feedbacks/user/$user');
    final username = await dio.get('http://localhost:3000/api/users/$user');
    String name = username.data['name'];
    List<dynamic> jsonList = response.data;
    for(int i = 0; i < jsonList.length; i++) {
      jsonList[i]['name'] = name;
    }
    List<Feedbacks> providers = jsonList.map((e) => Feedbacks.fromJson(e)).toList();
    emit(providers);
  }
}