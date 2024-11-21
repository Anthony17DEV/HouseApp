// lib/models/transaction.dart

class Transaction {
  String type; // 'receita', 'despesa' ou 'transferência'
  String name;
  double amount;
  DateTime date;
  String category;
  String account; // Conta ou cartão para receita e despesa
  String fromAccount; // Conta de origem para transferência
  String toAccount; // Conta de destino para transferência
  String recurrence; // 'único', 'recorrente' ou 'parcelado'

  Transaction({
    required this.type,
    required this.name,
    required this.amount,
    required this.date,
    this.category = '',
    this.account = '',
    this.fromAccount = '',
    this.toAccount = '',
    required this.recurrence,
  });

  // Método opcional para converter a transação em um mapa (para banco de dados, por exemplo)
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'account': account,
      'fromAccount': fromAccount,
      'toAccount': toAccount,
      'recurrence': recurrence,
    };
  }

  // Método opcional para criar uma instância de Transaction a partir de um mapa
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      type: map['type'],
      name: map['name'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: map['category'],
      account: map['account'],
      fromAccount: map['fromAccount'],
      toAccount: map['toAccount'],
      recurrence: map['recurrence'],
    );
  }
}
