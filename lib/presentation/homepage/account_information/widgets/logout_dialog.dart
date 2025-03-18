import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:suprsync/core/constants/extentions/theme_extention.dart';
import 'package:suprsync/presentation/homepage/auth/login_page.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // const SizedBox(height: 16),
              Text(
                'Are you sure you want to sign out?',
                style: context.textTheme.bodyMedium?.copyWith(
                    color: const Color(
                      0xff000000,
                    ),
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'You are going to exit your suprsync account.\nAre you sure you want to proceed?',
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall?.copyWith(
                    color: const Color(0xff6D6A6A),
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 145,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: Text(
                        'Cancel',
                        style: context.textTheme.bodySmall?.copyWith(
                            color: const Color(
                              0xff000000,
                            ),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 145,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.offAll(() => const LoginScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.tertiary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        'Yes',
                        style: context.textTheme.bodySmall
                            ?.copyWith(color: const Color(0xffffffff)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
