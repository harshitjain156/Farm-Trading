import 'package:agro_millets/data/cache/app_cache.dart';
import 'package:agro_millets/models/millet_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../models/order_item.dart';
import '../../application/home_manager.dart';

class OrderDetails extends StatefulWidget {
  final MilletItem? item;
  final MilletOrder? itemOrder;

  const OrderDetails({Key? key, this.item, this.itemOrder}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.itemOrder?.status;
    print('--selectedStatus---');
    print(selectedStatus);
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) => SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight),
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildOrderInfoContainer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Order Details', style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
          CloseButton(),
        ],
      ),
    );
  }

  Widget _buildOrderInfoContainer() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.16), offset: Offset(0, 5), blurRadius: 10.0)],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOrderImage(),
          _buildUserSpecificInfo(),
          _buildTile('Name', widget.item?.name),
          if (appCache.isCustomer() || appCache.isFarmer())
            _buildStatusTile(),
          _buildTile('Order Id', widget.itemOrder?.id),
          _buildTile('Quantity', "${widget.itemOrder?.quantity}"),
          _buildTile('Price/item', "${widget.item?.price}"),
          _buildTile('Mode of payment', "${widget.itemOrder?.modeOfPayment}"),
          _buildTile('Paid', "${widget.itemOrder?.isPaid}"),
          _buildTile('Date/Time of Order', '${DateFormat('MMMM d, y').format(widget.itemOrder!.listedAt)}'),
          Divider(),
          _buildTile('Total', 'रू ${widget.itemOrder?.price}', isBold: true),
        ],
      ),
    );
  }

  Widget _buildOrderImage() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.item?.images[0] ?? ''),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildTile(String title, String? value, {bool isBold = false}) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: isBold ? 20 : null, fontWeight: isBold ? FontWeight.bold : null)),
      trailing: Text(value ?? '', style: TextStyle(fontSize: isBold ? 20 : null, fontWeight: isBold ? FontWeight.bold : null)),
    );
  }
  Widget _buildUserSpecificInfo() {
    if (appCache.isAdmin() || appCache.isCustomer()) {
      return _buildTile('Ordered From', widget.item?.farmer);
    }
    return SizedBox.shrink();
  }
  Widget _buildStatusTile() {
    return appCache.isFarmer()
        ? ListTile(
      title: Text('Status'),
      trailing:
      DropdownButton<String>(
        value: selectedStatus,
        onChanged: (String? newValue) {
          setState(() {
            updateOrderStatus(widget.itemOrder!.id, newValue!); // Uncomment this line if the method is defined.
            selectedStatus = newValue;
          });
        },
        items: ['Processing', 'Packaging', 'Delivered'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          );
        }).toList(),
      ),
    )
        : _buildTile('Status', widget.itemOrder?.status);


  }}
