class RecieptModel{
  late String ReceiptId,AccountTitle,Amount,Description,Date;

  RecieptModel(this.ReceiptId,this.AccountTitle, this.Amount, this.Description);
  factory RecieptModel.fromJson(Map<String, dynamic> json){
    return RecieptModel(json['id'].toString(),json['title'].toString(), json['amount'], json['description']);
  }
}