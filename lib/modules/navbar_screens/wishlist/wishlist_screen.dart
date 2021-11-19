import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/modules/navbar_screens/cubit/home_cubit.dart';
import 'package:shop/modules/navbar_screens/cubit/home_states.dart';
import 'package:shop/shared/components/components.dart';

class WishListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomeGetFavoritesLoadingState) {
          Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        if (cubit.favoriteModel.data!.data.isEmpty) {
          return Center(
            child: Text('No Favorites' , style: Theme.of(context).textTheme.bodyText1,),
          );
        }
        return ListView.separated(
          separatorBuilder: (context , index) => const Divider(
           
          ),
            itemCount: cubit.favoriteModel.data!.data.length,
            itemBuilder: (context, index) {
              print(cubit.favoriteModel.data?.data.length);
              return buildListViewItems(
                  cubit.favoriteModel.data?.data[index].product,
                  context,
                  cubit);
            });
      },
    );
  }
}
