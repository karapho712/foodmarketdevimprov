part of 'models.dart';

enum TransactionStatus { delivered, on_delivery, pending, cancelled }

class Transaction extends Equatable {
  final int? id;
  final Food? food;
  final int? quantity;
  final int? total;
  final DateTime? dateTime;
  final TransactionStatus? status;
  final User? user;
  final String? paymentUrl;
  final int? lastPage;

  Transaction({
    this.id,
    this.food,
    this.quantity,
    this.dateTime,
    this.total,
    this.status,
    this.user,
    this.paymentUrl,
    this.lastPage,
  });

  factory Transaction.fromJson(Map<String, dynamic> data) => Transaction(
        id: data['id'],
        food: Food.fromJson(data['food']),
        quantity: data['quantity'],
        total: data['total'],
        dateTime: DateTime.fromMillisecondsSinceEpoch(data['created_at']),
        status: (data['status'] == 'PENDING')
            ? TransactionStatus.pending
            : (data['status'] == 'DELIVERED')
                ? TransactionStatus.delivered
                : (data['status'] == 'CANCELED')
                    ? TransactionStatus.cancelled
                    : TransactionStatus.on_delivery,
        paymentUrl: data['payment_url'],
        // lastPage: data['last_page'],
      );

  Transaction copyWith({
    int? id,
    Food? food,
    int? quantity,
    int? total,
    DateTime? dateTime,
    TransactionStatus? status,
    User? user,
  }) {
    return Transaction(
      id: id ?? this.id,
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, food, quantity, total, dateTime, status, user];
}

List<Transaction> mockTransactions = [
  Transaction(
      id: 1,
      food: mockFoods[1],
      quantity: 10,
      total: (mockFoods[1].price! * 10 * 1.1).round() + 50000,
      dateTime: DateTime.now(),
      status: TransactionStatus.on_delivery,
      user: mockUser),
  Transaction(
      id: 2,
      food: mockFoods[2],
      quantity: 3,
      total: (mockFoods[2].price! * 3 * 1.1).round() + 50000,
      dateTime: DateTime.now(),
      status: TransactionStatus.delivered,
      user: mockUser),
  Transaction(
      id: 3,
      food: mockFoods[4],
      quantity: 3,
      total: (mockFoods[2].price! * 3 * 1.1).round() + 50000,
      dateTime: DateTime.now(),
      status: TransactionStatus.cancelled,
      user: mockUser),
];
