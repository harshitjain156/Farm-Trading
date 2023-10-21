import 'package:agro_millets/core/home/presentation/widgets/agro_category_item.dart';
import 'package:agro_millets/models/millet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AgroCategoryGridView extends StatelessWidget {
  final List<Map<String , String>> list;
  const AgroCategoryGridView({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
      horizontal: 15, vertical: 10
      ),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return AgroCategoryItem(
          index: index,
          item: list[index],
        );
      },
    );
  }
}
