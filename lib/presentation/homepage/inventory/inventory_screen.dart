import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/presentation/homepage/transfer/transfer_screen.dart';
import 'package:suprsync/presentation/homepage/withdrawal/withdrawal_screen.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showWithdrawalSheet(context);
              },
              child: Container(
                color: Color(0xffF8F8F8),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                height: 60,
                child: Text('Withdrawal'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => TransferScreen());
              },
              child: Container(
                color: Color(0xffF8F8F8),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                child: Text('Transfer'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showWithdrawalSheet(BuildContext context) {
    // final ValueCallback onValueSelected;
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    // AuthController _authController = AuthController();
    bool isVisible = false;

    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: context.colorScheme.secondary,
        context: context,
        builder: (BuildContext context) {
          return WithdrawalSheetSheet();
        });
  }
}
