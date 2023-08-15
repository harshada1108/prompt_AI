import 'package:flutter/material.dart';
import 'package:prompt_ai/pallets.dart';
class FeaturedBox extends StatelessWidget {
  final Color color;
  final String HeaderText;
  final String descriptiontext;

  const FeaturedBox({super.key,required this.color, required this.HeaderText, required this.descriptiontext});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:color,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      padding: EdgeInsets.symmetric(vertical: 15).copyWith(left: 15),
      margin:   EdgeInsets.symmetric(
      horizontal: 25,
      vertical: 8,
    ),
      child: Column(

        children: [
          Align(
            alignment: Alignment.centerLeft,
            child:Text(HeaderText,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Cera Pro',
                  color: Pallete.blackColor,
                ),
              ),

          ),
      const SizedBox(height: 3),
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Text(
          descriptiontext,
          style: const TextStyle(
            fontFamily: 'Cera Pro',
            color: Pallete.blackColor,
          ),
        ),
      )
        ],
      ),



    );
  }
}
