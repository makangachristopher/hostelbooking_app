import 'package:flutter/material.dart';

Color blackColor = Color(0xff253342);
Color purpleColor = Color(0xff5F6AC4);
Color greyColor = Color(0xffAFAFAF);
Color orangeColor = Color(0xffE76D81);
Color whiteColor = Color(0xffFFFFFF);
Color shadowColor = Color(0x26616161);

// style
TextStyle primaryTitle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w600,
  color: blackColor,
);

TextStyle sectionTitle = TextStyle(
  color: blackColor,
  fontWeight: FontWeight.w600,
  fontSize: 16,
);

TextStyle sectionSecondaryTitle = TextStyle(
  color: blackColor,
  fontWeight: FontWeight.w600,
  fontSize: 14,
);

TextStyle contentTitle = TextStyle(
  color: blackColor,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

TextStyle infoText = TextStyle(
  color: greyColor,
  fontWeight: FontWeight.w400,
  fontSize: 10,
);

TextStyle secondaryTitle = TextStyle(
  color: blackColor,
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

TextStyle infoSecondaryTitle = TextStyle(
  color: greyColor,
  fontWeight: FontWeight.w400,
  fontSize: 14,
);

TextStyle facilitiesTitle = TextStyle(
  color: blackColor,
  fontWeight: FontWeight.w500,
  fontSize: 10,
);

TextStyle descText = TextStyle(
  color: greyColor,
  fontWeight: FontWeight.w400,
  fontSize: 12,
);

TextStyle priceTitle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: greyColor,
);

TextStyle priceText = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  color: purpleColor,
);

// Input Decoration Style
InputDecoration searchDecoration = InputDecoration(
  filled: true,
  fillColor: whiteColor,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: BorderSide.none,
  ),
  hintText: "Find your dream home",
  contentPadding: EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 19,
  ),
  suffixIcon: Padding(
    padding: EdgeInsets.all(8),
    child: MaterialButton(
      onPressed: () {},
      color: purpleColor,
      minWidth: 39,
      height: 39,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Icon(
        Icons.search,
        color: whiteColor,
        size: 16,
      ),
    ),
  ),
);

const Color yellow = Color(0xffFDC054);
const Color mediumYellow = Color(0xffFDB846);
const Color darkYellow = Color(0xffE99E22);
const Color transparentYellow = Color.fromRGBO(253, 184, 70, 0.7);
const Color darkGrey = Color(0xff202020);

const LinearGradient mainButton = LinearGradient(colors: [
  Color.fromRGBO(236, 60, 3, 1),
  Color.fromRGBO(234, 60, 3, 1),
  Color.fromRGBO(216, 78, 16, 1),
], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter);

const List<BoxShadow> shadow = [
  BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 6)
];

screenAwareSize(int size, BuildContext context) {
  double baseHeight = 640.0;
  return size * MediaQuery.of(context).size.height / baseHeight;
}
