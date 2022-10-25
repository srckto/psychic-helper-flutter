class PostModel {
  String? id;
  String? title;
  String? jsonDescription;
  String? image;
  String? postedBy;
  String? dataTimeOfPosts;
  String? stringDescription;
  PostModel({
    this.id,
    this.title,
    this.jsonDescription,
    this.image,
    this.postedBy,
    this.dataTimeOfPosts,
    this.stringDescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'jsonDescription': jsonDescription,
      'image': image,
      'postedBy': postedBy,
      'dataTimeOfPosts': dataTimeOfPosts,
      'stringDescription': stringDescription,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      title: map['title'],
      jsonDescription: map['jsonDescription'],
      stringDescription: map['stringDescription'],
      image: map['image'],
      postedBy: map['postedBy'],
      dataTimeOfPosts: map['dataTimeOfPosts'],
    );
  }
}
