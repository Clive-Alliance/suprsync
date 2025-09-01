import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/presentation/dashboard_screen/transfer/transfer_screen.dart';
import 'package:suprsync/presentation/dashboard_screen/withdrawal/withdrawal_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Inventory',
                style: context.textTheme.headlineSmall?.copyWith(),
              ),
              const SizedBox(height: 4),
              Text('Choose to transfer or withdraw an item',
                  style: context.textTheme.bodySmall
                      ?.copyWith(color: const Color(0xff616161))),
              const SizedBox(
                height: 28,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const WithdrawalSheetSheet());
                  ;
                },
                child: Container(
                  color: const Color(0xffF8F8F8),
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  height: 60,
                  child: const Text('Withdrawal'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const TransferScreen());
                },
                child: Container(
                  color: const Color(0xffF8F8F8),
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: const Text('Transfer'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
