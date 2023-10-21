import 'package:agro_millets/core/home/presentation/widgets/order_details.dart';
import 'package:agro_millets/data/cache/app_cache.dart';
import 'package:agro_millets/globals.dart';
import 'package:agro_millets/models/millet_item.dart';
import 'package:agro_millets/models/order_item.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../../application/home_manager.dart';

class AgroItemOrder extends StatefulWidget {
  final int index;
  final MilletItem item;
  final MilletOrder itemOrder;
  final bool showAddCartIcon;
  final bool showCallIcon;

  const AgroItemOrder({
    super.key,
    required this.index,
    required this.item,
    required this.itemOrder,
    this.showAddCartIcon = true,
    this.showCallIcon = false,
  });

  @override
  _AgroItemOrderState createState() => _AgroItemOrderState();
}

class _AgroItemOrderState extends State<AgroItemOrder> {
   String selectedStatus='Processing';


  @override
  void initState() {
    super.initState();
    selectedStatus = widget.itemOrder.status;

  }

  @override
  Widget build(BuildContext context) {
    // isDelivered = widget.itemOrder.isDelivered;
    // selectedStatus=widget.itemOrder.status;
    return SizedBox(
      width: 0.5 * getWidth(context),
      height: 0.3 * getHeight(context),
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => OrderDetails(item:widget.item,itemOrder:widget.itemOrder)));
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5.0,
                      spreadRadius: 3.0,
                      offset: const Offset(
                          0.0, 0.0), // Adjust the offset to avoid overlap
                    ),
                  ],
                ),
                // Container properties...
                child: LayoutBuilder(builder: (context, constraints) {
                  return Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                          ),
                          child: Image.network(
                            widget.item.images[0].toString(),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            // loadingBuilder: (context, child, loadingProgress) {
                            //   // if (loadingProgress == null) return child;
                            //   return Container(
                            //     color: Colors.grey.withOpacity(0.2),
                            //   );
                            // },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 1 * constraints.maxWidth,
                                  child: Text(
                                    widget.item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: null,
                                    ),
                                    // maxLines: 1,
                                    // overflow: TextOverflow.fade,
                                  ),
                                ),
                                // const Spacer(),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "${widget.itemOrder.quantity} ${widget.itemOrder.quantityType}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300),
                                ),
                                const Spacer(),
                                Text(
                                  "रू ${widget.itemOrder.price}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     // Text(
                            //     //   "Delivery in",
                            //     //   style: const TextStyle(
                            //     //       fontWeight: FontWeight.w100),
                            //     // ),
                            //     // const Spacer(),
                            //     // Text(
                            //     //   "2 days",
                            //     //   style: const TextStyle(
                            //     //       fontWeight: FontWeight.w100),
                            //     // ),
                            //   ],
                            // ),
                            if (appCache.isCustomer())
                              Row(
                                children: [
                                  Text(
                                    "Contact Farmer",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            if (appCache.isFarmer())
                              Row(
                                children: [
                                  Text(
                                    "Contact Wholesaler",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            if (appCache.isCustomer())
                              Row(
                                children: [
                                  Text(
                                    "${widget.itemOrder.phoneFarmer.replaceAll('+977', '')}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w100),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () => UrlLauncher.launch(
                                        'tel://${widget.itemOrder.phoneFarmer}'),
                                    icon: const Icon(MdiIcons.phoneDial),
                                  ),
                                ],
                              ),
                            if (appCache.isFarmer())
                              Row(
                                children: [
                                  Text(
                                    "${widget.itemOrder.phoneCustomer.replaceAll('+977', '')}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w100),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () => UrlLauncher.launch(
                                        'tel://${widget.itemOrder.phoneCustomer}'),
                                    icon: const Icon(MdiIcons.phoneDial),
                                  ),
                                ],
                              ),

                            if (widget.itemOrder.isPaid)
                            Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 150,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 5.0,
                                        spreadRadius: 3.0,
                                        offset: const Offset(0.0, 0.0),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.money_outlined,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Paid',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (!widget.itemOrder.isPaid)
                            Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 150,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 5.0,
                                        spreadRadius: 3.0,
                                        offset: const Offset(0.0, 0.0),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.money_outlined,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Unpaid',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ]),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
