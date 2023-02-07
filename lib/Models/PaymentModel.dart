class PaymentModel{

late String? PaymentId,AccountTitle,Amount,Description,Date,AccountId;

PaymentModel(this.PaymentId,this.AccountTitle, this.Amount, this.Description,this.Date,this.AccountId);
factory PaymentModel.fromJson(Map<String, dynamic> json){
  return PaymentModel(json['id'].toString(),json['title'].toString(), json['amount'].toString(), json['description'], json['op_date'],json['account_id']);
}
}