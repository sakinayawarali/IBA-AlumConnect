import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devproj/models/users_models/alumni_model.dart';
import 'package:devproj/models/users_models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:devproj/theme/app_colours.dart';
import 'package:devproj/models/users_models/alumni_model.dart' as alumni_model;
import 'package:devproj/models/users_models/student_model.dart'
    as student_model;
import 'package:devproj/repositories/alumni_repository.dart';
import 'package:devproj/repositories/student_repository.dart';

class CompleteProfilePage extends StatefulWidget {
  final String userType; // 'alumni' or 'student'
  final User user;

  CompleteProfilePage({required this.userType, required this.user});

  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _employmentStatusController;
  late TextEditingController _erpController;
  late TextEditingController _firstNameController;
  late TextEditingController _genderController;
  late TextEditingController _gradBatchController;
  late TextEditingController _interestsController;
  late TextEditingController _companyController;
  late TextEditingController _endDateController;
  late TextEditingController _positionController;
  late TextEditingController _startDateController;
  late TextEditingController _lastNameController;
  late TextEditingController _linkedinLinkController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _phoneController;
  late TextEditingController _programController;
  late TextEditingController _skillsController;
  late TextEditingController _projectDetailsController;
  late TextEditingController _projectTitleController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.user.email);
    _employmentStatusController = TextEditingController();
    _erpController = TextEditingController();
    _firstNameController = TextEditingController();
    _genderController = TextEditingController();
    _gradBatchController = TextEditingController();
    _interestsController = TextEditingController();
    _companyController = TextEditingController();
    _endDateController = TextEditingController();
    _positionController = TextEditingController();
    _startDateController = TextEditingController();
    _lastNameController = TextEditingController();
    _linkedinLinkController = TextEditingController();
    _cityController = TextEditingController();
    _countryController = TextEditingController();
    _phoneController = TextEditingController();
    _programController = TextEditingController();
    _skillsController = TextEditingController();
    _projectDetailsController = TextEditingController();
    _projectTitleController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _employmentStatusController.dispose();
    _erpController.dispose();
    _firstNameController.dispose();
    _genderController.dispose();
    _gradBatchController.dispose();
    _interestsController.dispose();
    _companyController.dispose();
    _endDateController.dispose();
    _positionController.dispose();
    _startDateController.dispose();
    _lastNameController.dispose();
    _linkedinLinkController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _programController.dispose();
    _skillsController.dispose();
    _projectDetailsController.dispose();
    _projectTitleController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Add user to the 'users' collection first
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .set({
          'id': widget.user.uid,
          'email': _emailController.text,
          'userType': widget.userType,
        });

        if (widget.userType == 'alumni') {
          Alumni alumni = Alumni(
            id: widget.user.uid,
            email: _emailController.text,
            employmentStatus: _employmentStatusController.text,
            erp: _erpController.text,
            firstName: _firstNameController.text,
            gender: _genderController.text,
            gradBatch: _gradBatchController.text,
            interests: _interestsController.text,
            lastName: _lastNameController.text,
            linkedinLink: _linkedinLinkController.text,
            phone: _phoneController.text,
            program: _programController.text,
            jobHistory: alumni_model.JobHistory(
              company: _companyController.text,
              endDate: _endDateController.text,
              position: _positionController.text,
              startDate: _startDateController.text,
            ),
            location: alumni_model.Location(
              city: _cityController.text,
              country: _countryController.text,
            ),
            skills: _skillsController.text,
          );
          await AlumniCRUD().updateAlumni(widget.user.uid, alumni);
        } else if (widget.userType == 'student') {
          Student student = Student(
            id: widget.user.uid,
            email: _emailController.text,
            employmentStatus: _employmentStatusController.text,
            erp: _erpController.text,
            firstName: _firstNameController.text,
            gender: _genderController.text,
            gradYear: _gradBatchController.text,
            interests: _interestsController.text,
            lastName: _lastNameController.text,
            linkedinLink: _linkedinLinkController.text,
            phone: _phoneController.text,
            program: _programController.text,
            jobHistory: student_model.JobHistory(
              company: _companyController.text,
              endDate: _endDateController.text,
              position: _positionController.text,
              startDate: _startDateController.text,
            ),
            location: student_model.Location(
              city: _cityController.text,
              country: _countryController.text,
            ),
            project: Project(
              details: _projectDetailsController.text,
              title: _projectTitleController.text,
              skills: _skillsController.text,
            ),
          );
          await StudentCRUD().updateStudent(widget.user.uid, student);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: AppColors.lightGrey,
      ),
      maxLines: 1,
      maxLength: 100,
      validator: isRequired
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $labelText';
              }
              return null;
            }
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                    controller: _emailController, labelText: 'Email'),
                _buildTextField(
                    controller: _employmentStatusController,
                    labelText: 'Employment Status'),
                _buildTextField(controller: _erpController, labelText: 'ERP'),
                _buildTextField(
                    controller: _firstNameController, labelText: 'First Name'),
                _buildTextField(
                    controller: _genderController, labelText: 'Gender'),
                _buildTextField(
                    controller: _gradBatchController,
                    labelText: 'Graduation Batch'),
                _buildTextField(
                    controller: _interestsController, labelText: 'Interests'),
                _buildTextField(
                    controller: _lastNameController, labelText: 'Last Name'),
                _buildTextField(
                    controller: _linkedinLinkController,
                    labelText: 'LinkedIn Link'),
                _buildTextField(controller: _cityController, labelText: 'City'),
                _buildTextField(
                    controller: _countryController, labelText: 'Country'),
                _buildTextField(
                    controller: _phoneController, labelText: 'Phone'),
                _buildTextField(
                    controller: _programController, labelText: 'Program'),
                _buildTextField(
                    controller: _skillsController, labelText: 'Skills'),
                _buildTextField(
                    controller: _companyController, labelText: 'Company'),
                _buildTextField(
                    controller: _endDateController, labelText: 'End Date'),
                _buildTextField(
                    controller: _positionController, labelText: 'Position'),
                _buildTextField(
                    controller: _startDateController, labelText: 'Start Date'),
                if (widget.userType == 'student') ...[
                  _buildTextField(
                      controller: _projectDetailsController,
                      labelText: 'Project Details'),
                  _buildTextField(
                      controller: _projectTitleController,
                      labelText: 'Project Title'),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: Text('Save Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
