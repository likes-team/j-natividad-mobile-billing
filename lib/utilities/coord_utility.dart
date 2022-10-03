import 'dart:math';

bool isCoordsNear(double? checkPointLng, double? checkPointLat, dynamic centerPointLng, dynamic centerPointLat, double km){
    if(checkPointLat == null && checkPointLng == null){
        return false;
    }
    
    if((centerPointLng == '' || centerPointLng == null) || (centerPointLat == '' || centerPointLat == null)){
        return false;
    }

    var ky = 40000 / 360;
    var kx = cos(pi * double.parse(centerPointLat) / 180.0) * ky;
    var dx = (double.parse(centerPointLng) - checkPointLng!).abs() * kx;
    var dy = (double.parse(centerPointLat) - checkPointLat!).abs() * ky;
    print(sqrt(dx * dx + dy * dy) <= km);
    return sqrt(dx * dx + dy * dy) <= km;
}