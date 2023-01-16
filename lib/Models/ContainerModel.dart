class ContainerModel{
  late String? conatinerId,ContainerName;

  ContainerModel(this.conatinerId, this.ContainerName);
  factory ContainerModel.fromJson(Map<String, dynamic> json){
    return ContainerModel(json['id'].toString(),json['name']);}

}