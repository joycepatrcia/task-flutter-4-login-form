class Post {
  final int id;
  final String title;
  final String body;
  final bool isArchived;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    this.isArchived = false, // Default to false, meaning not archived
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      isArchived: json['isArchived'] ?? false, // Handle any possible isArchived field from the JSON
    );
  }

  // CopyWith method to allow creating a new instance with modified values
  Post copyWith({bool? isArchived}) {
    return Post(
      id: this.id,
      title: this.title,
      body: this.body,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}