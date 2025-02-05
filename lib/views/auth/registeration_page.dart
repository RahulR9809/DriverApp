import 'package:employerapp/views/auth/login_page.dart';
import 'package:employerapp/core/colors.dart';
import 'package:employerapp/widgets/refactored_widget.dart';
import 'package:employerapp/widgets/regiration_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/auth_bloc/auth_bloc.dart';

class DriverRegistrationPage extends StatefulWidget {
  const DriverRegistrationPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _DriverRegistrationPageState createState() => _DriverRegistrationPageState();
}

class _DriverRegistrationPageState extends State<DriverRegistrationPage> {
  final _licenseNumberController = TextEditingController();
  final _rcNumberController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  XFile? profileImage;
  XFile? licenseImage;
  XFile? vehiclePermit;
  String? vehicleType;

  Future<void> _pickImage(
      ImageSource source, void Function(XFile?) onPicked) async {
    final image = await _picker.pickImage(source: source, imageQuality: 80);
    setState(() {
      onPicked(image);
    });
  }

  bool _validateForm() {
    if (profileImage == null) {
      showSnackBar(context, 'Please upload a profile image', CustomColors.red);
      return false;
    }
    if (_licenseNumberController.text.isEmpty) {
      showSnackBar(context, 'Please enter a license number', CustomColors.red);
      return false;
    }
    if (licenseImage == null) {
      showSnackBar(
          context, 'Please upload your license image', CustomColors.red);
      return false;
    }
    if (vehicleType == null) {
      showSnackBar(context, 'Please select a vehicle type', CustomColors.red);
      return false;
    }
    if (_rcNumberController.text.isEmpty) {
      showSnackBar(context, 'Please enter an RC number', CustomColors.red);
      return false;
    }
    if (vehicleType == 'Auto' && vehiclePermit == null) {
      showSnackBar(
          context, 'Please upload the vehicle permit', CustomColors.red);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
            const BoxDecoration(gradient: CustomColors.backgroundGradient),
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProfileImageUpload(
                      image: profileImage,
                      onImagePicked: (image) =>
                          setState(() => profileImage = image),
                      onPickImage: () => _pickImage(ImageSource.gallery,
                          (image) => setState(() => profileImage = image)),
                    ),
                    const SizedBox(height: 20),
                    ReusableTextField(
                      controller: _licenseNumberController,
                      label: 'License Number',
                      icon: Icons.confirmation_number,
                    ),
                    const SizedBox(height: 20),
                    StaticImageUploadSection(
                      title: 'Upload License Image',
                      image: licenseImage,
                      onImagePicked: (image) =>
                          setState(() => licenseImage = image),
                      onPickImage: () => _pickImage(ImageSource.gallery,
                          (image) => setState(() => licenseImage = image)),
                    ),
                    const SizedBox(height: 20),
                    const SelectionLabel(label: "Select Vehicle Type"),
                    const SizedBox(height: 10),
                    VehicleTypeSelection(
                      selectedType: vehicleType,
                      onTypeSelected: (type) =>
                          setState(() => vehicleType = type),
                    ),
                    const SizedBox(height: 20),
                    ReusableTextField(
                      controller: _rcNumberController,
                      label: 'RC Number',
                      icon: Icons.numbers,
                    ),
                    const SizedBox(height: 20),
                    // if (vehicleType == 'Auto')
                    StaticImageUploadSection(
                      title: 'Upload Vehicle Permit',
                      image: vehiclePermit,
                      onImagePicked: (image) =>
                          setState(() => vehiclePermit = image),
                      onPickImage: () => _pickImage(ImageSource.gallery,
                          (image) => setState(() => vehiclePermit = image)),
                    ),
                    const SizedBox(height: 30),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is LoadingState) {
                          const CircularProgressIndicator();
                        } else if (state is DriverRegistrationSuccess) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        } else if (state is ErrorState) {
                          showSnackBar(context, 'Error submitting details',
                              CustomColors.red);
                        }
                      },
                      builder: (context, state) {
                        return ReusableButton(
                          text: 'Submit',
                          onPressed: () {
                            if (_validateForm()) {
                              BlocProvider.of<AuthBloc>(context).add(
                                SubmitRegistration(
                                  licenseNumber: _licenseNumberController.text,
                                  rcNumber: _rcNumberController.text,
                                  vehicleType: vehicleType ?? 'Auto',
                                  profileImage: profileImage,
                                  licenseImage: licenseImage,
                                  vehiclePermit: vehiclePermit,
                                ),
                              );
                              showSnackBar(context, 'Registration submitted!',
                                  CustomColors.green);
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
