class ExpensModel{
  late String? id,containerid,desc,amount;


  ExpensModel(this.id, this.containerid, this.desc, this.amount);

  factory ExpensModel.fromJson(Map<String, dynamic> json){
    return ExpensModel(json['id'].toString(),json['container_id'],json['description'],json['amount']);}

}