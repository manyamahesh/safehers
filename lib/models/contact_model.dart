class Contact {
  final String name;
  final String number;

  Contact({required this.name, required this.number});

  Map<String, String> toJson() => {
        'name': name,
        'number': number,
      };

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      number: json['number'],
    );
  }
}
