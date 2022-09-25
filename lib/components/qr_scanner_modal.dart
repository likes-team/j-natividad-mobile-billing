import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jnb_mobile/blocs/deliveries/delivery_cubit.dart';
import 'package:jnb_mobile/utilities/color_utility.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:uuid/uuid.dart';

class QrScannerModal extends StatefulWidget {
  const QrScannerModal({Key? key}) : super(key: key);

  @override
  _QrScannerModalState createState() => _QrScannerModalState();
}

class _QrScannerModalState extends State<QrScannerModal> {
  final _qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController qrController;
  late Barcode barcode;
  bool _isScanned = false;
  late DeliveriesCubit _deliveryCubit;

  // TextEditingController _postBody = TextEditingController();

  File? postImage;

  bool isLoading = false;

  void _onQRViewCreated(QRViewController controller) {
    qrController = controller;

    qrController.scannedDataStream.listen((scanData) {
      _processScannedData(scanData);
    });
  }

  void _processScannedData(Barcode scannedData) async {
    barcode = scannedData;

    if (_isScanned) {
      return;
    }

    _isScanned = true;

    _deliveryCubit.getDeliveryByContractNo(barcode.code);

    if (_deliveryCubit.state.statusMessage == "no_qr_found") {
      await Future.delayed(Duration(milliseconds: 3000));
      _isScanned = false;
    } else {
      await Navigator.pushNamed(context, '/delivery');
      _isScanned = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _deliveryCubit = BlocProvider.of<DeliveriesCubit>(context);

    return BlocListener<DeliveriesCubit, DeliveryState>(
      listener: (context, state) {
        if(state.statusMessage == "no_qr_found"){
        showTopSnackBar(
          context,
        CustomSnackBar.info(
          message: "No QR code found",
        ),
      );
        }
      },
      child: AlertDialog(
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        scrollable: true,
        content: Container(
          height: 300,
          width: 300,
          child: QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderRadius: 10,
              borderColor: AppColors.primary,
              borderLength: 20,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * .9,
            ),
          ),
        ),
      ),
    );
  }

  // _addImage(BuildContext context) async {
  //   String reply = await showModalBottomSheet(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
  //       ),
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return SafeArea(
  //           child: Container(
  //             child: new Wrap(
  //               children: <Widget>[
  //                 new ListTile(
  //                     leading: new Icon(Icons.photo_camera),
  //                     title: new Text('Camera'),
  //                     subtitle: new Text('Capture image using camera'),
  //                     onTap: () {
  //                       Navigator.pop(context, "CAMERA");
  //                     }),
  //                 new ListTile(
  //                     leading: new Icon(Icons.image),
  //                     title: new Text('Gallery'),
  //                     subtitle: new Text('Choose a photo from the gallery'),
  //                     onTap: () {
  //                       Navigator.pop(context, "GALLERY");
  //                     }),
  //               ],
  //             ),
  //           ),
  //         );
  //       });

  //   if (reply == "CAMERA") {
  //     File image = await openCamera();
  //     if (image != null) {
  //       postImage = image;
  //       setState(() {});
  //     }
  //   } else if (reply == "GALLERY") {
  //     File image = await openGallery();
  //     if (image != null) {
  //       postImage = image;
  //       setState(() {});
  //     }
  //   }
  // }
}
