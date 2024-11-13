class Account {
  const Account({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  final int id;
  final String username;
  final String firstName;
  final String lastName;

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}
