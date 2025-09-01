import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/models/transfer_request_mdel.dart';
import 'package:suprsync/presentation/controllers/transfer_controllers.dart';
import 'package:suprsync/presentation/dashboard_screen/transfer/transfer_item_dialog.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final TextEditingController _scannedValue = TextEditingController();
  final TransferController _transferController = Get.find();
  bool isDialogVisible = false; // Track dialog state

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _scannedValue.text = scanData.code.toString();
      });
      _checkForMatchingBatch(_scannedValue.text);
    });
  }

  void _checkForMatchingBatch(String scannedBatchId) {
    var matchingItem =
        _transferController.transferRequestModel.firstWhereOrNull(
      (item) => item.batchIdentifier.toString() == scannedBatchId,
    );

    if (matchingItem != null) {
      showAlertDialog(matchingItem);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage(AppIcons.qrTransferScreen))),
        child: Center(
          child: Container(
              height: 400,
              width: 225,
              child: Stack(
                children: [
                  // Image.asset(
                  //   'assets/icons/Group 1040.png',
                  //   height: 230,
                  // ),
                  Positioned.fill(
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      overlay: QrScannerOverlayShape(),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  showAlertDialog(TransferRequestModel requestedTransferItem) {
    if (isDialogVisible) return; // Prevent multiple dialogs

    setState(() {
      isDialogVisible = true; // Set dialog as visible
    });

    controller.pauseCamera();
    Get.dialog(
        barrierDismissible: false,
        Dialog(
            insetPadding: EdgeInsets.zero,
            child: TransferItemDialog(
              requestedTransferItem: requestedTransferItem,
            ))).then((_) {
      setState(() {
        isDialogVisible = false;
      });
      controller.resumeCamera();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _scannedValue.dispose();
    super.dispose();
  }
}
