import 'package:json_annotation/json_annotation.dart';

part 'blogs_model.g.dart';

@JsonSeiralizable(createToJson: false)
class BlogsListModel {
  final List<BlogModel> blogs;

  BlogsListModel({
    required this.blogs,
  });

  factory BlogsListModel.fromJson(map<string, dynamic> json) =>
      _$BlogsListModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class BlogModel {
  // uuid
  final String id;
  @JsonKey(name: "image_url")
  final String imageUrl;
  final String title;
  @JsonKey(ignore: true)
  bool isFavorite,
  @JsonKey(ignore: true)
  bool isHidden,

  BlogModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.isFavorite = false,
    this.isHidden = false,
  });

  factory BlogModel.fromJson(map<string, dynamic> json) =>
      _$BlogsModelFromJson(json);
}
