import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/business.dart';
import '../../../providers/user_provider.dart';
import '../update_payment_bank_info.dart';

class BankInfoListWidget extends StatelessWidget {
  const BankInfoListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);   
    return Consumer<PaymentBankInfoProvider>(
        builder: (context, paymentProvider, child) {
          if (paymentProvider.paymentBanks.isEmpty) {
            return Center(child: CircularProgressIndicator()); // Show loading indicator
          }
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: paymentProvider.paymentBanks.length,
            itemBuilder: (context, index) {
              final paymentBank = paymentProvider.paymentBanks[index];              
              return ListTile(
                leading: Image.network(paymentBank.bank.logo, width: 50, height: 50),
                title: Text(paymentBank!.bank.title, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(paymentBank.accountNo),
                    Text(paymentBank.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                onTap: () {                  
                  if (userProvider.currentUser != null && userProvider.currentUser!.role == "admin")
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdatePaymentBankInfoScreen(id: paymentBank.id, bankId: paymentBank.bank.id, accountNo: paymentBank.accountNo, name: paymentBank.name)),
                  );                  
                },
              );
            },
          );
        },
      );
  }
}