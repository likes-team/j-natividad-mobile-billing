import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jnb_mobile/features/app/view/components/loader_component.dart';
import 'package:jnb_mobile/features/login/bloc/login_cubit.dart';
import 'package:jnb_mobile/features/login/components/password_textfield.dart';
import 'package:jnb_mobile/utilities/colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginCubit _loginCubit;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // final userProvider = UserProvider();
  @override
  void initState() {
    super.initState();

    _loginCubit = BlocProvider.of<LoginCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      bloc: _loginCubit,
      listener: (context, state) {
        switch(state.status){
          case LoginStatus.loading:
            break;
          case LoginStatus.success:
            break;
          case LoginStatus.error:
            showTopSnackBar(
              context,
              CustomSnackBar.error(
                message: state.statusMessage,
              ),
            );
            break;
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.blueGrey.shade900,
          appBar: null,
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Container(
                    child: SafeArea(
                      child: Container(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.only(top: 20.0),
                                width: 150,
                                height: 150,
                                child: Image(
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/image/logo.png'),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Container(
                                  child: Align(
                                child: (Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )),
                              )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, bottom: 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Username',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20.0),
                              height: 50.0,
                              width: MediaQuery.of(context).size.width - 100,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _usernameController,
                                decoration: new InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFEFEFEF),
                                  hintText: "Enter your username",
                                  contentPadding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 10.0,
                                      left: 10.0,
                                      right: 20.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide:
                                          BorderSide(color: Color(0xFFEFEFEF))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide:
                                          BorderSide(color: Color(0xFFEFEFEF))),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, bottom: 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Enter your password',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            PasswordTextField(
                                passwordController: _passwordController),
                            // SizedBox(
                            //   height: 20,
                            // ),
                            // Container(
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: <Widget>[
                            //       Text(
                            //         "Don't have an account?",
                            //         style: TextStyle(color: Colors.white),
                            //       ),
                            //       GestureDetector(
                            //         onTap: () {},
                            //         child: Text(" Sign Up",
                            //             style: TextStyle(
                            //                 color: Colors.blue,
                            //                 fontWeight: FontWeight.bold)),
                            //       ),
                            //       Text(
                            //         " Now",
                            //         style: TextStyle(
                            //             color: Colors.blue,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(
                              height: 50,
                            ),
                            const Divider(
                              height: 20,
                              thickness: 1,
                              indent: 5,
                              endIndent: 5,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await _loginCubit.login(
                                            username: _usernameController.text,
                                            password: _passwordController.text);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 25.0),
                                        width: 250.0,
                                        height: 45.0,
                                        decoration: new BoxDecoration(
                                          // color: colorPrimary,
                                          borderRadius:
                                              new BorderRadius.circular(50.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[900],
                                              blurRadius: 2.0,
                                              spreadRadius: 0.0,
                                              offset: Offset(2.0, 2.0),
                                            )
                                          ],
                                          gradient: new LinearGradient(
                                              colors: [
                                                AppColors.accent,
                                                AppColors.primary,
                                                AppColors.secondary,
                                              ],
                                              begin: const FractionalOffset(
                                                  0.0, 1.0),
                                              end: const FractionalOffset(
                                                  1.0, 0.0),
                                              // stops:[0.8, 0.3, 0.1,],
                                              tileMode: TileMode.clamp),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: (Text('Log-in',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0))),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
                if (state.status == LoginStatus.loading) {
                  return LoaderComponent();
                }

                return SizedBox();
              })
            ],
          ),
        ),
      ),
    );
  }
}
