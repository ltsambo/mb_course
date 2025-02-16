import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/screens/business/list_payment_bank_info.dart';
import 'package:mb_course/widgets/custom_button.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../providers/business.dart';

class CreatePaymentBankInfoScreen extends StatefulWidget {
  @override
  _CreatePaymentBankInfoScreenState createState() => _CreatePaymentBankInfoScreenState();
}

class _CreatePaymentBankInfoScreenState extends State<CreatePaymentBankInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedBank;
  String _accountNo = "";
  String _name = "";

  @override
  void initState() {
    super.initState();
    Provider.of<BankInfoProvider>(context, listen: false).fetchBanks();
  }

  @override
  Widget build(BuildContext context) {
    final bankProvider = Provider.of<BankInfoProvider>(context);
    final paymentProvider = Provider.of<PaymentBankInfoProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: DefaultTextWg(
          text: "Create Account Info",
          fontSize: 24,
          fontColor: whiteColor,
        ),
        centerTitle: true,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Select Bank",
                  ),
                  value: _selectedBank,
                  onChanged: (value) => setState(() => _selectedBank = value),
                  items: bankProvider.banks.map((bank) {
                    return DropdownMenuItem<int>(
                      value: bank.id,
                      child: Text(bank.title),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Account Number",
                  ),
                  onChanged: (value) => _accountNo = value,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                  ),
                  onChanged: (value) => _name = value,
                ),
                SizedBox(height: 20),
                CustomElevatedButton(
                  text: "Create", 
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _selectedBank != null) {                      
                      paymentProvider.createPaymentBankInfo(_selectedBank!, _accountNo, _name);         
                      Navigator.push(context,  MaterialPageRoute(builder: (context) => ListPaymentBankInfoScreen()));
                    }
                  },
                ),           
              ],
            ),
          ),
        ),
      ),
    );
  }
}
