class LedgerModel {
  late String? id,
      date,
      description,
      netweight,
      rate,
      debit,
      credit,
      balance,
      totalweight,
      lessweight;

  LedgerModel(this.id, this.date, this.description, this.lessweight, this.rate,
      this.debit, this.credit, this.balance, this.totalweight, this.netweight);
  factory LedgerModel.fromJson(Map<String, dynamic> json) {
    return LedgerModel(
        json['vNo'].toString(),
        json['created_at'],
        json['description'],
        json['less_weight'].toString(),
        json['rate'],
        json['debit'].toString(),
        json['credit'].toString(),
        json['balance'].toString(),
        json['total_weight'].toString(),
        json['net_weight'].toString(),

    );
  }
}
