import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../models/user_model.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  Future<void> signUp(String name, String profession, String username, String pass, DateTime dob, double lat, double long) async {
    emit(SignUpLoading());
    final  dio = Dio();
    try {
      final response = await dio.post('http://localhost:3000/api/users', data: {
        'name': name,
        'profession': profession,
        'username': username,
        'password': pass,
        'date_of_birth': dob.toIso8601String(),
        'location': {
          'latitude': lat,
          'longitude': long
        }
      });
      print(response.statusCode);
      if(response.statusCode == 200) {
        emit(SignUpSuccess('Sign Up successful'));
      } else {
        emit(SignUpFailure('Sign Up failed'));
      }
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }
}
