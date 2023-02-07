class RecieptModel{
  late String ReceiptId,AccountTitle,Amount,Description,Date,AccountId;

  RecieptModel(this.ReceiptId,this.AccountTitle, this.Amount,this.Date, this.Description,this.AccountId);
  factory RecieptModel.fromJson(Map<String, dynamic> json){
    return RecieptModel(json['id'].toString(),json['title'].toString(), json['amount'], json['op_date'].toString(), json['description'],json['account_id']);
  }
}