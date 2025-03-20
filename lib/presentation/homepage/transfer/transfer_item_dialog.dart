import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:suprsync/core/constants/app_images.dart';
import 'package:suprsync/core/utils/app_button.dart';
import 'package:suprsync/models/transfer_request_mdel.dart';

class TransferItemDialog extends StatefulWidget {
  const TransferItemDialog({super.key, required this.requestedTransferItem});
  final TransferRequestModel requestedTransferItem;

  @override
  State<TransferItemDialog> createState() => _TransferItemDialogState();
}

class _TransferItemDialogState extends State<TransferItemDialog> {
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    print(widget.requestedTransferItem.items!.first.itemId);
    print(widget.requestedTransferItem.fromLocation!.locationId);
    return Container(
      width: 380,
      height: isScanned ? 800 : 400,
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      // size.width,
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 20, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BatchID',
                      style: context.textTheme.labelMedium?.copyWith(
                          color: const Color(0xff535353),
                          fontWeight: FontWeight.w400)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(widget.requestedTransferItem.batchIdentifier.toString()),
                  const SizedBox(
                    height: 13,
                  ),
                  Text('Transferred from',
                      style: context.textTheme.labelMedium?.copyWith(
                          color: const Color(0xff535353),
                          fontWeight: FontWeight.w400)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(widget.requestedTransferItem.fromLocation!.locationName
                      .toString()),
                  const SizedBox(
                    height: 13,
                  ),
                  Text('Amount',
                      style: context.textTheme.labelMedium?.copyWith(
                          color: const Color(0xff535353),
                          fontWeight: FontWeight.w400)),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text('')
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date',
                      style: context.textTheme.labelMedium?.copyWith(
                          color: const Color(0xff535353),
                          fontWeight: FontWeight.w400)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(widget.requestedTransferItem.items!.first.createdOn
                      .toString()
                      .substring(0, 10)),
                  const SizedBox(
                    height: 13,
                  ),
                  Text('Transferred to',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: const Color(0xff535353),
                        fontWeight: FontWeight.w400,
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(widget.requestedTransferItem.toLocation!.locationName
                      .toString()),
                  const SizedBox(
                    height: 13,
                  ),
                  Text('No of items',
                      style: context.textTheme.labelMedium?.copyWith(
                          color: const Color(0xff535353),
                          fontWeight: FontWeight.w400)),
                  Text(widget.requestedTransferItem.items!.length.toString()),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 13,
          ),
          // Text('Scan Barcode',
          //     style: context.textTheme.labelMedium?.copyWith(
          //         color: const Color(0xff535353), fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
              onTap: () {
                setState(() {
                  isScanned = !isScanned;
                });
              },
              child: Text(isScanned ? 'show less' : 'show more')
              // Image.asset(
              //   AppIcons.scanBarcode,
              //   scale: 2,
              // ),
              ),
          // Container(
          //   height: 79,
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(7),
          //     color: const Color(0xffF5F5F5),
          //   ),
          //   child:
          // ),
          const SizedBox(
            height: 24,
          ),
          Visibility(
            visible: isScanned,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Items List',
                    style: context.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xff535353),
                        fontWeight: FontWeight.w400)),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  color: Color(0xffFAFAFA),
                  child: Column(children: [
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text(
                                'Ref No',
                                style: context.textTheme.bodyMedium
                                    ?.copyWith(color: const Color(0xff000000)),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Text(
                                'Name',
                                style: context.textTheme.bodyMedium
                                    ?.copyWith(color: const Color(0xff000000)),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Text(
                                'Status',
                                style: context.textTheme.bodyMedium
                                    ?.copyWith(color: const Color(0xff000000)),
                              ),
                            ),
                            // SizedBox(width: 100)
                          ],
                        ),
                      ),
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        itemCount: widget.requestedTransferItem.items!.length,
                        separatorBuilder: (context, index) => const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xffE7E7E7),
                            ),
                        itemBuilder: (context, index) {
                          final isCurrentSession = index < 2;
                          var items =
                              widget.requestedTransferItem.items![index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 8, bottom: 8, right: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 90,
                                  child: Text(
                                    items.referenceNumber.toString(),
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                            color: const Color(0xff000000)),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    items.name.toString(),
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                            color: const Color(0xff000000)),
                                  ),
                                ),
                                Container(
                                  // width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(
                                        // 0xff056033
                                        //    :
                                        0xffD9694D),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    child: Text(
                                      items.status.toString(),
                                      // _calendarController
                                      //     .requestedTimeoffs[index]
                                      //     .status
                                      //     .toString()
                                      //     .capitalizeFirst!,
                                      style:
                                          context.textTheme.bodySmall!.copyWith(
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ),
                                // GestureDetector(
                                //   onTap: () {
                                //     // showAlertDialog();
                                //   },
                                //   child: Text(
                                //     'Requested',
                                //     style: context.textTheme.bodyMedium?.copyWith(
                                //         color: const Color(0xff5E5E5E),
                                //         decoration: TextDecoration.underline),
                                //   ),
                                // ),
                                // SizedBox(width: 100)
                              ],
                            ),
                          );
                        }),
                    RectangularButton(
                      onPress: () {
                        Get.back();
                        // onTapFunction();
                      },
                      buttonTitle: "Stock Items",
                      height: 40,
                      colour: const Color(0xff000000),
                      textStyleColor: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    )
                  ]),
                ),
              ],
            ),
          ),

          // Sizedbox()
        ],
      ),
    );
  }
}
