import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:feedback/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class AuthCubit extends Cubit<LoginState> {
  AuthCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    final dio = Dio(
      BaseOptions(
        validateStatus: (status) {
          return status != null;
        },
      ),
    );
    emit(LoginLoading());
    try {
      await dio.post('http://localhost:3000/api/auth/login', data: {
        'username': email,
        'password': password,
      }).then((response) {
        if(response.statusCode == 200) {
          final user = User.fromJson(response.data);
          emit(LoginSuccess(user));
        }
        else if(response.statusCode == 401) {
          emit(LoginFailure('Invalid credentials'));
        }
        else {
          emit(LoginFailure('An error occurred'));
        }
      });
    } on DioException catch (e) {
      if (e.response != null) {
        emit(LoginFailure(e.toString()));
        switch (e.response?.statusCode) {
          case 400:
            print('Bad Request: ${e.response?.data}');
            break;
          case 500:
            print('Internal Server Error: ${e.response?.data}');
            break;
          default:
            print('Error ${e.response?.statusCode}: ${e.response?.data}');
        }
      } else {
        print('Request failed: ${e.message}');
      }
    } catch (e) {
      print('An error occurred: $e');
      emit(LoginFailure(e.toString()));
    }
  }

  void logout() {
    emit(LoginInitial());
  }
}