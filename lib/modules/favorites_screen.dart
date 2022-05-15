import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/shared/resources/color_manager.dart';

import '../layout/cubit/cubit.dart';
import '../layout/cubit/states.dart';
import '../models/favorites_model.dart';
import '../shared/components/components/components.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is! ShopLoadingGetFavoritesState,
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) => buildListProduct(
                ShopCubit.get(context)
                    .favoritesModel!
                    .data!
                    .data![index]
                    .product,
                context),
            separatorBuilder: (context, index) => myDivider(),
            itemCount:
                ShopCubit.get(context).favoritesModel!.data!.data!.length,
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ShopCubit, ShopStates>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         return ConditionalBuilder(
//           condition: state is! ShopLoadingGetFavoritesState,
//           builder: (context) => ListView.separated(
//             itemBuilder: (context, index) => buildFavItem(
//                 ShopCubit.get(context).favoritesModel!.data!.data![index],
//                 context),
//             separatorBuilder: (context, index) => myDivider(),
//             itemCount:
//                 ShopCubit.get(context).favoritesModel!.data!.data!.length,
//           ),
//           fallback: (context) => Center(child: CircularProgressIndicator()),
//         );
//       },
//     );
//   }

//   Widget buildFavItem(FavoritesData model, context) => Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Container(
//           height: 120.0,
//           child: Row(
//             children: [
//               Stack(
//                 alignment: AlignmentDirectional.bottomStart,
//                 children: [
//                   Image(
//                     image: NetworkImage(model.product!.image!),
//                     width: 120.0,
//                     height: 120.0,
//                   ),
//                   if (model.product!.discount != 0)
//                     Container(
//                       color: Colors.red,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 5.0,
//                       ),
//                       child: Text(
//                         'DISCOUNT',
//                         style: TextStyle(
//                           fontSize: 8.0,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               SizedBox(
//                 width: 20.0,
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       model.product!.name!,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontSize: 14.0,
//                         height: 1.3,
//                       ),
//                     ),
//                     Spacer(),
//                     Row(
//                       children: [
//                         Text(
//                           model.product!.price.toString(),
//                           style: TextStyle(
//                             fontSize: 12.0,
//                             color: ColorManager.defaultColor,
//                           ),
//                         ),
//                         SizedBox(
//                           width: 5.0,
//                         ),
//                         if (model.product!.discount != 0)
//                           Text(
//                             model.product!.oldPrice.toString(),
//                             style: TextStyle(
//                               fontSize: 10.0,
//                               color: Colors.grey,
//                               decoration: TextDecoration.lineThrough,
//                             ),
//                           ),
//                         Spacer(),
//                         IconButton(
//                           onPressed: () {
//                             ShopCubit.get(context)
//                                 .changeFavorites(model.product!.id!);
//                           },
//                           icon: CircleAvatar(
//                             radius: 15.0,
//                             backgroundColor: ShopCubit.get(context)
//                                     .favorites[model.product!.id]!
//                                 ? ColorManager.defaultColor
//                                 : Colors.grey,
//                             child: Icon(
//                               Icons.favorite_border,
//                               size: 14.0,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
// }




//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ShopCubit, ShopState>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         return ConditionalBuilder(
//           condition: state is! ShopLoadingGetFavoritesState,
//           builder: (context) => ListView.separated(
//             itemBuilder: (context, index) => buildFavItem(
//                 ShopCubit.get(context).favoritesModel.data!.data![index],
//                 context),
//             separatorBuilder: (context, index) => myDivider(),
//             itemCount: ShopCubit.get(context).favoritesModel.data!.data!.length,
//           ),
//           fallback: (context) =>
//               const Center(child: CircularProgressIndicator()),
//         );
//       },
//     );
//   }

//   Widget buildFavItem(FavoritesData model, context) => Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SizedBox(
//           height: 120.0,
//           child: Row(
//             children: [
//               Stack(
//                 alignment: AlignmentDirectional.bottomStart,
//                 children: [
//                   Image(
//                     image: NetworkImage(model.product!.image.toString()),
//                     width: 120.0,
//                     height: 120.0,
//                   ),
//                   if (model.product!.discount != 0)
//                     Container(
//                       color: Colors.red,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 5.0,
//                       ),
//                       child: const Text(
//                         'DISCOUNT',
//                         style: TextStyle(
//                           fontSize: 8.0,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(
//                 width: 20.0,
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       model.product!.name.toString(),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 14.0,
//                         height: 1.3,
//                       ),
//                     ),
//                     const Spacer(),
//                     Row(
//                       children: [
//                         Text(
//                           model.product!.price.toString(),
//                           style: TextStyle(
//                             fontSize: 12.0,
//                             color: ColorManager.defaultColor,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 5.0,
//                         ),
//                         if (model.product!.discount != 0)
//                           Text(
//                             model.product!.oldPrice.toString(),
//                             style: const TextStyle(
//                               fontSize: 10.0,
//                               color: Colors.grey,
//                               decoration: TextDecoration.lineThrough,
//                             ),
//                           ),
//                         const Spacer(),
//                         IconButton(
//                           onPressed: () {
//                             ShopCubit.get(context)
//                                 .changeFavorites(model.product!.id!.toInt());
//                           },
//                           icon: CircleAvatar(
//                             radius: 15.0,
//                             backgroundColor: ShopCubit.get(context)
//                                         .favorites[model.product!.id] ??
//                                     false
//                                 ? ColorManager.defaultColor
//                                 : Colors.grey,
//                             child: const Icon(
//                               Icons.favorite_border,
//                               size: 14.0,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
// }
