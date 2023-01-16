class AccountModel{

late String? AccountId,Title,OpeningBalance,PhoneNumber,OpeningDate;

AccountModel(
      this.AccountId,this.Title, this.OpeningBalance, this.PhoneNumber, this.OpeningDate);
factory AccountModel.fromJson(Map<String, dynamic> json){
  return AccountModel(json['id'].toString(),json['title'], json['balance'], json['phone'], json['op_date']);
}
}