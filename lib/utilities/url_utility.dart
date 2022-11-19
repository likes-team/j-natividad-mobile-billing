class AppUrls {
  // static const String serverURL = "http://13.212.16.21";
  static const String serverURL = "http://192.168.100.6:5000";

  static const String loginURL = serverURL + "/auth/api/users/login";

  static const String deliveriesURL = "$serverURL/api/deliveries";

  static const String deliverURL = "$serverURL/api/confirm-deliver";

  static const String areasURL = "$serverURL/api/messengers/";

  static const String updateLocationURL =
      serverURL + "/api/subscriber/update-location";
  // static String areasURL(messengerID) {
  //   return serverURL + "/bds/api/messengers/" + messengerID + "/areas";
  // }
}
