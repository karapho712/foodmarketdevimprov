// import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterfoodlaravelproject/cubit/cubit.dart';
import 'package:flutterfoodlaravelproject/models/models.dart';
import 'package:flutterfoodlaravelproject/services/services.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(TransactionInitial());
  int page = 1;
  bool maxItem = false;

  Future<void> getTransactions({int? indexpage = 0}) async {
    // final TransactionServices transService;
    // ApiReturnValue<List<Transaction>> result = await TransactionServices.getTransactions(page: indexpage);
    ApiReturnValue<List<Transaction>> transactionsList;

    if (state is TransactionInitial) {
      transactionsList = await TransactionServices.getTransactions(page: page);
      emit(TransactionLoaded(transactionsList.value as List<Transaction>, hasMaxData: false));
      page = transactionsList.value2! + 1;
    } else {
      TransactionLoaded transactionsLoaded = state as TransactionLoaded;
      ApiReturnValue<List<Transaction>> newtransactionsList = await TransactionServices.getTransactions(page: page);

      if (newtransactionsList.value!.isEmpty) {
        print("INI KOSONG TRANSCUBIT");
        emit(TransactionLoaded(transactionsLoaded.transactions, hasMaxData: true));
      } else {
        print("INI NGAKX KOSONG TRANSCUBIT");
        // page++;
        page = newtransactionsList.value2! + 1;
        emit(TransactionLoaded(transactionsLoaded.transactions + newtransactionsList.value!, hasMaxData: false));
      }
    }
    print(page.toString() + " Ini PAGE NYA");

    // ==================================================

    // final currentState = state;
    // // print("transaction_cubit 1" + currentState.toString());

    // var oldTrans = <Transaction>[];

    // if (currentState is TransactionLoaded) {
    //   oldTrans = currentState.transactions;
    // }

    // print(maxItem.toString() + " sebelum emit transctionloading 1");
    // emit(TransactionLoading(oldTrans, hasMaxData: maxItem));
    // // print("transaction_cubit 2 " + state.toString());

    // ApiReturnValue<List<Transaction>> result = await TransactionServices.getTransactions(page: page);
    // // print("test111 " + result.value.toString());
    // // print("panjang datanya" + result.value!.length.toString());

    // // if (result.value != null) {
    // if (result.value!.isNotEmpty) {
    //   page++;
    //   // print(page);
    //   // log(result.value.toString());

    //   // final newdata = (state as TransactionLoading).oldTransaction;

    //   oldTrans.addAll(result.value!);
    //   print(oldTrans.length.toString() + " Panjang data loading saat ini");

    //   // emit(TransactionLoaded(result.value!));
    //   // emit(TransactionLoaded(oldTrans, hasMaxData: maxItem));

    //   emit(TransactionLoaded(oldTrans, hasMaxData: maxItem));
    //   print("transaction_cubit 3 " + state.toString());
    // } else {
    //   maxItem = true;
    //   emit(TransactionLoading(oldTrans, hasMaxData: maxItem));
    //   print("transaction_cubit 3 x " + state.toString());
    //   // emit(TransactionLoadingFailed(result.message!));
    // }
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
