class TrailerMovieModel {
  String? name;
  String? key;
  String? type;

  TrailerMovieModel({
    this.name,
    this.key,
    this.type,
  });

  factory TrailerMovieModel.fromMap(Map<String, dynamic> map) {
    return TrailerMovieModel(
      name: map['name'] ?? "",
      key: map['key'] ?? "",
      type: map['type'] ?? "",
    );
  }
}
