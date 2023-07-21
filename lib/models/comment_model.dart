class Comment {
  final String commentId;
  final String postId;
  final String text;
  final DateTime createdAt;
  final String userId;
  final String userName;
  final String userProfilePic;
  Comment({
    required this.commentId,
    required this.postId,
    required this.text,
    required this.createdAt,
    required this.userId,
    required this.userName,
    required this.userProfilePic,
  });

  Comment copyWith({
    String? commentId,
    String? postId,
    String? text,
    DateTime? createdAt,
    String? userId,
    String? userName,
    String? userProfilePic,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      postId: postId ?? this.postId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfilePic: userProfilePic ?? this.userProfilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'postId': postId,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'userId': userId,
      'userName': userName,
      'userProfilePic': userProfilePic,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'] as String,
      postId: map['postId'] as String,
      text: map['text'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      userProfilePic: map['userProfilePic'] as String,
    );
  }

  @override
  String toString() {
    return 'Comment(commentId: $commentId, postId: $postId, text: $text, createdAt: $createdAt, userId: $userId, userName: $userName, userProfilePic: $userProfilePic)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.commentId == commentId &&
        other.postId == postId &&
        other.text == text &&
        other.createdAt == createdAt &&
        other.userId == userId &&
        other.userName == userName &&
        other.userProfilePic == userProfilePic;
  }

  @override
  int get hashCode {
    return commentId.hashCode ^
        postId.hashCode ^
        text.hashCode ^
        createdAt.hashCode ^
        userId.hashCode ^
        userName.hashCode ^
        userProfilePic.hashCode;
  }
}
