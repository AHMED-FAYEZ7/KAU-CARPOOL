import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kau_carpool/cubit/app_cubit.dart';
import 'package:kau_carpool/helper/app_prefs.dart';
import 'package:kau_carpool/helper/functions.dart';
import 'package:kau_carpool/helper/resources/color_manager.dart';
import 'package:kau_carpool/layout/app_layout.dart';
import 'package:kau_carpool/pages/register/register_page.dart';
import 'package:kau_carpool/widgets/custom_button.dart';
import 'package:kau_carpool/widgets/custom_text_filed.dart';

import '../../helper/constant.dart';
import 'login_cubit/login_cubit.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) {
              uId = state.uId;
              AppCubit.get(context)
                ..getUserData()
                ..getAllUsers();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppLayout(),
                  ), (route) {
                return false;
              });
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: ColorManager.backgroundColor,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  const Image(
                    image: AssetImage("assets/images/splash_logo.png"),
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 80 / 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: ColorManager.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset.zero,
                            blurRadius: 20,
                            color: ColorManager.white,
                          ),
                        ]),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: ColorManager.blueWithOpacity,
                                ),
                              ),
                            ),
                          ),
                          CustomFormTextField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            labelText: "KAU Email",
                            hintText: "Enter email here",
                            validator: (input) {},
                          ),
                          CustomFormTextField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            obscureText: LoginCubit.get(context).isPassShown,
                            suffix: LoginCubit.get(context).suffix,
                            suffixPressed: () {
                              LoginCubit.get(context).passVisibility();
                            },
                            labelText: "Password",
                            hintText: "Enter password",
                            validator: (input) {},
                          ),
                          ConditionalBuilder(
                            condition: state is! LoginLoading,
                            builder: (context) => CustomButton(
                              width: 100,
                              text: "Login",
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                            ),
                            fallback: (context) => Center(
                                child: CircularProgressIndicator(
                              color: ColorManager.primary,
                            )),
                          ),
                          Center(
                            child: Text(
                              "OR",
                              style: TextStyle(
                                fontSize: 20,
                                color: ColorManager.blueWithOpacity,
                              ),
                            ),
                          ),
                          CustomButton(
                            width: 100,
                            text: "Sign Up",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
