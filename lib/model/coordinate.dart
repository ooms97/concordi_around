import 'dart:collection';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Coordinate {
  final double _lat;
  final double _lng;
  String _floor;
  String _building;
  String _campus;

  //attributes to be used for google places search results
  String _gPlaceTitle;
  //String _gPlacePhotos;
  String _gPlaceAddress;
  String _gPlacePhone;
  String _gPlaceWebsite;

  String _type;
  Set<Coordinate> _adjCoordinates = HashSet<Coordinate>();

 // Constructor:
// All the attributes inside curly bracket are optional/dynamic attributes
  Coordinate(
    this._lat,
    this._lng,
    this._floor,
    this._building,
    this._campus, {
    type,
    adjCoordinates,
    gPlaceTitle,
    //String  gPlacePhoto,
    gPlaceAddress,
    gPlacePhone,
    gPlaceWebsite,
  }) {
        _type = type;
    if (adjCoordinates != null) {
      _adjCoordinates = adjCoordinates;
      for (var adjCoordinate in _adjCoordinates) {
        adjCoordinate.addAdjCoordinate(this);
      }
    }
     _gPlaceTitle = gPlaceTitle;
    _gPlaceAddress = gPlaceAddress;
    _gPlacePhone = gPlacePhone;
    _gPlaceWebsite = gPlaceWebsite;
  }

  double get lat => _lat;
  double get lng => _lng;
  String get floor => _floor;
  String get building => _building;
  String get campus => _campus;
  String get type => _type;
  
  String get gPlaceTitle => _gPlaceTitle;
  //String get gPlacePhoto => _gPlacePhoto;
  String get gPlaceAddress => _gPlaceAddress;
  String get gPlacePhone => _gPlacePhone;

  String get gPlaceWebsite => _gPlaceWebsite;

  Set<Coordinate> get adjCoordinates => _adjCoordinates;

  set type(String type) => _type = type;
  set adjCoordinates(Set<Coordinate> adjCoordinates) =>
      _adjCoordinates = adjCoordinates;

  //if I am your neighbor, then you must be my neighbor
  bool addAdjCoordinate(Coordinate coordinate) =>
      _adjCoordinates.add(coordinate) && coordinate._adjCoordinates.add(this);

  bool isAdjacent(Coordinate anotherCoordinate) {
    //A coordinate is adjacent to itself
    if (this == anotherCoordinate) {
      return true;
    }
    //Check adjacency list
    for (var adjCoordinate in _adjCoordinates) {
      if (adjCoordinate == anotherCoordinate) {
        //In adjacency list
        return true;
      }
    }
    //Not in adjacency list
    return false;
  }

  LatLng toLatLng() {
    return LatLng(_lat, _lng);
  }

  // Might want to define a better toString...
  @override
  String toString() => '$_building';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coordinate &&
          runtimeType == other.runtimeType &&
          this.lat == other.lat &&
          this.lng == other.lng &&
          this.floor == other.floor &&
          this.building == other.building &&
          this.campus == other.campus &&
          this.type == other.type &&
          this.adjCoordinates.containsAll(other.adjCoordinates) &&
          other.adjCoordinates.containsAll(this.adjCoordinates);

  @override
  int get hashCode => toString().hashCode;
}

class PortalCoordinate extends Coordinate {
  bool _isDisabilityFriendly;

  PortalCoordinate(lat, lng, floorLevel, building, campus,
      {type, adjCoordinates, isDisabilityFriendly = false})
      : super(lat, lng, floorLevel, building, campus,
            type: type, adjCoordinates: adjCoordinates) {
    _isDisabilityFriendly = isDisabilityFriendly;
  }

  bool get isDisabilityFriendly => _isDisabilityFriendly;

  set isDisabilityFriendly(bool isDisabilityFriendly) =>
      _isDisabilityFriendly = isDisabilityFriendly;
}

class RoomCoordinate extends Coordinate {
  String _roomId;

  RoomCoordinate(lat, lng, floorLevel, building, campus,
      {type, adjCoordinates, roomId})
      : super(lat, lng, floorLevel, building, campus,
            type: type, adjCoordinates: adjCoordinates) {
    _roomId = roomId;
  }

  String get roomId => _roomId;

  set roomId(String roomId) => _roomId = roomId;

  @override
  String toString() => '$roomId';
}
