import 'package:ezeeclub/consts/appConsts.dart';

class UrlSetting {
  final AppConsts _ac = AppConsts();
  Uri? baseUrl;

  Uri? webServiceUrl;

  Uri? saveAttendance;
  Uri? getAttendance;
  Uri? getHealthDetails;
  Uri? getPlanDetails;
  Uri? getMeasureDetails;
  Uri? getWorkout;
  Uri? getDiet;
  Uri? getPtSessions;
  Uri? changePassword;
  Uri? forgotPassword;
  Uri? getNotification;
  Uri? registration;
  Uri? getBranchDetails;
  Uri? saveMessage;
  Uri? getMessage;
  Uri? approvePtSessions;
  Uri? getAttendanceRewards;
  Uri? getCalendarDetails;
  Uri? employeeLogin;
  Uri? employeeAttendance;

  Uri? MDConversion;
  Uri? MDSales;
  Uri? MDDailyStatus;

  Future<void> initialize() async {
    Uri fetchedUrl = await _ac.getStoredUrl();

    baseUrl = Uri.parse("http://${fetchedUrl}/MobileAppService.svc");
    print('Base URL: $baseUrl'); // For verification

    //MobileAppService.svc
    saveAttendance = Uri.parse("${baseUrl!}/SaveAttendance");
    getAttendance = Uri.parse("${baseUrl!}/GetAttendance");

    getHealthDetails = Uri.parse("${baseUrl!}/GetHealthDetails");
    getPlanDetails = Uri.parse("${baseUrl!}/GetPlanDetails");
    getMeasureDetails = Uri.parse("${baseUrl!}/GetMeasureDetails");
    getWorkout = Uri.parse("${baseUrl!}/GetWorkout");
    getDiet = Uri.parse("${baseUrl!}/GetDiet");
    getPtSessions = Uri.parse("${baseUrl!}/GetPTSessions");
    changePassword = Uri.parse("${baseUrl!}/ChangePassword");
    forgotPassword = Uri.parse("${baseUrl!}/ForgotPassword");
    getNotification = Uri.parse("${baseUrl!}/GetNotification");
    registration = Uri.parse("${baseUrl!}/Registration");
    getBranchDetails = Uri.parse("${baseUrl!}/GetBranchDetails");
    saveMessage = Uri.parse("${baseUrl!}/SaveMessage");
    getMessage = Uri.parse("${baseUrl!}/GetMessage");
    approvePtSessions = Uri.parse("${baseUrl!}/ApprovePTSessions");
    getAttendanceRewards = Uri.parse("${baseUrl!}/GetAttendanceRewards");
    getCalendarDetails = Uri.parse("${baseUrl!}/GetCalendarDetails");
    employeeLogin = Uri.parse("${baseUrl!}/EmployeeLogin");
    employeeAttendance = Uri.parse("${baseUrl!}/EmployeeAttendance");

    // Web service url

    webServiceUrl = Uri.parse("http://${fetchedUrl}/androidwebservice.asmx");
    print('Webserive URL: $webServiceUrl'); // For verification

    // Soap Action List
    MDConversion = Uri.parse("MDConversion");
    MDSales = Uri.parse("MDSales");
    MDDailyStatus = Uri.parse("MDDailyStatus");
  }
}
