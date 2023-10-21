import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agro_millets/core/home/application/home_manager.dart';
import 'package:agro_millets/core/home/application/home_provider.dart';
import 'package:agro_millets/models/order_item.dart';
import 'package:agro_millets/globals.dart';
import 'package:agro_millets/main.dart';
import '../../../data/cache/app_cache.dart';
import '../../../models/millet_item.dart';
import '../../home/presentation/widgets/agro_item_order.dart';

class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({super.key});

  @override
  ConsumerState<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> {
  late HomeManager homeManager;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    homeManager = HomeManager(context, ref);
    super.initState();
    // Trigger refresh when the widget initializes
    _refreshIndicatorKey.currentState?.show();
  }

  @override
  void dispose() {
    homeManager.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    // Add your refresh logic here, e.g., fetching updated data
    await Future.delayed(Duration(seconds: 2)); // Simulating a delay

    // You may want to update the state with new data if needed

    // Call setState to rebuild the widget
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
        actions: [
          IconButton(
            icon: Icon(Icons.home), // Add the home icon
            onPressed: () {
              goToPage(context, const RolePage(), clearStack: true);
              // Navigator.of(context).pop(); // Navigate back to the home screen
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Consumer(
            builder: (context, ref, child) {
              Future<List<MilletOrder>> orders;
              if (appCache.isFarmer()) {
                orders = getAllDeliveries(appState.value.user);
              } else {
                orders = getAllOrders(appState.value.user);
              }

              return FutureBuilder<List<MilletOrder>>(
                future: orders,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator()); // Show loading indicator
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error Occurred: ${snapshot.error}"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text("No Orders Found"),
                    );
                  } else {
                    List<MilletOrder>? orderList = snapshot.data;

                    return MasonryGridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        bottom: 30.0,
                      ),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemCount: orderList?.length,
                      itemBuilder: (context, index) {
                        // Get the item associated with the order asynchronously
                        return FutureBuilder<MilletItem?>(
                          future: getItemById(orderList![index].item),
                          builder: (context, itemSnapshot) {
                            if (itemSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            } else if (itemSnapshot.hasError) {
                              return Center(
                                child:
                                Text("Error Occurred: ${itemSnapshot.error}"),
                              );
                            } else if (!itemSnapshot.hasData) {
                              return Container(); // Handle the case when data is not available
                            } else {
                              // Data for both order and item is available
                              return AgroItemOrder(
                                index: index,
                                item: itemSnapshot.data!,
                                itemOrder: orderList[index],
                                showAddCartIcon: false,
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
