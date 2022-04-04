class FavoriteModel {
  int id;
  String title;
  String posterpath;

  FavoriteModel(
      {required this.id, required this.title, required this.posterpath});

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
        id: map['id'], title: map['title'], posterpath: map['posterpath']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'posterpath': posterpath};
  }
}
