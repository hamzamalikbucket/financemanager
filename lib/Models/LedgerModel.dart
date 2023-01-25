class LedgerModel{
  late String? id,date,description,weight,rate,debit,credit,balance;

  LedgerModel(this.id,this.date, this.description, this.weight, this.rate, this.debit,
      this.credit, this.balance);
  factory LedgerModel.fromJson(Map<String, dynamic> json){
    return LedgerModel(json['vNo'].toString(), json['created_at'], json['description'], json['net_weight'], json['rate'], json['debit'].toString(), json['credit'].toString(), json['balance'].toString());
  }
}