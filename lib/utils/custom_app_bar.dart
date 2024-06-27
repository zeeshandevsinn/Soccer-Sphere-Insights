import 'package:app4_6_8/new_road_map/controller/colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final textTitle;
  final action;
  const CustomAppBar({super.key, required this.textTitle, this.action});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      iconTheme: const IconThemeData(
          color: Color(0xfaffffff),
          shadows: [BoxShadow(color: Color(0xfa003654), offset: Offset(0, 1))]),
      title: Text(textTitle),
      centerTitle: true,
      titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          color: Color(0xfaFFFFFF)),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            color: MyColors.orangeColor,
            border: BorderDirectional(
                bottom: BorderSide(
              color: Color(0xfaffffff),
              width: 3,
            )),
            boxShadow: [
              BoxShadow(color: Color(0xfa003654), offset: Offset(0, 9))
            ]),
      ),
      actions: action,
    );
  }
}
