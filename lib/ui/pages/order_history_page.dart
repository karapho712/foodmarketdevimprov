part of 'pages.dart';

class OrderHistoryPage extends StatefulWidget {
  // OrderHistoryPage({Key? key}) : super(key: key);

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  int selectedIndex = 0;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();

  // @override
  // void initState() {
  //   _scrollController.addListener(() {
  //     if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
  //       BlocProvider.of<TransactionCubit>(context).getTransactions();
  //       // _getMoreList();
  //     }
  //   });
  // }

  void setupScrollController(context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        BlocProvider.of<TransactionCubit>(context).getTransactions();
        // _getMoreList();
      }
    });
  }

  _getMoreList() async {
    print("get more list");
    // await context.read<TransactionCubit>().getOldTransaction();
    //   BlocBuilder<TransactionCubit, TransactionState>(builder: (_, state) {
    //   // print(newdata);
    // BlocProvider.of<TransactionCubit>(context).getOldTransaction();
  }

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    return BlocBuilder<TransactionCubit, TransactionState>(builder: (_, state) {
      // print(state);
      if (state is TransactionLoaded) {
        if (state.transactions.length == 0) {
          return IllustrationPage(
            title: 'Ouch! Hungry',
            subtitle: "Seems you like have not \nordered any food yet",
            picturePath: 'assets/love_burger.png',
            buttonTap1: () {},
            buttonTitle1: 'Find Foods',
          );
        } else {
          print("saya berada di TransactionLoaded");
          double listItemWidth = MediaQuery.of(context).size.width - 2 * defaultMargin;
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<TransactionCubit>().getTransactions();
            },
            child: ListView(
              controller: _scrollController,
              // itemExtent: state.transactions.length + 1,
              children: [
                Column(
                  children: [
                    // *Header
                    Container(
                      height: 100,
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: defaultMargin),
                      padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Your Orders",
                            style: blackFontStyle1,
                          ),
                          Text("Wait for the best meal", style: greyFontStyle.copyWith(fontWeight: FontWeight.w300))
                        ],
                      ),
                    ),
                    // * Body
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        children: [
                          CustomTabBar(
                            titles: ['In Progress', 'Past Orders'],
                            selectedIndex: selectedIndex,
                            onTap: (index) {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Builder(builder: (_) {
                            // state.transactions.addAll(iterable)

                            List<Transaction> transaction = (selectedIndex == 0)
                                ? state.transactions
                                    .where((element) =>
                                        element.status == TransactionStatus.on_delivery ||
                                        element.status == TransactionStatus.pending)
                                    .toList()
                                : state.transactions
                                    .where((element) =>
                                        element.status == TransactionStatus.delivered ||
                                        element.status == TransactionStatus.cancelled)
                                    .toList();

                            // return Column(
                            //   children: transaction
                            //       .map((e) => Padding(
                            //             padding: const EdgeInsets.only(
                            //                 right: defaultMargin, left: defaultMargin, bottom: 16),
                            //             child: GestureDetector(
                            //                 onTap: () async {
                            //                   if (e.status == TransactionStatus.pending) {
                            //                     await launch(e.paymentUrl!);
                            //                   }
                            //                 },
                            //                 child: OrderListItem(transaction: e, itemWidth: listItemWidth)),
                            //           ))
                            //       .toList(),
                            // );

                            TransactionLoaded newItem = state as TransactionLoaded;
                            return Column(
                              children: transaction
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.only(
                                            right: defaultMargin, left: defaultMargin, bottom: 16),
                                        child: GestureDetector(
                                            onTap: () async {
                                              if (e.status == TransactionStatus.pending) {
                                                await launch(e.paymentUrl!);
                                              }
                                            },
                                            child: OrderListItem(transaction: e, itemWidth: listItemWidth)),
                                      ))
                                  .toList(),
                            );
                          }),
                          SizedBox(
                            height: 60,
                          ),
                          Container(
                            child: Center(
                                child: SizedBox(
                              child: loadingIndicator,
                            )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }
      } else if (state is TransactionLoading) {
        // return Center(child: loadingIndicator);
        print("saya berada di TransactionLoading");
        isLoading = true;
        double listItemWidth = MediaQuery.of(context).size.width - 2 * defaultMargin;
        return RefreshIndicator(
          onRefresh: () async {
            await context.read<TransactionCubit>().getTransactions();
          },
          child: ListView(
            controller: _scrollController,
            // itemExtent: state.transactions.length + 1,
            children: [
              Column(
                children: [
                  // *Header
                  Container(
                    height: 100,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: defaultMargin),
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Your Orders",
                          style: blackFontStyle1,
                        ),
                        Text("Wait for the best meal", style: greyFontStyle.copyWith(fontWeight: FontWeight.w300))
                      ],
                    ),
                  ),
                  // * Body
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      children: [
                        CustomTabBar(
                          titles: ['In Progress', 'Past Orders'],
                          selectedIndex: selectedIndex,
                          onTap: (index) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Builder(builder: (_) {
                          // state.transactions.addAll(iterable)

                          List<Transaction> transaction = (selectedIndex == 0)
                              ? state.oldTransaction
                                  .where((element) =>
                                      element.status == TransactionStatus.on_delivery ||
                                      element.status == TransactionStatus.pending)
                                  .toList()
                              : state.oldTransaction
                                  .where((element) =>
                                      element.status == TransactionStatus.delivered ||
                                      element.status == TransactionStatus.cancelled)
                                  .toList();

                          return Column(
                            children: transaction
                                .map(
                                  (e) => Padding(
                                    padding:
                                        const EdgeInsets.only(right: defaultMargin, left: defaultMargin, bottom: 16),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (e.status == TransactionStatus.pending) {
                                          await launch(e.paymentUrl!);
                                        }
                                      },
                                      child: OrderListItem(transaction: e, itemWidth: listItemWidth),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        }),
                        Container(
                          child: Center(
                              child: SizedBox(
                            child: loadingIndicator,
                          )),
                        )
                        // SizedBox(
                        //   height: 60,
                        //   child: loadingIndicator,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Center(child: loadingIndicator),
                        // )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      } else {
        isLoading = true;
        return Center(child: loadingIndicator);
        // return SizedBox(height: 20);
      }
    });
  }
}
