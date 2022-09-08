import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String title;
  int time;
  final datePublished;

  Post({
    required this.postId,
    required this.time,
    required this.title,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "datePublished": datePublished,
        "title": title,
        "time": time
      };

  static Post fromSnap(
    DocumentSnapshot snap,
  ) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return fromMap(
      snapshot,
    );
  }

  static Post fromMap(
    Map<String, dynamic> snapshot,
  ) {
    return Post(
      postId: snapshot['postId'] ?? "",
      title: snapshot['title'] ?? "",
      datePublished: snapshot['datePublished'],
      time: snapshot['time'],
    );
  }
}
