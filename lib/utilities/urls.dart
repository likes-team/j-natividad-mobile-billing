class AppUrls {
  static const String serverURL = "http://13.212.16.21";

  static const String loginURL = serverURL + "/auth/api/users/login";

  static const String deliveriesURL = serverURL + "/bds/api/deliveries";

  static const String deliverURL = serverURL + "/bds/api/confirm-deliver";

  static const String areasURL = serverURL + "/bds/api/messengers/";

  static const String updateLocationURL =
      serverURL + "/bds/api/subscriber/update-location";
  // static String areasURL(messengerID) {
  //   return serverURL + "/bds/api/messengers/" + messengerID + "/areas";
  // }
}
