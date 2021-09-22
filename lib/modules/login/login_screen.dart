import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layouts/home_layout.dart';
import 'package:shop/modules/login/cubit/login_cubit.dart';
import 'package:shop/modules/login/cubit/login_states.dart';
import 'package:shop/modules/register/register_screen.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/network/constants.dart';
import 'package:shop/shared/network/local/cache_helper.dart';
import 'package:shop/shared/styles/themes.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void _login(cubit) {
    if (formKey.currentState.validate()) {
      cubit.userLogin(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

         
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          print(state.error);
          showToast(
              toastText: state.error.toString(), toastColor: ToastColor.ERROR);
        } else if (state is LoginSuccessState) {
          if (state.userModel.status) {
            showToast(
                    toastText: state.userModel.message,
                    toastColor: ToastColor.SUCESS)
                .then((value) {
              CacheHelper.setData(
                      key: 'token', value: state.userModel.data.token)
                  .then((value) {
                token = state.userModel.data.token;
                navigateAndReplacment(context, HomeLayout());
              });
            });
            print(state.userModel.data.token);
          } else {
            showToast(
                toastText: state.userModel.message,
                toastColor: ToastColor.ERROR);
          }
        }
      },
      builder: (context, state) {
        var cubit = LoginCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: defaultColor,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: defaultColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome,',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(
                                    color: defaultColor,
                                    fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Sign in to continue!',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: Colors.grey),
                          ),
                        const  SizedBox(
                            height: 30,
                          ),
                          defaultTextField(
                              label: 'Email',
                              controller: emailController,
                              prefixIcon: Icons.email_outlined,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter your email address';
                                }
                              },
                              keyboardType: TextInputType.emailAddress),
                         const SizedBox(
                            height: 20,
                          ),
                          defaultTextField(
                            label: 'Password',
                            controller: passwordController,
                            prefixIcon: Icons.lock_outline,
                            isPassword: cubit.isPasswordInvisible,
                            onSubmit: (String value) {
                              _login(cubit);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'password cannot be too short';
                              }
                            },
                            onIconPressed: cubit.changePasswordVisibility,
                            suffixIcon: Icons.visibility,
                            keyboardType: TextInputType.number,
                          ),
                        const  SizedBox(
                            height: 30,
                          ),
                          state is LoginLoadingState
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : defaultButton('login'.toUpperCase(), () {

                                  _login(cubit);
                                } , context),
                        const  SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              TextButton(
                                  onPressed: () {
                                    navigateTo(context, RegisterScreen());
                                  },
                                  child: Text('Register',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(color: defaultColor)))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
