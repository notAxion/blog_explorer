// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blogs_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogsListModel _$BlogsListModelFromJson(Map<String, dynamic> json) =>
    BlogsListModel(
      blogs: (json['blogs'] as List<dynamic>)
          .map((e) => BlogModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

BlogModel _$BlogModelFromJson(Map<String, dynamic> json) => BlogModel(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      title: json['title'] as String,
    );
