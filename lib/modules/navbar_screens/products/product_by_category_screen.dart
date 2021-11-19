import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/modules/navbar_screens/cubit/home_cubit.dart';
import 'package:shop/modules/navbar_screens/cubit/home_states.dart';
import 'package:shop/shared/components/components.dart';

class ProductsByCategoryScreen extends StatelessWidget {
  final String title;
  ProductsByCategoryScreen(this.title);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        print(cubit.products![0].name);
        if (state is HomeGetProductsByCategoryLoadingState)
          Center(
            child: CircularProgressIndicator(),
          );
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '$title',
              style: appBarStyle(context),
            ),
          ),
          body: cubit.productsByCategoryModel.data!.data.isEmpty
              ? Center(
                  child: Text(
                    'No data'.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 0.6),
                      itemCount: cubit.productsByCategoryModel.data!.data.length,
                      itemBuilder: (context, index) => Container(
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: buildGridItems(
                                cubit.productsByCategoryModel.data!.data[index],
                                context,
                                cubit),
                          ))),
        );
      },
    );
  }
}
