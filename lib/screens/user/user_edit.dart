import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/global_methods.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/default_text.dart';

class UserInfoEditScreen extends StatefulWidget {
  const UserInfoEditScreen({super.key});

  @override
  _UserInfoEditScreenState createState() => _UserInfoEditScreenState();
}

class _UserInfoEditScreenState extends State<UserInfoEditScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool isLoading = false;
  bool isUserLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// Fetch user data and initialize text controllers
  Future<void> _initializeData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    setState(() => isLoading = true);
    
    await userProvider.fetchUserById(userProvider.selectedUser!.id); // Fetch user data

    final userData = userProvider.selectedUser;
    if (userData != null) {
      setState(() {
        _usernameController = TextEditingController(text: userData.username);
        _emailController = TextEditingController(text: userData.email);
        _phoneController = TextEditingController(text: userData.phoneNumber ?? '');
        isUserLoaded = true;
        isLoading = false;
      });
    }
  }

  /// Pick an image from the gallery
  Future<void> _pickImage() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
    int fileSizeInBytes = await imageFile.length(); // Get file size
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024); // Convert to MB

    if (fileSizeInMB > 5) {
      // Show error message if file size exceeds 5MB
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File size should not exceed 5MB')),
      );
      return; // Stop further processing
    }

    setState(() {
      _imageFile = imageFile;
    });
  }
}

  /// Remove the selected image
  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  /// Update user details
  Future<void> _updateUserDetails() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.selectedUser;

    if (userData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data not available')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      Map<String, dynamic> updatedData = {
        "username": _usernameController.text,
        "email": _emailController.text,
        "phone_number": _phoneController.text,
      };

      Map<String, dynamic> response = await userProvider.updateUserDetails(
        userId: userData.id,
        updatedData: updatedData,
        avatar: _imageFile,
      );

      if (response.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),          
        );        
        await _initializeData(); 
        Navigator.pop(context);
        // await _initializeData(); // Refresh UI with new data        
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.selectedUser;

    if (!isUserLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: DefaultTextWg(
          text: 'Edit Profile',
          fontSize: 24,
          fontColor: whiteColor,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Avatar with Edit and Remove Icons
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (userData!.avatar != null && userData.avatar!.isNotEmpty
                          ? NetworkImage(userData.avatar) as ImageProvider
                          : const AssetImage('assets/not-available.jpeg')),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: _pickImage,
                      color: const Color(0xFF4A6057),
                    ),
                    if (_imageFile != null) // Show remove button if an image is selected
                      IconButton(
                        icon: const Icon(Icons.delete_forever, color: Colors.white),
                        onPressed: _removeImage,
                        color: Colors.red,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Editable Fields
            _buildEditableField(
              label: "Username",
              icon: Icons.person_outline,
              controller: _usernameController,
            ),
            const SizedBox(height: 16),
            _buildEditableField(
              label: "Email",
              icon: Icons.email_outlined,
              controller: _emailController,
            ),
            const SizedBox(height: 16),
            _buildEditableField(
              label: "Phone Number",
              icon: Icons.phone_outlined,
              controller: _phoneController,
            ),
            const SizedBox(height: 32),
            // Confirm Button
            ElevatedButton(
              onPressed: _updateUserDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A6057),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Update",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
            SizedBox(height: 16,),
            CustomDeleteBtm(fct: () {}, lastDate: GlobalMethods.formatDate(userData?.modifiedOn ?? '')),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, size: 18, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: const OutlineInputBorder(
              // borderSide: BorderSide(color: backgroundColor),
            ),
          ),
          style: defaultTextStyle()
        ),
      ],
    );
  }
}
