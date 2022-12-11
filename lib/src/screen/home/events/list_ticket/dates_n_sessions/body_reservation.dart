import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/bottom_sheet/datetime_ticket_c.dart';
import 'package:wallet_apps/src/components/cards/ticket_item_c.dart';
import 'package:wallet_apps/src/components/radio/radio_session_c.dart';
import 'package:wallet_apps/src/models/mdw_ticketing/ticket_m.dart';
import 'package:wallet_apps/src/models/mdw_ticketing/user_info_m.dart';
import 'package:wallet_apps/src/provider/ticket_p.dart';
import 'package:wallet_apps/src/screen/home/events/list_ticket/dates_n_sessions/user_info.dart';
import 'package:wallet_apps/src/screen/home/events/list_ticket/ticket_confirm.dart/ticket_confirm.dart';

class ReservationBody extends StatelessWidget {

  final DataSubmittion? dataSubmittion;
  final List<ListMonthYear>? lstMontYear;
  final TicketTypes? ticketTypeModel;
  final Function? onDateChange;
  final Function? onTabShow;
  final Function? onSessionChange;
  final Function? onQtyChange;

  const ReservationBody({
    Key? key, 
    required this.dataSubmittion,
    required this.lstMontYear, 
    required this.ticketTypeModel,
    required this.onDateChange,
    required this.onTabShow,
    required this.onSessionChange,
    required this.onQtyChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// Click Month - Year
        /// 
        /// Choose Date
        /// 
        /// 1
        TicketItemComponent(
          label: "Select Joining Date",
          onTap: () async {
            print("dateTimePicker");

            // List Month - Year 
            // And List All Available Date In Each Month.
            await dateTimeTicket(context: context, data: lstMontYear).then((indexDate) {

              if (indexDate != null){
                dataSubmittion!.indexMonthYear = indexDate;
                onDateChange!(indexDate);
              }

            });
          },
          child: Row(
            children: [
    
              Icon(Icons.date_range), 
              dataSubmittion!.date != "" ? MyText(
                left: 10,
                text: AppUtils.stringDateToDateTime(dataSubmittion!.date!),
                fontWeight: FontWeight.w600,
              ) : Container(),
              Expanded(child: Container()),
              Icon(Icons.arrow_forward_ios_outlined)
            ],
          )
        ),

        /// Session
        /// 
        /// 2
        dataSubmittion!.date!.isNotEmpty ? TicketItemComponent(
          label: "Session",
          onTap: (){
            onTabShow!( !ticketTypeModel!.isShow! );
          },
          child: Row(
            children: [
    
              Icon(Iconsax.clock),
              Expanded(child: Container()),
              Icon( !(ticketTypeModel!.isShow! ) ? Icons.arrow_forward_ios_outlined : Icons.keyboard_arrow_down_sharp)
              
            ],
          )
        ) : Container(),

        /// 2.1 Sessioin Drop Down
        /// 
        /// List Sessions
        if ( ticketTypeModel!.isShow! )
          Container(
            margin: EdgeInsets.only(left: 45, right: 45),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: lstMontYear![ dataSubmittion!.indexMonthYear! ].session!.lstDateAndSessions![ dataSubmittion!.indexDate! ].sessions!.length,
              // ticketModel!.lstMontYear![ ticketTypeIndex! ].lstSessionsByMonth![ ticketModel!.lsTicketTypes![ticketTypeIndex!].mmYYIndex! ].lstDateAndSessions![ ticketModel!.lsTicketTypes![ticketTypeIndex!].joinDateIndex! ].sessions!.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    RadioComponent(
                      data: {
                        "from": lstMontYear![ dataSubmittion!.indexMonthYear! ].session!.lstDateAndSessions![ dataSubmittion!.indexDate! ].sessions![index].from,
                        "to": lstMontYear![ dataSubmittion!.indexMonthYear! ].session!.lstDateAndSessions![ dataSubmittion!.indexDate! ].sessions![index].to,
                      },
                      groupValue: lstMontYear![ dataSubmittion!.indexMonthYear! ].initSession,
                      value: index + 1,
                      label: 'session', 
                      title: """${lstMontYear![ dataSubmittion!.indexMonthYear! ].session!.lstDateAndSessions![ dataSubmittion!.indexDate! ].sessions![index].from} - ${lstMontYear![ dataSubmittion!.indexMonthYear! ].session!.lstDateAndSessions![ dataSubmittion!.indexDate! ].sessions![index].to}""", 
                      onChangeSession: onSessionChange!
                    ),

                    if(index != lstMontYear![ dataSubmittion!.indexMonthYear! ].session!.lstDateAndSessions![ dataSubmittion!.indexDate! ].sessions!.length-1) Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    
                  ],
                );
              }
            ),
          ),
        
        if ( dataSubmittion!.from!.isNotEmpty && dataSubmittion!.to!.isNotEmpty )
        TicketItemComponent(
          label: "Ticket Amount", 
          child: Row(
            children: [
    
              Icon(Icons.airplane_ticket),
              Expanded(child: Container()),

              Row(
                children: [

                  IconButton(
                    onPressed: (){
                      onQtyChange!(-1);
                    }, 
                    icon: Icon(Icons.add)
                  ),

                  MyText(
                    text: dataSubmittion!.item!.qty.toString(),
                    fontSize: 18,
                  ),

                  IconButton(
                    onPressed: (){

                      onQtyChange!(1);
                    }, 
                    icon: Icon(Icons.add)
                  )
                ],
              )
            ],
          )
        ) 
        else Container(),

        if ( dataSubmittion!.from!.isNotEmpty && dataSubmittion!.to!.isNotEmpty )
        TicketItemComponent(
          label: "User Info", 
          child: InkWell(
            onTap: () async {
              await showModalBottomSheet(
                isScrollControlled:true,
                context: context, 
                builder: (context){
                  return UserInfo();
                }
              ).then(( value) {
                if (value != null){
                  UserInfoModel userInfoModel = value;

                  dataSubmittion!.name = userInfoModel.name.text;
                  dataSubmittion!.email = userInfoModel.email.text;
                  dataSubmittion!.phoneNumber = userInfoModel.phoneNumber.text;
                }
              });
            },
            child: Row(
              children: [
              
                Icon(Icons.airplane_ticket),
                Expanded(child: Container()),

                Icon(Icons.arrow_forward_ios_outlined)

              ],
            ),
          )
        ) 
        else Container(),

        if ( dataSubmittion!.from!.isNotEmpty && dataSubmittion!.to!.isNotEmpty )
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 30),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              )),
              padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
              backgroundColor: MaterialStatePropertyAll(hexaCodeToColor( (dataSubmittion!.item!.qty != 0) ? AppColors.primaryColor : AppColors.greyCode))
            ),
            onPressed: dataSubmittion!.item!.qty == 0 ? null : (){
              
              Navigator.push(
                context, 
                Transition(child: TicketConfirmation(dataSubmittion: dataSubmittion), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
              );
            }, 
            child: MyText(
              width: MediaQuery.of(context).size.width,
              color2: Colors.white,
              text: "Next",
              fontWeight: FontWeight.w700,
              fontSize: 17,
            )
          ),
        ) 
        else Container()
        
      ],
    );
  }
}