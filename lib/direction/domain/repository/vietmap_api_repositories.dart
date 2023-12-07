import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:giuaki_map_location/direction/data/models/vietmap_autocomplete_model.dart';
import 'package:giuaki_map_location/direction/data/models/vietmap_place_model.dart';
import 'package:giuaki_map_location/direction/data/models/vietmap_reverse_model.dart';
import 'package:giuaki_map_location/direction/data/repository/vietmap_api_repository.dart';

import '../../core/failures/api_server_failure.dart';
import '../../core/failures/api_timeout_failure.dart';
import '../../core/failures/exception_failure.dart';
import '../../core/failures/failure.dart';

class VietmapApiRepositories implements VietmapApiRepository {
  late Dio _dio;
  String baseUrl = 'https://maps.vietmap.vn/api/';
  String apiKey = '777b35f3007879162b289a527ef7974f7f86255ea1e4504f';
  VietmapApiRepositories() {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));

    if (kDebugMode) {
      // ignore: deprecated_member_use
      (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
  }

  @override
  Future<Either<Failure, VietmapReverseModel>> getLocationFromLatLng(
      {required double lat, required double long}) async {
    try {
      var res = await _dio.get('reverse/v3',
          queryParameters: {'apikey': apiKey, 'lat': lat, 'lng': long});

      if (res.statusCode == 200 && res.data.length > 0) {
        var data = VietmapReverseModel.fromJson(res.data[0]);
        return Right(data);
      } else {
        return const Left(ApiServerFailure('Có lỗi xảy ra'));
      }
    } on DioException catch (ex) {
      print(ex);
      if (ex.type == DioExceptionType.receiveTimeout) {
        return Left(ApiTimeOutFailure());
      } else {
        return Left(ExceptionFailure(ex));
      }
    }
  }

  @override
  Future<Either<Failure, List<VietmapAutocompleteModel>>> searchLocation(
      String keySearch) async {
    try {
      var res = await _dio.get('autocomplete/v3',
          queryParameters: {'apikey': apiKey, 'text': keySearch});

      if (res.statusCode == 200) {
        var data = List<VietmapAutocompleteModel>.from(
            res.data.map((e) => VietmapAutocompleteModel.fromJson(e)));
        return Right(data);
      } else {
        return const Left(ApiServerFailure('Có lỗi xảy ra'));
      }
    } on DioException catch (ex) {
      if (ex.type == DioExceptionType.receiveTimeout) {
        return Left(ApiTimeOutFailure());
      } else {
        return Left(ExceptionFailure(ex));
      }
    }
  }

  @override
  Future<Either<Failure, VietmapPlaceModel>> getPlaceDetail(
      String placeId) async {
    try {
      var res = await _dio.get('place/v3',
          queryParameters: {'apikey': apiKey, 'refid': placeId});

      if (res.statusCode == 200) {
        var data = VietmapPlaceModel.fromJson(res.data);
        return Right(data);
      } else {
        return const Left(ApiServerFailure('Có lỗi xảy ra'));
      }
    } on DioException catch (ex) {
      if (ex.type == DioExceptionType.receiveTimeout) {
        return Left(ApiTimeOutFailure());
      } else {
        return Left(ExceptionFailure(ex));
      }
    }
  }
}
