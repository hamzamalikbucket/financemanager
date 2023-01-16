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
      this.totalAmount);
}