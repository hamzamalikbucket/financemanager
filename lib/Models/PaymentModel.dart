class PaymentModel{

late String? PaymentId,AccountTitle,Amount,Description,Date;

PaymentModel(this.PaymentId,this.AccountTitle, this.Amount, this.Description,this.Date);
factory PaymentModel.fromJson(Map<String, dynamic> json){
  return PaymentModel(json['id'].toString(),json['title'].toString(), json['amount'].toString(), json['description'], json['op_date']);
}
}