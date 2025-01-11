import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:user_profile_management/page/Theme.dart';
import 'package:user_profile_management/back-end/firebase_EditProfile.dart';
import 'package:user_profile_management/page/Widget_inside_appbar_backarrow.dart';

class EditProfilePage extends StatefulWidget {
  final String userID;

  const EditProfilePage({Key? key, required this.userID}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();

  bool _isUploadingImage = false;
  String? _profileImageUrl;
  File? _profileImageFile;

  // Text Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _blockController = TextEditingController();
  final TextEditingController _kolejController = TextEditingController();
  final TextEditingController _roomNoController = TextEditingController();
  final TextEditingController _emerCNameController = TextEditingController();
  final TextEditingController _emerCNoController = TextEditingController();
  final TextEditingController _emerRelationshipController = TextEditingController();
  final TextEditingController _icPassportController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      var data = await _userService.getUserData(widget.userID);
      if (data != null) {
        setState(() {
          _profileImageUrl = data['profileImageUrl'] ?? '';
          _firstNameController.text = data['personalInfo']['firstName'] ?? '';
          _lastNameController.text = data['personalInfo']['lastName'] ?? '';
          _emailController.text = data['personalInfo']['email'] ?? '';
          _mobileController.text = data['personalInfo']['mobile'] ?? '';
          _icPassportController.text = data['personalInfo']['icPassport'] ?? '';
          _dateOfBirthController.text = data['personalInfo']['dateOfBirth'] ?? '';
          _blockController.text = data['addressInfo']['block'] ?? '';
          _kolejController.text = data['addressInfo']['kolej'] ?? '';
          _roomNoController.text = data['addressInfo']['roomNo'] ?? '';
          _emerCNameController.text = data['emergencyContact']['name'] ?? '';
          _emerCNoController.text = data['emergencyContact']['number'] ?? '';
          _emerRelationshipController.text = data['emergencyContact']['relationship'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load user data.")),
      );
    }
  }

  /*Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImageFile = File(pickedFile.path);
      });
    }
  }*/

  Future<void> _uploadProfileImage() async {
    if (_profileImageFile != null) {
      setState(() {
        _isUploadingImage = true;
      });
      try {
        String url = await _userService.uploadProfilePicture(widget.userID, _profileImageFile!);
        setState(() {
          _profileImageUrl = url;
          _isUploadingImage = false;
        });
      } catch (e) {
        setState(() {
          _isUploadingImage = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload profile picture: $e')),
        );
      }
    }
  }

  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(child: CircularProgressIndicator());
          },
        );

        Map<String, dynamic> updateData = {
          'profileImageUrl': _profileImageUrl,
          'personalInfo': {
            'firstName': _firstNameController.text.trim(),
            'lastName': _lastNameController.text.trim(),
            'email': _emailController.text.trim(),
            'mobile': _mobileController.text.trim(),
            'icPassport': _icPassportController.text.trim(),
            'dateOfBirth': _dateOfBirthController.text.trim(),
          },
          'addressInfo': {
            'block': _blockController.text.trim(),
            'kolej': _kolejController.text.trim(),
            'roomNo': _roomNoController.text.trim(),
          },
          'emergencyContact': {
            'name': _emerCNameController.text.trim(),
            'number': _emerCNoController.text.trim(),
            'relationship': _emerRelationshipController.text.trim(),
          },
        };

        await _userService.updateUserData(widget.userID, updateData);

        Navigator.pop(context); // Close loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context); // Navigate back
      } catch (e) {
        Navigator.pop(context); // Close loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarAndBackArrow(title: 'Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                //onTap: _pickProfileImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImageFile != null
                      ? FileImage(_profileImageFile!)
                      : (_profileImageUrl != null
                          ? NetworkImage(_profileImageUrl!)
                          : null) as ImageProvider?,
                  child: _isUploadingImage
                      ? const CircularProgressIndicator()
                      : _profileImageUrl == null && _profileImageFile == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _uploadProfileImage,
                child: const Text('Upload Profile Picture'),
              ),
              _buildTextField('First Name', _firstNameController),
              _buildTextField('Last Name', _lastNameController),
              _buildTextField('Email', _emailController),
              _buildTextField('Mobile', _mobileController),
              _buildTextField('IC/Passport', _icPassportController),
              _buildDateOfBirthField(),
              _buildTextField('Block', _blockController),
              _buildTextField('Kolej', _kolejController),
              _buildTextField('Room Number', _roomNoController),
              _buildTextField('Emergency Contact Name', _emerCNameController),
              _buildTextField('Emergency Contact Number', _emerCNoController),
              _buildTextField('Relationship', _emerRelationshipController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserData,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label cannot be empty';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateOfBirthField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () async {
          DateTime currentDate = DateTime.now();
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.tryParse(_dateOfBirthController.text) ?? currentDate,
            firstDate: DateTime(1900),
            lastDate: currentDate,
          );
          if (picked != null) {
            _dateOfBirthController.text = picked.toLocal().toString().split(' ')[0];
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: _dateOfBirthController,
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Date of Birth cannot be empty';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
