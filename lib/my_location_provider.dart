import 'package:location/location.dart';


class MyLocationProvider{
  Location locationManager = Location();
  //اول حاجة لازم اتاكد ان السيرفس متاحة ولا لا ممكن يكون اليوزر قافل السيرفس دي علي الفون اساسا
  //اليوزر قافل الgps فبتالي مش مفيس سيجنل للسيرفس اصلا
  //تاني حاجة تسال علي الpermisssion اليوزر موافق عليهم

  ///bool
  ///gps service is opened/available or not
  Future<bool> isServiceEnabled()async{
    var serviceEnabled =await locationManager.serviceEnabled();
    return serviceEnabled;

  }

  ///to ask the user to accept permissions
  ///return is bool too but true if the user accepted the permission
  Future<bool> requestService()async{
    var serviceEnabled = await locationManager.requestService();
    return serviceEnabled;

  }

  ///you need to know the user accepted the permissions or not
  Future<bool> isPermissionGranted()async{
    var permissionStatus = await locationManager.hasPermission();
    return permissionStatus == PermissionStatus.granted;
  }

  ///to request users permissions
  Future<bool> requestPermission()async{
    var permissionStatus = await locationManager.requestPermission();
    return permissionStatus == PermissionStatus.granted;
  }

  ///to get user's location but first you need to ask to permission in case it was denied
  Future<LocationData?> getLocation()async{
    bool isServiceEnabled = await requestService();
    bool isPermissionGranted = await requestPermission();
    if(!isServiceEnabled || !isPermissionGranted){
      return null;
    }
    return locationManager.getLocation();
  }


  Stream<LocationData> trackUserLocation(){
    return locationManager.onLocationChanged;
  }
}