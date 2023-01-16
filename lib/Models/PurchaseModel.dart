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
      this.totalAmount);
}
