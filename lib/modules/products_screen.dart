import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/shared/resources/color_manager.dart';

import '../layout/cubit/cubit.dart';
import '../layout/cubit/states.dart';
import '../models/categories_model.dart';
import '../models/home_model.dart';
import '../shared/components/components/components.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if (!state.model!.status!) {
            showToast(
              text: state.model!.message!,
              state: ToastStates.ERROR,
            );
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).homeModel != null &&
              ShopCubit.get(context).categoriesModel != null,
          builder: (context) => builderWidget(ShopCubit.get(context).homeModel!,
              ShopCubit.get(context).categoriesModel!, context),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget builderWidget(
          HomeModel model, CategoriesModel categoriesModel, context) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model.data!.banners!
                  .map(
                    (e) => Image(
                      image: NetworkImage(e.image!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 200,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 100.0,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          buildCategoryItem(categoriesModel.data!.data[index]),
                      separatorBuilder: (context, index) => SizedBox(
                        width: 10.0,
                      ),
                      itemCount: categoriesModel.data!.data.length,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                childAspectRatio: 1 / 1.58,
                children: List.generate(
                  model.data!.products!.length,
                  (index) =>
                      buildGridProduct(model.data!.products![index], context),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildCategoryItem(DataModel model) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage(model.image!),
            height: 100.0,
            width: 100.0,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(
              .8,
            ),
            width: 100.0,
            child: Text(
              model.name!,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );

  Widget buildGridProduct(ProductModel model, context) => Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(model.image!),
                  width: double.infinity,
                  height: 200.0,
                ),
                if (model.discount != 0)
                  Container(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    child: Text(
                      'DISCOUNT',
                      style: TextStyle(
                        fontSize: 8.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price.round()}',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: ColorManager.defaultColor,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      if (model.discount != 0)
                        Text(
                          '${model.oldPrice.round()}',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changeFavorites(model.id!);
                          print(model.id);
                        },
                        icon: CircleAvatar(
                          radius: 15.0,
                          backgroundColor:
                              ShopCubit.get(context).favorites[model.id]!
                                  ? ColorManager.defaultColor
                                  : Colors.grey,
                          child: Icon(
                            Icons.favorite_border,
                            size: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ShopCubit, ShopState>(
//       listener: (context, state) {
//         if (state is ShopSuccessChangeFavoritesState) {
//           if (!(state.model.status ?? true)) {
//             showToast(
//               text: state.model.message.toString(),
//               state: ToastStates.ERROR,
//             );
//           }
//         }
//       },
//       builder: (context, state) {
//         ShopCubit cubit = ShopCubit.get(context);

//         return ConditionalBuilder(
//           condition: ShopCubit.get(context).homeModel != null &&
//               ShopCubit.get(context).categoriesModel != null,
//           builder: (context) =>
//               productsBuilder(cubit.homeModel, cubit.categoriesModel, context),
//           fallback: (context) => const Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       },
//     );
//   }

//   Widget productsBuilder(
//           HomeModel? model, CategoriesModel? categoriesModel, context) =>
//       SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: CarouselSlider(
//                 items: model?.data!.banners
//                     ?.map(
//                       (e) => Image(
//                         image: NetworkImage(e.image.toString()),
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                       ),
//                     )
//                     .toList(),
//                 options: CarouselOptions(
//                   height: 200,
//                   viewportFraction: 1.0,
//                   enlargeCenterPage: false,
//                   initialPage: 0,
//                   enableInfiniteScroll: true,
//                   reverse: false,
//                   autoPlay: true,
//                   autoPlayInterval: const Duration(seconds: 3),
//                   // autoPlayAnimationDuration: Duration(seconds: 1),
//                   autoPlayCurve: Curves.fastOutSlowIn,
//                   scrollDirection: Axis.horizontal,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 10.0,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 10.0,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Categories',
//                     style: TextStyle(
//                       fontSize: 24.0,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10.0,
//                   ),
//                   SizedBox(
//                     height: 100.0,
//                     child: ListView.separated(
//                       physics: const BouncingScrollPhysics(),
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (context, index) =>
//                           buildCategoryItem(categoriesModel!.data!.data[index]),
//                       separatorBuilder: (context, index) => const SizedBox(
//                         width: 10.0,
//                       ),
//                       itemCount: categoriesModel!.data!.data.length,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20.0,
//                   ),
//                   const Text(
//                     'New Products',
//                     style: TextStyle(
//                       fontSize: 24.0,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 10.0,
//             ),
//             Container(
//               color: Colors.grey[300],
//               child: GridView.count(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 1.0,
//                 crossAxisSpacing: 1.0,
//                 childAspectRatio: 1 / 1.58,
//                 children: List.generate(
//                   model!.data!.products!.length,
//                   (index) =>
//                       buildGridProduct(model.data!.products![index], context),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );

//   Widget buildCategoryItem(DataModel? model) => Stack(
//         alignment: AlignmentDirectional.bottomCenter,
//         children: [
//           Image(
//             image: NetworkImage(model!.image.toString()),
//             height: 100.0,
//             width: 100.0,
//             fit: BoxFit.cover,
//           ),
//           Container(
//             color: Colors.black.withOpacity(
//               .8,
//             ),
//             width: 100.0,
//             child: Text(
//               model.name.toString(),
//               textAlign: TextAlign.center,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       );

//   Widget buildGridProduct(ProductModel model, context) => Container(
//         color: Colors.white,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               alignment: AlignmentDirectional.bottomStart,
//               children: [
//                 Image(
//                   image: NetworkImage(model.image.toString()),
//                   width: double.infinity,
//                   height: 200.0,
//                 ),
//                 if (model.discount != 0)
//                   Container(
//                     color: Colors.red,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 5.0,
//                     ),
//                     child: const Text(
//                       'DISCOUNT',
//                       style: TextStyle(
//                         fontSize: 8.0,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     model.name.toString(),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 14.0,
//                       height: 1.3,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         '${model.price.round()}',
//                         style: TextStyle(
//                           fontSize: 12.0,
//                           color: ColorManager.defaultColor,
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 5.0,
//                       ),
//                       if (model.discount != 0)
//                         Text(
//                           '${model.oldPrice.round()}',
//                           style: const TextStyle(
//                             fontSize: 10.0,
//                             color: Colors.grey,
//                             decoration: TextDecoration.lineThrough,
//                           ),
//                         ),
//                       const Spacer(),
//                       IconButton(
//                         icon: CircleAvatar(
//                           radius: 15.0,
//                           backgroundColor:
//                               ShopCubit.get(context).favorites[model.id!] ??
//                                       false
//                                   ? ColorManager.defaultColor
//                                   : ColorManager.grey,
//                           child: Icon(
//                             Icons.favorite_border,
//                             size: 14.0,
//                             color: ColorManager.white,
//                           ),
//                         ),
//                         onPressed: () {
//                           ShopCubit.get(context).changeFavorites(model.id!);
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
// }
