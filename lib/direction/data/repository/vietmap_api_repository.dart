import 'package:dartz/dartz.dart';
import 'package:giuaki_map_location/direction/data/models/vietmap_reverse_model.dart';

import '../../core/failures/failure.dart';
import '../models/vietmap_place_model.dart';


import '../models/vietmap_autocomplete_model.dart';

abstract class VietmapApiRepository {
  Future<Either<Failure, VietmapReverseModel>> getLocationFromLatLng(
      {required double lat, required double long});

  Future<Either<Failure, List<VietmapAutocompleteModel>>> searchLocation(
      String keySearch);

  Future<Either<Failure, VietmapPlaceModel>> getPlaceDetail(String placeId);
}
