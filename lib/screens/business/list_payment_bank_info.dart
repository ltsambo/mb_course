import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/screens/business/components/bank_info_list.dart';
import 'package:mb_course/screens/business/create_payment_bank_info.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../providers/business.dart';

class ListPaymentBankInfoScreen extends StatefulWidget {
  @override
  _ListPaymentBankInfoScreenState createState() => _ListPaymentBankInfoScreenState();
}

class _ListPaymentBankInfoScreenState extends State<ListPaymentBankInfoScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<PaymentBankInfoProvider>(context, listen: false).fetchPaymentBankInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: DefaultTextWg(text: 'Banking Info', fontSize: 24, fontColor: whiteColor,),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: whiteColor,),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_business_sharp, color: whiteColor,),
            onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreatePaymentBankInfoScreen()),
                  ),
          ),
        ],
      ),
      body: BankInfoListWidget()
    );
  }
}
