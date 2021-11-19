import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/modules/navbar_screens/cubit/home_cubit.dart';
import 'package:shop/modules/navbar_screens/cubit/home_states.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/styles/themes.dart';

class ProductDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomeChangeFavoritesSuccessState) {
          if (!state.model!.status!) {
            showToast(
                toastText: state.model!.message, toastColor: ToastColor.ERROR);
          } else {
            showToast(
                toastText: state.model!.message, toastColor: ToastColor.SUCESS);
          }
        }
        if (state is HomeChangeCartSuccessState) {
          if (!state.model!.status!) {
            showToast(
                toastText: state.model!.message, toastColor: ToastColor.ERROR);
          } else {
            showToast(
                toastText: state.model!.message, toastColor: ToastColor.SUCESS);
          }
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
            appBar: AppBar(
              title: Text(
                'Product Details',
                style: appBarStyle(context),
              ),
            ),
            body: Column(
              children: [
                if (cubit.productsDetails.data == null)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                buildBody(context, cubit),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: defaultButton(
                            cubit.cart[cubit.productsDetails.data?.id] == true
                                ? 'added to cart'.toUpperCase()
                                : 'add to cart'.toUpperCase(), () {
                          cubit.addToOrRemoveFromCart(
                              cubit.productsDetails.data?.id);
                        }, context,
                            color: cubit.cart[cubit.productsDetails.data?.id]!
                                ? defaultColor
                                : Colors.grey.withOpacity(0.8)),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            cubit.changeFavorites(
                                cubit.productsDetails.data!.id);
                          },
                          icon:
                              cubit.favorites[cubit.productsDetails.data!.id] ==
                                      true
                                  ? Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 35,
                                    )
                                  : Icon(
                                      Icons.favorite_border,
                                      color: Colors.red,
                                      size: 35,
                                    ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ));
      },
    );
  }

  Widget buildBody(BuildContext context, HomeCubit cubit) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: cubit.productsDetails.data!.image == null
                  ? Center(child: Icon(Icons.broken_image))
                  : Center(
                    child: CachedNetworkImage(
                        imageUrl: '${cubit.productsDetails.data!.image}',
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                  ),
            ),
            Row(
              children: [
                cubit.productsDetails.data!.oldPrice == null ||
                        cubit.productsDetails.data!.oldPrice ==
                            cubit.productsDetails.data!.price
                    ? SizedBox.shrink()
                    : Text(
                        '${cubit.productsDetails.data!.oldPrice}',
                        style:
                            TextStyle(decoration: TextDecoration.lineThrough),
                      ),
                cubit.productsDetails.data!.oldPrice == null ||
                        cubit.productsDetails.data!.oldPrice ==
                            cubit.productsDetails.data!.price
                    ? SizedBox.shrink()
                    : Spacer(),
                Text(
                  '${kFormatCurrency.format(cubit.productsDetails.data!.price)}',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: defaultColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${cubit.productsDetails.data!.name}',
            
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Text(
                  'Details',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Spacer(),
                IconButton(
                  icon: Icon(cubit.iconData),
                  onPressed: () {
                    cubit.changeExtendDetails();
                  },
                )
              ],
            ),
            cubit.isDetailsPressed
                ? Text(
                    '${cubit.productsDetails.data!.description}',
                  
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                : Container(),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
