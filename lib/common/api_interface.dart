class ApiInterface{
  ///pacinos/public/pacinos
  // static String URL_PREFIX = 'test/'; //test url prefix
  static String URL_PREFIX = ''; //test url prefix
  // static String URL_PREFIX = 'pacinos/'; //live url prefix
  static String BASE_URL = 'https://eroster.com.au/';
  static String LOGIN_USER = BASE_URL+URL_PREFIX+'public/api/signIn';
  static String SCHEDULER = BASE_URL+URL_PREFIX+'public/api/publishData';
  static String CLOCK_IN = BASE_URL+URL_PREFIX+'public/api/clock_in';
  static String CLOCK_OUT = BASE_URL+URL_PREFIX+'public/api/clock_out';
  static String NOTIFICATION_LIST = BASE_URL+URL_PREFIX+'public/api/notificationList';
  static String GET_LOCATION = BASE_URL+URL_PREFIX+'public/api/location';
  static String DEVICE_VALIDATION = BASE_URL+URL_PREFIX+'public/api/checkDevice';
//  https://eroster.com.au/test/public/api/checkDevicecd
}