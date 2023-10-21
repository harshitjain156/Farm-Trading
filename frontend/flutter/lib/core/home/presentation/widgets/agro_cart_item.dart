import 'package:agro_millets/core/cart/application/cart_manager.dart';
import 'package:agro_millets/core/cart/application/cart_provider.dart';
import 'package:agro_millets/globals.dart';
import 'package:agro_millets/models/millet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AgroCartItem extends StatefulWidget {
  final int index;
  final MilletItem item;
  final int count;
  final bool showAddCartIcon;
  final bool showCallIcon;
  final VoidCallback? onSelect;

  final bool highlight; // Add this line

  const AgroCartItem({
    super.key,
    required this.index,
    required this.item,
    this.count = 1,
    this.showAddCartIcon = true,
    this.showCallIcon = false, this.onSelect,
    required this.highlight,
  });

  @override
  _AgroCartItemState createState() => _AgroCartItemState();
}

class _AgroCartItemState extends State<AgroCartItem> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.4 * getWidth(context),
      height: 0.3 * getHeight(context),
      child: Stack(
        children: [
          Positioned.fill(
      child: InkWell(
          // onTap: this.widget.onSelect, // Add this line
          child: GestureDetector(
            onTap: () {
              this.widget.onSelect!();

            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                color: this.widget.highlight
                    ? Colors.blue
                        .withOpacity(0.2) // Change to your desired color
                    : Theme.of(context).cardColor,
                border: this.widget.highlight
                    ? Border.all(
                        color: Colors.blue) // Add a border when selected
                    : null,
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
                            this.widget.item.images[0].toString(),
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
                                  this.widget.item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "रू ${this.widget.item.price}/${this.widget.item.quantityType}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Items in stock',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${this.widget.item.quantity.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                          Consumer(builder: (context, ref, child) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                    onPressed:this.widget.count <= 1 ? null : () {
                                      // Handle the add action
                                      ref.read(cartProvider).decrementItemCount(
                                          this.widget.item.id);
                                      CartManager(context, ref, poll: false)
                                          .decrementItemCountFromCart(
                                              itemId: this.widget.item.id);
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(
                                    "${this.widget.count}",
                                    // Display the item quantity
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: this.widget.count >= this.widget.item.quantity ? null : () {
                                      // Handle the add action
                                      ref.read(cartProvider).incrementItemCount(this.widget.item.id);
                                      CartManager(context, ref, poll: false)
                                          .incrementItemCountFromCart(itemId: this.widget.item.id);
                                    },
                                    icon: const Icon(Icons.add),
                                  ),

                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ))),
          Consumer(builder: (context, ref, child) {
            return Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () async {
                  ref
                      .read(cartProvider)
                      .removeItemFromCart(this.widget.item.id);
                  CartManager(context, ref, poll: false)
                      .removeItemFromCart(itemId: this.widget.item.id);
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
                    MdiIcons.delete,
                    color: Colors.red,
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
