import 'package:dio/dio.dart';
import 'package:feedback/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<User?> {
  AuthCubit() : super(null);

  Future<void> login(String email, String password) async {
    final dio = Dio();
    try {
      dio.post('http://localhost:3000/api/auth/login', data: {
        'username': email,
        'password': password,
      }).then((response) {
        print(response.data);
        final user = User.fromJson(response.data);
        emit(user);
      });
    } on DioException catch (e) {
      if (e.response != null) {
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
        // No response received or another error occurred
        print('Request failed: ${e.message}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  void logout() {
    emit(null);
  }
}