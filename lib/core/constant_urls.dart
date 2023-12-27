class ApiConstants {
  static String baseUrl = 'https://one-million-insurance-6601b43b6024.herokuapp.com/insurance';
  static String registrationEndpoint = '/createProfile';
  static String sendOTPEndpoint = '/otp';
  static String sendOTPVerify = '/verifyOtp';
  static String loginEndpoint = '/login';
  static String calculatorEndpoint = '/calculator';
  static String coverageSelectionEndpoint = '/coverageSelection';
  static String claimEndpoint = '/initiateClaim';
  static String claimListEndpoint = '/listClaim';
  static String notificationEndpoint = '/notification';


  static String beneficiaryEndpoint = '/beneficiary';
static String beneficiaryLimitEndpoint = '/increaseBeneficiaryLimit';

  static String uploadDocumentEndpoint = '/uploadDocument';
  static String mpesaPaymentEndpoint = '/lipa-na-mpesa';
  static String uptoDatePaymentEndpoint = '/upto-date-payment';
  static String promotionCodeEndpoint = '/promotionCode';
  static String policyDetailsEndpoint = '/policyDetails';
  static String defaultPolicyPayEndpoint = '/defaultPolicyPay';
  static String claimDefaultEndpoint = '/claimDefault';
  static String fetchProfileEndpoint = '/fetchDocument';

  static String resetPasswordEndpoint = '/resetPin';

  static String markAllEndpoint = '/markAllAsRead';
  static String markAsReadEndpoint = '/markAsRead';
}
