class JvModel{
late String? id,accountName,description,credit,debit,date;

JvModel(this.id, this.accountName, this.description, this.credit,
      this.debit, this.date);
factory JvModel.fromJson(Map<String, dynamic> json){
  return JvModel(json['id'].toString(), json['title'], json['description'], json['credit'], json['debit'], json['op_date']);}
}