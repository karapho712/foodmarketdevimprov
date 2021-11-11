import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterfoodlaravelproject/cubit/cubit.dart';
import 'package:flutterfoodlaravelproject/models/models.dart';
import 'package:flutterfoodlaravelproject/services/services.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(TransactionInitial());
  int page = 1;

  Future<void> getTransactions({int? indexpage = 0}) async {
    final TransactionServices transService;
    // ApiReturnValue<List<Transaction>> result = await TransactionServices.getTransactions(page: indexpage);

    final currentState = state;
    print("transaction_cubit 1" + currentState.toString());

    var oldTrans = <Transaction>[];

    if (currentState is TransactionLoaded) {
      oldTrans = currentState.transactions;
    }

    emit(TransactionLoading(oldTrans, isFirstFetch: page == 1));
    print("transaction_cubit 2 " + state.toString());

    ApiReturnValue<List<Transaction>> result = await TransactionServices.getTransactions(page: page);

    if (result.value != null) {
      page++;
      // print(page);
      // log(result.value.toString());

      final newdata = (state as TransactionLoading).oldTransaction;
      newdata.addAll(result.value!);

      // emit(TransactionLoaded(result.value!));
      emit(TransactionLoaded(newdata));
      print("transaction_cubit 3 " + state.toString());
    } else {
      emit(TransactionLoadingFailed(result.message!));
    }
  }

  // Future<void> getOldTransaction({int? indexpage}) async {
  //   ApiReturnValue<List<Transaction>> result = await TransactionServices.getOldTransactions(page: indexpage);

  //   if (result.value != null) {
  //     emit(TransactionLoaded(result.value!));
  //   } else {
  //     emit(TransactionLoadingFailed(result.message!));
  //   }
  // }

  Future<String?> submitTransaction(Transaction transaction) async {
    ApiReturnValue<Transaction> result = await TransactionServices.submitTransaction(transaction);

    if (result.value != null) {
      emit(TransactionLoaded((state as TransactionLoaded).transactions + [result.value!]));
      return result.value!.paymentUrl!;
    } else {
      return null;
    }
  }
}
