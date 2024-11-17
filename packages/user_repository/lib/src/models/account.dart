class Account {
  const Account({
    required this.id,
    required this.name,
    required this.balance,
  });

  final int id;
  final String name;
  final int balance;

  factory Account.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return Account(
      id: data['account_id'],
      name: data['name'],
      balance: data['balance'],
    );
  }
}
