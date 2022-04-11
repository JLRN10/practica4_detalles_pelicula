class ActorsMoviesModel {
  String? name;
  String? photo;
  ActorsMoviesModel({this.name, this.photo});
  factory ActorsMoviesModel.fromMap(Map<String, dynamic> map) {
    return ActorsMoviesModel(
        name: map['name'], photo: map['profile_path'] ?? '');
  }
}
