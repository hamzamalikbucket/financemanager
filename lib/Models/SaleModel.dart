class SaleModel{

  late String? purchaseId,
      itemTitle,
      supplierTitle,
      containerTitle,
      description,
      totalWeight,
      lessWeight,
      netWeight,
      purchaseRate,
  customerTitle,
  saleDate,
      totalAmount;

  SaleModel(
      this.purchaseId,
      this.itemTitle,
      this.supplierTitle,
      this.containerTitle,
      this.description,
      this.totalWeight,
      this.lessWeight,
      this.netWeight,
      this.purchaseRate,
      this.customerTitle,
      this.saleDate,
      this.totalAmount);
  factory SaleModel.fromJson(Map<String, dynamic> json){
    return SaleModel(json['id'].toString(), json['item_name'], json['title'], json['container_name'], json['description'], json['total_weight'], json['less_weight'], json['net_weight'], json['rate'],json['title'], json['op_date'].toString(), json['total_amount']);}

}