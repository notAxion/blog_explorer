import 'package:json_annotation/json_annotation.dart';

part 'blogs_model.g.dart';

@JsonSerializable(createToJson: false)
class BlogsListModel {
  final List<BlogModel> blogs;

  BlogsListModel({
    required this.blogs,
  });

  factory BlogsListModel.fromJson(Map<String, dynamic> json) =>
      _$BlogsListModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class BlogModel {
  // uuid
  final String id;
  @JsonKey(name: "image_url")
  final String imageUrl;
  final String title;
  @JsonKey(includeFromJson: false)
  bool isFavorite;
  @JsonKey(includeFromJson: false)
  bool isHidden;

  BlogModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.isFavorite = false,
    this.isHidden = false,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) =>
      _$BlogModelFromJson(json);
}
