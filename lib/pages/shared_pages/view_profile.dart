import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devproj/theme/app_colours.dart';
import 'package:devproj/theme/app_fonts.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({Key? key}) : super(key: key);

  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String userType = '';
  Map<String, dynamic> userProfile = {};

  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _fetchUserTypeAndProfile();
  }

  Future<void> _fetchUserTypeAndProfile() async {
    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userSnapshot.exists) {
        userType = userSnapshot['userType'];
        QuerySnapshot profileQuerySnapshot;
        if (userType == 'student') {
          profileQuerySnapshot = await FirebaseFirestore.instance
              .collection('student')
              .where('id', isEqualTo: user!.uid)
              .get();
        } else {
          profileQuerySnapshot = await FirebaseFirestore.instance
              .collection('alumni')
              .where('id', isEqualTo: user!.uid)
              .get();
        }
        if (profileQuerySnapshot.docs.isNotEmpty) {
          setState(() {
            userProfile =
                profileQuerySnapshot.docs.first.data() as Map<String, dynamic>;
          });
        } else {
          setState(() {
            userProfile = {};
          });
        }
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      QuerySnapshot profileQuerySnapshot;
      if (userType == 'student') {
        profileQuerySnapshot = await FirebaseFirestore.instance
            .collection('student')
            .where('id', isEqualTo: user!.uid)
            .get();
      } else {
        profileQuerySnapshot = await FirebaseFirestore.instance
            .collection('alumni')
            .where('id', isEqualTo: user!.uid)
            .get();
      }
      if (profileQuerySnapshot.docs.isNotEmpty) {
        await profileQuerySnapshot.docs.first.reference.update(userProfile);
        setState(() {
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    }
  }

  Widget _buildProfileField(String label, String key,
      {bool readOnly = false,
      bool isNested = false,
      bool isDropdown = false,
      List<String>? dropdownItems}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 8),
          _isEditing && !readOnly
              ? isDropdown
                  ? DropdownButtonFormField<String>(
                      value: _getNestedFieldValue(key),
                      items: dropdownItems?.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _setNestedFieldValue(key, newValue);
                        });
                      },
                      onSaved: (newValue) {
                        _setNestedFieldValue(key, newValue);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: AppColors.lightTeal.withOpacity(0.1),
                      ),
                    )
                  : TextFormField(
                      initialValue: _getNestedFieldValue(key),
                      onSaved: (newValue) {
                        _setNestedFieldValue(key, newValue);
                      },
                      validator: (value) {
                        return null; // Allow empty fields
                      },
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: AppColors.lightTeal.withOpacity(0.1),
                      ),
                    )
              : Text(
                  _getNestedFieldValue(key) ?? 'Not provided',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
          Divider(),
        ],
      ),
    );
  }

  String? _getNestedFieldValue(String key) {
    if (key.contains('.')) {
      List<String> keys = key.split('.');
      return userProfile[keys[0]]?[keys[1]];
    } else {
      return userProfile[key];
    }
  }

  void _setNestedFieldValue(String key, String? value) {
    if (key.contains('.')) {
      List<String> keys = key.split('.');
      if (userProfile[keys[0]] == null) {
        userProfile[keys[0]] = {};
      }
      userProfile[keys[0]][keys[1]] = value;
    } else {
      userProfile[key] = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> gradYears =
        List<String>.generate(6, (i) => (2025 + i).toString());
    List<String> gradBatches =
        List<String>.generate(45, (i) => (2024 - i).toString());
    List<String> genderOptions = ['Male', 'Female'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            )
          else
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveProfile,
            ),
        ],
      ),
      body: userProfile.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text(
                        'View Profile',
                        style: AppStyles.mediumHeading,
                      ),
                    ),
                  ),
                  _buildProfileField('Email', 'email', readOnly: true),
                  _buildProfileField('First Name', 'firstName'),
                  _buildProfileField('Last Name', 'lastName'),
                  _buildProfileField('Gender', 'gender',
                      isDropdown: true, dropdownItems: genderOptions),
                  _buildProfileField('Employment Status', 'employmentStatus'),
                  _buildProfileField('ERP', 'erp'),
                  if (userType == 'student') ...[
                    _buildProfileField('Graduation Year', 'gradYear',
                        isDropdown: true, dropdownItems: gradYears),
                  ] else if (userType == 'alumni') ...[
                    _buildProfileField('Graduation Batch', 'gradBatch',
                        isDropdown: true, dropdownItems: gradBatches),
                  ],
                  _buildProfileField('Interests', 'interests'),
                  _buildProfileField('LinkedIn Link', 'linkedinLink'),
                  _buildProfileField('City', 'location.city'),
                  _buildProfileField('Country', 'location.country'),
                  _buildProfileField('Phone', 'phone'),
                  _buildProfileField('Program', 'program'),
                  _buildProfileField('Skills', 'skills'),
                  if (userType == 'alumni') ...[
                    _buildProfileField('Company', 'jobHistory.company',
                        isNested: true),
                    _buildProfileField('End Date', 'jobHistory.endDate',
                        isNested: true),
                    _buildProfileField('Position', 'jobHistory.position',
                        isNested: true),
                    _buildProfileField('Start Date', 'jobHistory.startDate',
                        isNested: true),
                  ] else if (userType == 'student') ...[
                    _buildProfileField('Project Title', 'project.title',
                        isNested: true),
                    _buildProfileField('Project Details', 'project.details',
                        isNested: true),
                  ],
                ],
              ),
            ),
    );
  }
}
