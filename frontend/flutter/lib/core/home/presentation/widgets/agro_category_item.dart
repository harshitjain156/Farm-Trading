import 'package:agro_millets/core/cart/application/cart_manager.dart';
import 'package:agro_millets/core/cart/application/cart_provider.dart';
import 'package:agro_millets/core/home/presentation/category_page.dart';
import 'package:agro_millets/core/home/presentation/detail/item_detail.dart';
import 'package:agro_millets/data/cache/app_cache.dart';
import 'package:agro_millets/globals.dart';
import 'package:agro_millets/models/cart_item.dart';
import 'package:agro_millets/models/millet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AgroCategoryItem extends StatelessWidget {
  /// Index is for sizing
  final int index;
  // final List item;
  final Map<String, String> item;
  final bool showAddCartIcon;

  const AgroCategoryItem({
    super.key,
    required this.index,
    required this.item,
    this.showAddCartIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    String image_path = "assets/logo_app.png";
    return SizedBox(
      width: 0.5 * getWidth(context),
      height:
          0.3 * getHeight(context),
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                goToPage(context,CategoryPage(category: item.keys.toList()[0],));
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5.0,
                      spreadRadius: 3.0,
                      offset: const Offset(5.0, 5.0),
                    )
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: LayoutBuilder(builder: (context, constraints) {
                  if (item.keys.toList()[0] == 'fruits' ) {
                    image_path = 'assets/fruitss_11zon.jpg';
                  }
                  if (item.keys.toList()[0] == 'vegetables' ) {
                    image_path = 'assets/vege_11zon.jpg';
                  }
                  if (item.keys.toList()[0] == 'cereals' ) {
                    image_path = 'assets/cere_11zon.jpg';
                  }if (item.keys.toList()[0] == 'livestock' ) {
                    image_path = 'assets/cow_11zon.jpg';
                  }
                  if (item.keys.toList()[0] == 'oil' ) {
                    image_path = 'assets/oil_11zon.jpg';
                  }
                  if (item.keys.toList()[0] == 'pulses' ) {
                    image_path = 'assets/garmss_11zon.jpg';
                  }
                  if (item.keys.toList()[0] == 'cash' ) {
                    image_path = 'assets/beans_11zon.jpg';
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                          ),
                          child: Image.asset(
                            image_path,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            // loadingBuilder: (context, child, loadingProgress) {
                            //   if (loadingProgress == null) return child;
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
                                  width: 0.8 * constraints.maxWidth,
                                  child: Text(
                                    item.values.toList()[0],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: null,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                  ),
                                )
                              ],
                            )
                          ]),
                    ],
                  );
                }),
              ),
            ),
          ),
          if (showAddCartIcon && !appCache.isAdmin() && !appCache.isFarmer())
            Consumer(builder: (context, ref, child) {
              return Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () async {
                    // CartItem cartItem = CartItem(item: item.id, count: 1);
                    // ref.read(cartProvider).addItemToCart(cartItem);
                    // CartManager(context, ref, poll: false)
                    //     .addItemToCart(item: cartItem);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
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
                    child: const Icon(
                      MdiIcons.cartPlus,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            }),
          // if (!showAddCartIcon)
          //   Consumer(builder: (context, ref, child) {
          //     return Positioned(
          //       right: 0,
          //       top: 0,
          //       child: GestureDetector(
          //         onTap: () async {
          //           // ref.read(cartProvider).removeItemFromCart(item.id);
          //           // CartManager(context, ref, poll: false)
          //           //     .removeItemFromCart(itemId: item.id);
          //         },
          //         child: Container(
          //           width: 40,
          //           height: 40,
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             boxShadow: [
          //               BoxShadow(
          //                 color: Colors.black.withOpacity(0.05),
          //                 blurRadius: 5.0,
          //                 spreadRadius: 3.0,
          //                 offset: const Offset(0.0, 0.0),
          //               )
          //             ],
          //             borderRadius: BorderRadius.circular(10.0),
          //           ),
          //           child: const Icon(
          //             MdiIcons.delete,
          //             color: Colors.red,
          //           ),
          //         ),
          //       ),
          //     );
          //   }),
        ],
      ),
    );
  }
}
