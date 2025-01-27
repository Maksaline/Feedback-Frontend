import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_provider_state.dart';

class AddProviderCubit extends Cubit<AddProviderState> {
  AddProviderCubit() : super(AddProviderInitial());
  final dio = Dio();
  void addProvider(String name, String type, String description, String userId, List<String> tags, List<String> online, List<String> social, double lat, double long) async {
    emit(AddProviderLoading());
    try {
      final response = await dio.post('http://localhost:3000/api/providers', data: {
        'name': name,
        'type': type,
        'description': description,
        'assigned_by': userId,
        'tags': tags,
        'online_handle': online,
        'social_handle': social,
        'positive': 1,
        'pos_voters': [userId],
        'location': {
          'longitude': long,
          'latitude': lat,
        },
      });
      if(response.statusCode == 200) {
        emit(AddProviderSuccess('Provider added successfully'));
      }
      else {
        emit(AddProviderFailure('Failed to add provider'));
      }
    } catch (e) {
      emit(AddProviderFailure(e.toString()));
    }
  }
}
