class PurchaseModel {
  late String? purchaseId,
      itemTitle,
      supplierTitle,
      containerTitle,
      description,
      totalWeight,
      lessWeight,
      netWeight,
      purchaseRate,
      purchaseDate,
      totalAmount;

  PurchaseModel(
      this.purchaseId,
      this.itemTitle,
      this.supplierTitle,
      this.containerTitle,
      this.description,
      this.totalWeight,
      this.lessWeight,
      this.netWeight,
      this.purchaseRate,
      this.purchaseDate,
      this.totalAmount);
  factory PurchaseModel.fromJson(Map<String, dynamic> json){
    return PurchaseModel(json['id'].toString(), json['item_name'], json['title'], json['container_name'], json['description'], json['total_weight'], json['less_weight'], json['net_weight'], json['rate'], json['op_date'], json['total_amount']);}
}
