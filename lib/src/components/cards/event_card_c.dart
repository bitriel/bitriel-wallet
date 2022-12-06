import 'dart:ui';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wallet_apps/index.dart';

class EventCardComponents extends StatelessWidget {

  final String? ipfsAPI;
  final String? title;
  final String? eventName;
  final String? eventDate;
  final List<Map<String, dynamic>>? listEvent;
  final Function()? onPressed;

  const EventCardComponents({
    this.ipfsAPI,
    this.title, 
    this.eventName, 
    this.eventDate,
    this.listEvent,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    
          MyText(
            top: 30,
            left: 30,
            bottom: 10,
            text: title,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: List.generate(
                listEvent!.length,
                (i) => Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? 20 : 0,
                    right: i != 19 ? 20 : 0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                  
                        SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width - 60,
                          child: listEvent!.isNotEmpty ? Image.network("$ipfsAPI${listEvent![i]['image']}", fit: BoxFit.cover,) : Container()
                        ),
                  
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, bottom: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 9.0, sigmaY: 9.0),
                                  child: Container(
                                  // margin: const EdgeInsets.only(left: 10, bottom: 10),
                                  // alignment: Alignment.bottomLeft,
                                  decoration: BoxDecoration(
                                    // color: hexaCodeToColor("#413B3B").withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10),
                                    // border: Border.all(color: hexaCodeToColor("#383838"))
                                  ),
                                  // width: MediaQuery.of(context).size.width - 60,
                                  height: 8.h,
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    
                                      MyText(
                                        text: listEvent![i]['startDate'],//"10 - 21 august, 2022",
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        bottom: 5,
                                        hexaColor: "#878787",
                                      ),
                                    
                                      MyText(
                                        text: listEvent![i]['name'], //"NIGHT MUSIC FESTIVAL",
                                        fontSize: 16,
                                        color2: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
    
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            // alignment: Alignment.bottomLeft,
                            decoration: BoxDecoration(
                              color: hexaCodeToColor("#413B3B").withOpacity(0.7),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            // width: MediaQuery.of(context).size.width - 60,
                            height: 5.h,
                            width: 5.h,
                            padding: EdgeInsets.all(10),
                            child: Icon(Iconsax.heart, color: Colors.white, size: 4.w,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
    
          ),
        ],
      ),
    );
  }
}