import 'package:hrm/main/data/rest_data.dart';

class BlogsModel {
  String title;
  String meta_image;
  String blog_intro;
  String content;
  String blog_category;
  String blogger;
  String comments;

  BlogsModel({
    this.blog_intro,
    this.meta_image,
    this.title,
    this.content,
    this.blog_category,
    this.blogger,
    this.comments,
  });

  factory BlogsModel.fromJson(Map<String, dynamic> json) {
    return BlogsModel(
      title: json['title'],
      meta_image: RestDatasource.BASE_URL + json['meta_image'],
      blog_intro: json['blog_intro'] ??= "",
      content: json['content'],
      blog_category: json['blog_category'],
      blogger: json['blogger'],
      comments: json['_comments'] ??= null,
    );
  }
}
