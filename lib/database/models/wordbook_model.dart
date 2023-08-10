class WordBook {
  int? id;
  int userId;
  String name;

  WordBook({
    this.id,
    required this.userId,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'name': name,
    };
  }

  static WordBook fromMap(Map<String, dynamic> map) {
    return WordBook(
      id: map['id'] as int,
      userId: map['userId'] as int,
      name: map['name'] as String,
    );
  }
}
