// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CustomInputField extends StatefulWidget {
//   final String hint;
//   final IconData icon; 
//   final TextEditingController controller; 
//   final bool isPassword;
//   @override
//   const CustomInputField({super.key, required this.hint, required this.icon, required this.controller, required this.isPassword});
  
//   State<CustomInputField> createState() => _CustomInputFieldState();
// }

// class _CustomInputFieldState extends State<CustomInputField> {
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       // obscureText: widget.isPassword && (widget.hint == "Password"
//       //     ? _obscurePassword
//       //     : _obscureConfirmPassword),
//       controller: widget.controller,
//       decoration: InputDecoration(
//         hintText: widget.hint,
//         hintStyle: GoogleFonts.poppins(
//           fontSize: 14,
//           color: Colors.grey,
//         ),
//         filled: true,
//         fillColor: const Color(0xFFF0F4F8), // Light grey background
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         prefixIcon: Icon(widget.icon, color: Colors.black54),
//         suffixIcon: widget.isPassword
//             ? IconButton(
//                 icon: Icon(
//                   widget.hint == "Password"
//                       ? (_obscurePassword
//                           ? Icons.visibility_off
//                           : Icons.visibility)
//                       : (_obscureConfirmPassword
//                           ? Icons.visibility_off
//                           : Icons.visibility),
//                   color: Colors.black54,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     if (widget.hint == "Password") {
//                       _obscurePassword = !_obscurePassword;
//                     } else {
//                       _obscureConfirmPassword = !_obscureConfirmPassword;
//                     }
//                   });
//                 },
//               )
//             : null,
//       ),
//     );
//   }
// }