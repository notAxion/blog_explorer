import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blogs_model.g.dart';

@JsonSerializable(createToJson: false)
class BlogsListModel with ChangeNotifier {
  final List<BlogModel> blogs;
  late List<BlogModel> filteredBlogs;
  String? errorStr;
  bool onlyShowFavs = false;

  BlogsListModel({
    required this.blogs,
    this.errorStr,
  }) {
    filteredBlogs = blogs;
  }

  factory BlogsListModel.fromJson(Map<String, dynamic> json) =>
      _$BlogsListModelFromJson(json);

  void filter({String? query, bool? showFavorites}) {
    if (showFavorites != null) {
      onlyShowFavs = showFavorites;
    }
    filteredBlogs = (!onlyShowFavs)
        ? blogs
        : blogs.where((blog) => blog.isFavorite == true).toList();
    if (query != null) {
      filteredBlogs = (query == "")
          ? filteredBlogs
          : filteredBlogs
              .where((blog) =>
                  blog.title.toLowerCase().contains(query.toLowerCase()))
              .toList();
    }
    notifyListeners();
  }
}

@JsonSerializable(createToJson: false)
class BlogModel with ChangeNotifier {
  // uuid
  final String id;
  @JsonKey(name: "image_url")
  final String imageUrl;
  final String title;
  @JsonKey(includeFromJson: false)
  bool _isFavorite;

  bool get isFavorite => _isFavorite;

  set isFavorite(bool value) {
    _isFavorite = value;
    notifyListeners();
  }

  @JsonKey(includeFromJson: false)
  bool isHidden;

  BlogModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    bool isFavorite = false,
    this.isHidden = false,
  }) : _isFavorite = isFavorite;

  factory BlogModel.fromJson(Map<String, dynamic> json) =>
      _$BlogModelFromJson(json);
}
