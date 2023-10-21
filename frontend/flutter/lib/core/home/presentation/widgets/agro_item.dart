import 'package:agro_millets/core/cart/application/cart_manager.dart';
import 'package:agro_millets/core/cart/application/cart_provider.dart';
import 'package:agro_millets/core/home/presentation/detail/item_detail.dart';
import 'package:agro_millets/data/cache/app_cache.dart';
import 'package:agro_millets/globals.dart';
import 'package:agro_millets/models/cart_item.dart';
import 'package:agro_millets/models/millet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AgroItem extends StatelessWidget {
  /// Index is for sizing
  final int index;
  final MilletItem item;
  final bool showAddCartIcon;
  final bool showCallIcon;

  const AgroItem({
    super.key,
    required this.index,
    required this.item,
    this.showAddCartIcon = true,
    this.showCallIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.4 * getWidth(context),
      height: 0.3 * getHeight(context),
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                goToPage(context, ItemDetailPage(item: item));
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
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
                              item.images[0].toString(),
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey.withOpacity(0.2),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "रू ${item.price}/${item.quantityType}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  },
                ),

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
                    CartItem cartItem = CartItem(item: item.id, count: 1);
                    ref.read(cartProvider).addItemToCart(cartItem);
                    CartManager(context, ref, poll: false)
                        .addItemToCart(item: cartItem);
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
        ],
      ),
    );
  }
}
