import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../providers/business.dart';

class UpdatePaymentBankInfoScreen extends StatefulWidget {
  final int id;
  final int bankId;
  final String accountNo;
  final String name;

  UpdatePaymentBankInfoScreen({required this.id, required this.bankId, required this.accountNo, required this.name});

  @override
  _UpdatePaymentBankInfoScreenState createState() => _UpdatePaymentBankInfoScreenState();
}

class _UpdatePaymentBankInfoScreenState extends State<UpdatePaymentBankInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _selectedBank;
  late String _accountNo;
  late String _name;

  @override
  void initState() {
    super.initState();
    _selectedBank = widget.bankId;
    _accountNo = widget.accountNo;
    _name = widget.name;
    Provider.of<BankInfoProvider>(context, listen: false).fetchBanks();
  }

  @override
  Widget build(BuildContext context) {
    final bankProvider = Provider.of<BankInfoProvider>(context);
    final paymentProvider = Provider.of<PaymentBankInfoProvider>(context);

    return Scaffold(
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
          text: "Update Account Info",
          fontSize: 24,
          fontColor: whiteColor,
        ),
        centerTitle: true,
      ),
      body: Padding(
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
                onChanged: (value) => setState(() => _selectedBank = value!),
                items: bankProvider.banks.map((bank) {
                  return DropdownMenuItem<int>(
                    value: bank.id,
                    child: Text(bank.title),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: _accountNo,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Account Number",
                ),
                onChanged: (value) => _accountNo = value,
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Name",
                ),
                onChanged: (value) => _name = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    paymentProvider.updatePaymentBankInfo(widget.id, _selectedBank, _accountNo, _name);
                    Navigator.pop(context);
                  }
                },
                child: Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
