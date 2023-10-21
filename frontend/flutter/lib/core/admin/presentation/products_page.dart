import 'package:agro_millets/colors.dart';
import 'package:agro_millets/core/admin/application/admin_apis.dart';
import 'package:agro_millets/core/home/presentation/detail/item_detail.dart';
import 'package:agro_millets/globals.dart';
import 'package:agro_millets/models/millet_item.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: const Text("All Products")),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: AdminAPIs.getAllItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else if (snapshot.hasData) {
            List<MilletItem> list = snapshot.data ?? [];
            
            return Container(
              color: Colors.white,
            child: ClipRect(
              
              child: ListView.builder(
                
                itemCount: (list.length / 2).ceil(),
                itemBuilder: (context, rowIndex) {
                  final index1 = rowIndex * 2;
                  final index2 = index1 + 1;

                  return Row(
                    children: [
                      if (index1 < list.length)
                        _buildProductCard(context, list[index1]),
                      if (index2 < list.length)
                        _buildProductCard(context, list[index2]),
                        if (index2 >= list.length && list.length % 2 != 0)
                        Spacer(),
                    ],
                  );
                },
              ),
            ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, MilletItem item) {
    return Expanded(
      child: Card(
        color: Colors.white,
        elevation: 2,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () {
            goToPage(context, ItemDetailPage(item: item));
          },
          child: Row(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item.images[0]),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      timeago.format(item.listedAt),
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "रू ${item.price}",
                      style: TextStyle(
                        color: semiDarkColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
