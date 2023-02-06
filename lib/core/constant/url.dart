class ConstantApiUrl {
  static String baseURL = "http://emkaapi.somee.com/api/";

  static String getSfdc20T = "Quality/getSfdc20T";

  static String getSpesificSfdc20T = "Quality/getSfdc20TByIE?EvrakNo=";

  static String loginEndURL = "Account/Login";
  static String getUserInfoUrl = "Account/GetUserInfo";
  static String getWorkOrdersUrl = "Mmps10e/getIsEmri";
  static String getInsideOrdersUrl = "Mmps10e/getOrders/";
  static String getMaterialsUrl = "Operation/getOperationDetail?EvrakNo=";
  static String getCycleUrl = "Operation/getCevrimSuresi?BomrecCode=";
  static String GetAllTezgahStatus = "Tezgah/GetAllTezgahStatus";
  static String getWorktoPerson = "Personel_IE/AddPersonelIE";
  static String endOfTheDay = "Personel_IE/GunSonuPersonel_IE";
  static String endOfTheWorkOrder = "Personel_IE/ClosePersonel_IE";
  static String addDurus = "Personel_IE/AddDurus";
  static String closeDurus = "Personel_IE/CloseDurus";
}
