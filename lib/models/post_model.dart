class PostModel {
  String? id;
  String? title;
  String? description;
  String? image;
  String? postedBy;
  String? dataTimeOfPosts;
  PostModel({
    this.id,
    this.title,
    this.description,
    this.image,
    this.postedBy,
    this.dataTimeOfPosts,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'postedBy': postedBy,
      'dataTimeOfPosts': dataTimeOfPosts,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      image: map['image'],
      postedBy: map['postedBy'],
      dataTimeOfPosts: map['dataTimeOfPosts'],
    );
  }
}
