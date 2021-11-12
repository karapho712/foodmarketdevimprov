part of 'services.dart';

class TransactionServices {
  static Future<ApiReturnValue<List<Transaction>>> getTransactions({http.Client? client, int? page = 1}) async {
    client ??= http.Client();

    String url = baseUrl + 'transaction?limit=5' + '&page=' + page.toString();
    print(url);

    var response = await client.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.token}"
    });

    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Please try again');
    }

    var data = jsonDecode(response.body);
    // print(data["data"]["current_page"].toString() + " CHECK DATA");
    List<Transaction> transactions = (data['data']['data'] as Iterable).map((e) => Transaction.fromJson(e)).toList();

    // List<Transaction> newlist = (data['data']['data'] as Iterable).map((e) => Transaction.fromJson(e)).toList();
    // transactions["newlastPage"] = int.parse(data['data']['last_page']);
    // Transaction datalastpage = data['data']['last_page'];
    // transactions.add(data['data']['last_page']);
    // transactions.insert(9, data['data']['last_page']);
    // print(transactions);

    return ApiReturnValue(value: transactions, value2: data["data"]["current_page"]);

    // await Future.delayed(Duration(seconds: 4));

    // return ApiReturnValue(value: mockTransactions);
  }

  // static Future<dynamic> getLastPage({http.Client? client}) async {

  // }

  static Future<ApiReturnValue<List<Transaction>>> getOldTransactions({http.Client? client, int? page = 1}) async {
    client ??= http.Client();

    String url = baseUrl + 'transaction?limit=5' + '&page=' + page.toString();
    print(url);

    var response = await client.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${User.token}"
    });

    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Please try again');
    }

    var data = jsonDecode(response.body);
    List<Transaction> transactions = (data['data']['data'] as Iterable).map((e) => Transaction.fromJson(e)).toList();

    // List<Transaction> newlist = (data['data']['data'] as Iterable).map((e) => Transaction.fromJson(e)).toList();

    // transactions.addAll(newlist);
    // print(transactions);

    return ApiReturnValue(value: transactions);
  }

  static Future<ApiReturnValue<Transaction>> submitTransaction(Transaction transaction, {http.Client? client}) async {
    client ??= http.Client();

    String url = baseUrl + 'checkout';
    var response = await client.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer ${User.token}"
        },
        body: jsonEncode(<String, dynamic>{
          'food_id': transaction.food!.id,
          'user_id': transaction.user!.id,
          'quantity': transaction.quantity,
          'total': transaction.total,
          'status': "PENDING"
        }));

    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Please try again');
    }

    var data = jsonDecode(response.body);
    Transaction value = Transaction.fromJson(data['data']);
    return ApiReturnValue(value: value);
    // await Future.delayed(Duration(seconds: 2));

    // return ApiReturnValue(message: "Transaksi Gagal");
    // return ApiReturnValue(value: transaction.copyWith(id: 123, status: TransactionStatus.pending));
  }
}
