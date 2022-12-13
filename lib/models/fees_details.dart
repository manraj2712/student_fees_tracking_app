class FeesDetails {
  String paymentId, studentId, paymentDate, paymentMode, amount, forMonth;
  FeesDetails({
    required this.paymentId,
    required this.studentId,
    required this.paymentDate,
    required this.amount,
    required this.paymentMode,
    required this.forMonth,
  });
  factory FeesDetails.fromRTDB(Map data, String paymentId) {
    return FeesDetails(
      paymentId: paymentId,
      studentId: data['studentId'] ?? "",
      paymentDate: data['paymentDate'] ?? "",
      amount: data['amount'] ?? "",
      paymentMode: data['paymentMode'] ?? "",
      forMonth: data['forMonth'] ?? "",
    );
  }
}
