import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/providers/business.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';


class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  
  @override
  void initState() {
    super.initState();
    Provider.of<BusinessProvider>(context, listen: false).fetchBusiness();
  }

  @override
  Widget build(BuildContext context) {
    final _businessProvider = Provider.of<BusinessProvider>(context);
    print('business ${_businessProvider.business}');
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: whiteColor, size: 24,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: DefaultTextWg(text: "Contact Us", fontSize: 24, fontColor: whiteColor,),        
        centerTitle: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          // Logo
          Center(
            child: Column(
              children: [
                _businessProvider.business?.logo == null
                ? Image.asset(noUserImagePath, width: 100, height: 100, fit: BoxFit.cover)
                : Image.network(_businessProvider.business?.logo?.toString() ?? '', width: 100, height: 100, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Show fallback image when the network image fails to load
                  return Image.asset(
                    noUserImagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  );
                },
              ),
                const SizedBox(height: 16),
                DefaultTextWg(text: _businessProvider.business?.name ?? '', fontSize: 24, fontWeight: FontWeight.bold, fontColor: primaryColor,),                
                const SizedBox(height: 8),
                DefaultTextWg(text: _businessProvider.business?.email ?? '')
              ],
            ),
          ),
          const SizedBox(height: 32),
          // List Items
          _buildListItem(
            context,
            icon: Icons.phone_outlined,
            text:  _businessProvider.business?.contact ?? '',
            onTap: () {
              // Handle phone tap
            },
          ),
          const Divider(),
          _buildListItem(
            context,
            icon: Icons.location_on_outlined,
            text: _businessProvider.business?.address ?? '-',
            onTap: () {
              // Handle address tap
            },
          ),
          const Divider(),
          // Something Item
          // ListTile(
          //   leading: CircleAvatar(
          //     backgroundColor: Colors.red[100],
          //     child: const Icon(Icons.refresh, color: Colors.red),
          //   ),
          //   title: Text(
          //     "Something",
          //     style: GoogleFonts.poppins(
          //       fontSize: 16,
          //       color: Colors.red,
          //     ),
          //   ),
          //   onTap: () {
          //     // Handle something tap
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context,
      {required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.orange[100],
        child: Icon(icon, color: Colors.orange),
      ),
      title: DefaultTextWg(text: text),
      // trailing: const Icon(Icons.chevron_right, color: Colors.black),
      onTap: onTap,
    );
  }
}
