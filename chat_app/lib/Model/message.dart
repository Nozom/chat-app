class Message {
  final String from;
  final String to;
  final String text;
  final DateTime date;
  final bool isRead;

  const Message({
    required this.from,
    required this.to,
    required this.text,
    required this.date,
    this.isRead = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      from: json['from'],
      to: json['to'],
      text: json['text'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "from": from,
      "to": to,
      "text": text,
      "date": date.toString(),
    };
  }

  Message copyWith({
    String? text,
    bool? isRead,
  }) =>
      Message(
        from: from,
        to: to,
        text: text ?? this.text,
        date: date,
        isRead: isRead ?? this.isRead,
      );
}
