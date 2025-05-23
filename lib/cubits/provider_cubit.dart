import 'package:dio/dio.dart';
import 'package:feedback/models/provider_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderCubit extends Cubit<List<Provider>> {
  ProviderCubit() : super([]);
  final dio = Dio();

  void getProviders() async {
    final response = await dio.get('http://localhost:3000/api/providers');
    List<dynamic> jsonList = response.data;
    List<Provider> providers = jsonList.map((e) => Provider.fromJson(e)).toList();
    emit(providers);
  }

  void updateVotes(String id, String userId, bool isPositive) async {
    final response = await dio.put('http://localhost:3000/api/providers/vote/$id', data: {
      'userId': userId,
      'action': isPositive ? 'upvote' : 'downvote',
    });
    getProviders();
  }

  void addProvider(String name, String description) async {
    final response = await dio.post('http://localhost:3000/api/providers', data: {
      'name': name,
      'description': description,
    });
    getProviders();
  }

  void searchProviders(String query) async {
    final response = await dio.get('http://localhost:3000/api/providers/search?keyword=$query');
    List<dynamic> jsonList = response.data;
    List<Provider> providers = jsonList.map((e) => Provider.fromJson(e)).toList();
    emit(providers);
  }
}