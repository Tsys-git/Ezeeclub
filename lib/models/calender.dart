// calendar_event.dart

class CalendarEvent {
  final String attachment;
  final String branchNo;
  final String empName;
  final String message;
  final String messageNo;
  final String replyMessage;
  final String sendDt;
  final String sendTo;
  final String status;
  final String type;
  final String userName;
  final String sendBy;

  CalendarEvent({
    required this.attachment,
    required this.branchNo,
    required this.empName,
    required this.message,
    required this.messageNo,
    required this.replyMessage,
    required this.sendDt,
    required this.sendTo,
    required this.status,
    required this.type,
    required this.userName,
    required this.sendBy,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      attachment: json['Attachment'] ?? "na",
      branchNo: json['BranchNo'] ?? "na",
      empName: json['EmpName'] ?? "na",
      message: json['Message'] ?? "na",
      messageNo: json['MessageNo'] ?? "na",
      replyMessage: json['ReplyMessage'] ?? "na",
      sendDt: json['SendDt'] ?? "na",
      sendTo: json['SendTo'] ?? "na",
      status: json['Status'] ?? "na",
      type: json['Type'] ?? "na",
      userName: json['UserName'] ?? "na",
      sendBy: json['sendBy'] ?? "na",
    );
  }
}
