import 'package:ezeeclub/consts/appConsts.dart';

class UrlSetting {
  final AppConsts _ac = AppConsts();
  Uri? baseUrl;

  Uri? saveAttendance;
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

  Future<void> initialize() async {
    Uri fetchedUrl = await _ac.getStoredUrl();
    baseUrl = Uri.parse("http://${fetchedUrl}/MobileAppService.svc");
    print('Base URL: $baseUrl'); // For verification

    // Initialize endpoint URLs
    saveAttendance = Uri.parse("${baseUrl!}/SaveAttendance");
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

    // Print URLs for verification
    print('Save Attendance URL: $saveAttendance');
    print('Get Health Details URL: $getHealthDetails');
    print('Get Plan Details URL: $getPlanDetails');
    print('Get Measure Details URL: $getMeasureDetails');
    print('Get Workout URL: $getWorkout');
    print('Get Diet URL: $getDiet');
    print('Get PT Sessions URL: $getPtSessions');
    print('Change Password URL: $changePassword');
    print('Forgot Password URL: $forgotPassword');
    print('Get Notification URL: $getNotification');
    print('Registration URL: $registration');
    print('Get Branch Details URL: $getBranchDetails');
    print('Save Message URL: $saveMessage');
    print('Get Message URL: $getMessage');
    print('Approve PT Sessions URL: $approvePtSessions');
    print('Get Attendance Rewards URL: $getAttendanceRewards');
    print('Get Calendar Details URL: $getCalendarDetails');
    print('Employee Login URL: $employeeLogin');
    print('Employee Attendance URL: $employeeAttendance');
  }
}
