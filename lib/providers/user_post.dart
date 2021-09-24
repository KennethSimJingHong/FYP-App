
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/models/comment.dart';
import 'package:healthy_lifestyle_app/models/post.dart';
import 'package:healthy_lifestyle_app/models/report.dart';

class UserPost extends ChangeNotifier{
  List<Map<String,dynamic>> _posts = [];

  List<Map<String,dynamic>>get posts{
    return [..._posts];
  }
  
  //add post
  Future<void> addPost(Post post) async {

    final ref = FirebaseStorage.instance.ref().child("userPost").child(post.title + ".jpg");
    await ref.putFile(post.image).onComplete;
    final url = await ref.getDownloadURL();
    DocumentReference docRef = Firestore.instance.collection("posts").document(); 
    docRef.setData({
      "title":post.title,
      "category":post.category, 
      "user_id": post.userId, 
      "image_url": url, 
      "content": post.content,
      "who_have_liked": [],
      "post_id": docRef.documentID,
      "createdAt" :Timestamp.now(),
    });
  }

  // like or unlike the post
  void updatePostFav(DocumentSnapshot getDoc, String currentUID, bool action){
    List newList = getDoc["who_have_liked"];
    if(action){
      if(!newList.contains(currentUID)){
        newList.add(currentUID);
      }
      Firestore.instance.collection("posts").document(getDoc["post_id"]).updateData({
        "title":getDoc["title"],
        "category":getDoc["category"], 
        "user_id": getDoc["user_id"], 
        "image_url": getDoc["image_url"], 
        "content": getDoc["content"],
        "who_have_liked": newList,
        "post_id": getDoc["post_id"],
      });
    }else{
      newList.removeWhere((element) => element == currentUID);
      Firestore.instance.collection("posts").document(getDoc["post_id"]).updateData({
        "title":getDoc["title"],
        "category":getDoc["category"], 
        "user_id": getDoc["user_id"], 
        "image_url": getDoc["image_url"], 
        "content": getDoc["content"],
        "who_have_liked": newList,
        "post_id": getDoc["post_id"],
      });
    }
  }

  //report post
  void reportPost(Report report){
    DocumentReference docRef = Firestore.instance.collection("report").document();
    docRef.setData({
      "report_id":docRef.documentID, 
      "reporter_id":report.userId,
      "post_id":report.postId, 
      "comment": report.comment, 
      "reason": report.reason,
    });
  }
  
  //comment post
  void commentPost(Comment comment){
    Firestore.instance.collection("comments").document(comment.postid).setData({
      "comment_id" : comment.commentid,
      "comment_list" : comment.comment,
    });
  }

  //delete post
  void deletePost(String postid, String url)async{
    Firestore.instance.collection("posts").document(postid).delete();
    Firestore.instance.collection("comments").document(postid).delete();
    StorageReference oldRef = await FirebaseStorage().getReferenceFromUrl(url);
    oldRef.delete();
  }
}