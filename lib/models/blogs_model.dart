import 'package:json_annotation/json_annotation.dart';

part 'blogs_model.g.dart';

@JsonSerializable(createToJson: false)
class BlogsModel {
  // uuid
  String id;
  @JsonKey(name: "image_url")
  String imageUrl;
  String title;

  BlogsModel({
    required this.id,
    required this.imageUrl,
    required this.title,
  });

  factory BlogsModel.fromJson(Map<String, dynamic> json) =>
      _$BlogsModelFromJson(json);
}
