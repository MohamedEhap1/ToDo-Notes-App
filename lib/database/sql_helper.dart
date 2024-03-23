class Note {
  final int? id;
  final String title;
  final String content;
  Note({
    this.id,
    required this.title,
    required this.content,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }
}

class ToDO {
  final int? id;
  final String title;
  final int selected;
  ToDO({
    this.id,
    required this.title,
    required this.selected,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'selected': selected,
    };
  }
}
