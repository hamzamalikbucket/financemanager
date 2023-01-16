class ItemModel{
  late String? ItemId,ItemName;

  ItemModel(this.ItemId, this.ItemName);
  factory ItemModel.fromJson(Map<String, dynamic> json){
    return ItemModel(json['id'].toString(),json['title']);}
}