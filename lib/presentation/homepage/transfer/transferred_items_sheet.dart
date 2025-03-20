import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:suprsync/models/transfer_request_mdel.dart';
import 'package:suprsync/presentation/controllers/transfer_controllers.dart';
import 'package:suprsync/presentation/homepage/transfer/transfer_item_dialog.dart';

class TransferredItemsSheet extends StatefulWidget {
  const TransferredItemsSheet({super.key});

  @override
  State<TransferredItemsSheet> createState() => _TransferredItemsSheetState();
}

class _TransferredItemsSheetState extends State<TransferredItemsSheet> {
  final TransferController _transferController = Get.find();

  @override
  void initState() {
    _transferController.requestTransferItemsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Obx(() {
        if (_transferController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (_transferController.transferRequestModel.isEmpty) {
          return const Center(
            child: Text('No Request Item for this Location'),
          );
        }
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 33, horizontal: 20),
          height: size.height * 0.87,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: AppIcons.arrowLeft),
                  Text('Back',
                      style: context.textTheme.bodyMedium
                          ?.copyWith(color: const Color(0xff868787))),
                ],
              ),
              const SizedBox(
                height: 28,
              ),
              Expanded(
                child: Container(
                  color: const Color(0xffFAFAFA),
                  child: Column(
                    children: [
                      Container(
                        height: 38,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                          color: Color(0xffF1FBF2),
                        ),
                        // padding: const EdgeInsets.all(16),

                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 90,
                                child: Text(
                                  'BatchID',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xff000000)),
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  'Amount',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xff000000)),
                                ),
                              ),
                              SizedBox(
                                // width: 160,
                                child: Text(
                                  'No of items',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xff000000)),
                                ),
                              ),

                              // SizedBox(width: 100)
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                            shrinkWrap: true,
                            // physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                _transferController.transferRequestModel.length,
                            separatorBuilder: (context, index) => const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Color(0xffE7E7E7),
                                ),
                            itemBuilder: (context, index) {
                              final isCurrentSession = index < 2;
                              var requestedTransferItem = _transferController
                                  .transferRequestModel[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, top: 8, bottom: 8, right: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 90,
                                      child: Text(
                                        requestedTransferItem.batchIdentifier ??
                                            '',
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                                color: const Color(0xff000000)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        '1',
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                                color: const Color(0xff000000)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        requestedTransferItem.items!.length
                                            .toString(),
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                                color: const Color(0xff000000)),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showAlertDialog(requestedTransferItem);
                                      },
                                      child: Text(
                                        'See more',
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                                color: const Color(0xff5E5E5E),
                                                decoration:
                                                    TextDecoration.underline),
                                      ),
                                    ),
                                    // SizedBox(width: 100)
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  showAlertDialog(TransferRequestModel requestedTransferItem) {
    Get.dialog(Dialog(
        insetPadding: EdgeInsets.zero,
        child: TransferItemDialog(
          requestedTransferItem: requestedTransferItem,
        )));
  }
}
