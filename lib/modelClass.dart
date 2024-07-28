class Note {
  int id;
  String title;
  String Description;
  String email;
  String date;

  Note({
    required this.id,
    required this.title,
    required this.email,
    required this.Description,
    required this.date,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json["id"],
      title: json['title'],
      email: json['email'],
      Description: json['description'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'email': email,
      'description': Description,
      'date': date,
    };
  }
}
