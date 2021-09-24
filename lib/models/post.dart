

import 'dart:io';

class Post{
  String postId;
  String title;
  String category;
  String userId;
  File image;
  List content;

  Post(
    this.postId,
    this.title,
    this.category,
    this.userId,
    this.image,
    this.content,
  );
}