import 'package:agro_millets/core/home/presentation/widgets/agro_item.dart';
import 'package:agro_millets/models/millet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AgroCategoryFilterGridView extends StatelessWidget {
  final List<MilletItem> list;
  final String category;
  const AgroCategoryFilterGridView({super.key, required this.list,required this.category});

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
        //print(category);
        //print(list[index].category);
        if (category == list[index].category )
          {
            return AgroItem(
              index: index,
              item: list[index],
            );
          } else {
          return Container();
        }
      },
    );
  }
}
