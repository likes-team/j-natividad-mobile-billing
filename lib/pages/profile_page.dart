import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jnb_mobile/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:jnb_mobile/blocs/deliveries/delivery_cubit.dart';
import 'package:jnb_mobile/repositories/authentication_repository.dart';
import 'package:jnb_mobile/utilities/color_utility.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Reports",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: AppColors.primary,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.blueGrey[700],
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(
              //       colors: [
              //         AppColor.accent,
              //         AppColor.secondary,
              //         AppColor.primary,
              //       ],
              //       begin: const FractionalOffset(0.0, 1.0),
              //       end: const FractionalOffset(1.0, 0.0),
              //       // stops:[0.8, 0.3, 0.1,],
              //       tileMode: TileMode.clamp),
              // ),
              alignment: Alignment.center,
              child: Column(
                children: [
                  // ITO YONGG
                  // globalUser.photo != ""
                  // ? Container(
                  //   width: 100.0,
                  //   height: 100.0,
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     image: DecorationImage(
                  //       image: CachedNetworkImageProvider(globalUser.photo),
                  //     ),
                  //   ),
                  // )
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        AssetImage("assets/img/default_user.png"),
                    radius: 40,
                  ),
                  // ITO ////////
                  SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state) {
                    if (state.user == null) {
                      return SizedBox();
                    }
    
                    return Row(
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          state.user.fname! + " " + (state.user.lname ?? ''),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        // IconButton(
                        //   splashColor: Colors.white,
                        //   highlightColor: Colors.white,
                        //   onPressed: () {},
                        //   icon: Icon(
                        //     Icons.edit,
                        //     color: AppColors.accent,
                        //     size: 20,
                        //   ),
                        // )
                      ],
                    );
                  }),
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      return Text(
                        state.user.email ?? "",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      );
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // RichText(
                  //   text: TextSpan(children: [
                  //     TextSpan(
                  //       text: "globalUser.age" + " ",
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 11,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     TextSpan(
                  //       text: 'years old',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 11,
                  //         fontWeight: FontWeight.normal,
                  //       ),
                  //     ),
                  //     TextSpan(
                  //       text: ' | ',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 14,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     TextSpan(
                  //       text: "globalUser.weight.toString()" + ' ',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 11,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     TextSpan(
                  //       text: 'Kg',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 11,
                  //         fontWeight: FontWeight.normal,
                  //       ),
                  //     ),
                  //     TextSpan(
                  //       text: ' | ',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 14,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     TextSpan(
                  //       text: "globalUser.gender",
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 11,
                  //         fontWeight: FontWeight.normal,
                  //       ),
                  //     ),
                  //   ]),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  // Card(
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10)),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(20),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //       children: [
                  //         Column(
                  //           children: [
                  //             // Image(
                  //             //   image: AssetImage('assets/bicycle.png'),
                  //             //   height: 20,
                  //             //   width: 20,
                  //             // ),
                  //             SizedBox(
                  //               height: 10,
                  //             ),
                  //             RichText(
                  //               text: TextSpan(children: [
                  //                 TextSpan(
                  //                   text: ' ',
                  //                   style: TextStyle(
                  //                       color: AppColors.secondary,
                  //                       fontSize: 14,
                  //                       fontWeight: FontWeight.bold),
                  //                 ),
                  //                 TextSpan(
                  //                     text: 'Minutes',
                  //                     style: TextStyle(
                  //                         color: Colors.black,
                  //                         fontSize: 11,
                  //                         fontWeight: FontWeight.normal))
                  //               ]),
                  //             ),
                  //           ],
                  //         ),
                  //         Column(
                  //           children: [
                  //             // Image(
                  //             //   image: AssetImage('assets/activity.png'),
                  //             //   height: 20,
                  //             //   width: 20,
                  //             // ),
                  //             SizedBox(
                  //               height: 10,
                  //             ),
                  //             RichText(
                  //               text: TextSpan(children: [
                  //                 TextSpan(
                  //                   text: ' ',
                  //                   style: TextStyle(
                  //                       color: AppColors.secondary,
                  //                       fontSize: 14,
                  //                       fontWeight: FontWeight.bold),
                  //                 ),
                  //                 TextSpan(
                  //                     text: 'Activities',
                  //                     style: TextStyle(
                  //                         color: Colors.black,
                  //                         fontSize: 11,
                  //                         fontWeight: FontWeight.normal))
                  //               ]),
                  //             )
                  //           ],
                  //         ),
                  //         // Column(
                  //         //   children: [
                  //         //     Image(
                  //         //       image: AssetImage('assets/friends.png'),
                  //         //       height: 20,
                  //         //       width: 20,
                  //         //     ),
                  //         //     SizedBox(
                  //         //       height: 10,
                  //         //     ),
                  //         //     RichText(
                  //         //       text: TextSpan(children: [
                  //         //         TextSpan(
                  //         //           text: '1.5K ',
                  //         //           style: TextStyle(
                  //         //               color: AppColor.secondary,
                  //         //               fontSize: 14,
                  //         //               fontWeight: FontWeight.bold),
                  //         //         ),
                  //         //         TextSpan(
                  //         //             text: 'Community',
                  //         //             style: TextStyle(
                  //         //                 color: Colors.black,
                  //         //                 fontSize: 11,
                  //         //                 fontWeight: FontWeight.normal))
                  //         //       ]),
                  //         //     ),
                  //         //   ],
                  //         // ),
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            // Container(
            //   // alignment: Alignment.centerLeft,
            //   padding: EdgeInsets.only(top: 20, bottom: 0, left: 20),
            //   child: Column(
            //     // crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Bio:',
            //         style: TextStyle(
            //           color: AppColors.primary,
            //           fontWeight: FontWeight.normal,
            //           fontSize: 20,
            //         ),
            //       ),
            //       SizedBox(
            //         height: 10,
            //       ),
            //       Text(
            //         "globalUser.bio",
            //         style: TextStyle(
            //           color: Colors.black,
            //           fontStyle: FontStyle.italic,
            //           fontSize: 14,
            //         ),
            //       ),
            //       SizedBox(
            //         height: 10,
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: AspectRatio(
                aspectRatio: 1.3,
                child: BlocBuilder<DeliveriesCubit, DeliveryState>(
                  builder: (context, state) {
                    int? inProgressCount = state.inProgressList?.length;
                    int capturedCount = state.failedDeliveriesList != null ? state.failedDeliveriesList!.length : 0;
                    int? pendingCount = state.pendingList?.length;
                    int? deliveredCount = state.deliveredList?.length;
    
                    return Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.stop),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: inProgressCount.toString(),
                                          style: TextStyle(
                                              color: AppColors.secondary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text: '  In-Progress',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal))
                                      ]),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(Icons.file_upload),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: capturedCount.toString(),
                                          style: TextStyle(
                                              color: AppColors.secondary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text: '  Captured/Saved',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal))
                                      ]),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.pending),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: pendingCount.toString(),
                                          style: TextStyle(
                                              color: AppColors.secondary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text: '  Pending',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal))
                                      ]),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(Icons.check_box),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: deliveredCount.toString(),
                                          style: TextStyle(
                                              color: AppColors.secondary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text: '  Delivered',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal))
                                      ]),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
