// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:suprsync/core/constants/extentions/theme_extention.dart';
// import 'package:suprsync/presentation/homepage/schedules/widgets/birth_calendar_month.dart';
// import 'package:suprsync/presentation/homepage/schedules/widgets/days_grid.dart';
// import 'package:suprsync/presentation/homepage/schedules/widgets/search_field.dart';
// import 'package:suprsync/presentation/homepage/widgets/swap_cards.dart';

// class SwapScreen extends StatefulWidget {
//   const SwapScreen({super.key});

//   @override
//   State<SwapScreen> createState() => _SwapScreenState();
// }

// class _SwapScreenState extends State<SwapScreen> {
//   final int currentYear = DateTime.now().year;
//   final int currentMonth = DateTime.now().month;

//   String get monthYear => DateFormat.yMMMM().format(DateTime.now());
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             // height: size.height * 0.4,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(
//                   height: 44,
//                 ),
//                 Text(
//                   'Schedules',
//                   style: context.textTheme.headlineMedium?.copyWith(
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xff2C2C2C)),
//                 ),
//                 const SizedBox(
//                   height: 4,
//                 ),
//                 Text('See all assigned schedules here',
//                     style: context.textTheme.bodySmall),
//                 const SizedBox(
//                   height: 17,
//                 ),
//                 const CustomSearchField(
//                   hint: 'Search',
//                   preficIcon: Icon(Icons.search),
//                 ),
//                 BirthCalendarMonth(),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 42.52,
//           ),
//           Container(
//               height: 48,
//               decoration: const BoxDecoration(
//                   color: Color(0xff056033),
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30)))),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: const [
//                 SwapCard(
//                   isActive: true,
//                   time: '08:00 PM - 05:00 AM',
//                   id: '',
//                   day: 'Monday',
//                   title: 'Night Shift',
//                   isOpenForSwap: true,
//                   branch: 'Apple',
//                   hexcode: '0xff26BFBF',
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           )
//         ],
//       ),
//     );
//   }
// }
