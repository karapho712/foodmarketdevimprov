part of 'transaction_cubit.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;
  final bool hasMaxData;

  TransactionLoaded(this.transactions, {this.hasMaxData = false});

  @override
  List<Object> get props => [transactions];
}

class TransactionLoadingFailed extends TransactionState {
  final String message;

  TransactionLoadingFailed(this.message);

  @override
  List<Object> get props => [message];
}

class TransactionLoading extends TransactionState {
  final List<Transaction> oldTransaction;
  final bool hasMaxData;

  TransactionLoading(this.oldTransaction, {this.hasMaxData = false});

  // @override
  // List<Object> get props => [oldTransaction];
}
