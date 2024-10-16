class Account {
  final String? id;
  final String name;
  final double balance;

  Account({this.id, required this.name, required this.balance});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id']?.toString(),
      name: json['name'],
      balance: (json['balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'balance': balance,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}
