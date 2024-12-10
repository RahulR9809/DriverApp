
import 'dart:io';

import 'package:employerapp/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageUpload extends StatelessWidget {
  final XFile? image;
  final void Function(XFile?) onImagePicked;
  final VoidCallback onPickImage;

  const ProfileImageUpload({
    super.key,
    required this.image,
    required this.onImagePicked,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: image != null
                    ? FileImage(File(image!.path))
                    : const AssetImage('asset/profile.png'),
                backgroundColor: Colors.grey[200],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onPickImage,
                  child: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    radius: 20,
                    child: Icon(Icons.edit, size: 16, color: white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Profile Image',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: white)),
        ],
      ),
    );
  }
}

class StaticImageUploadSection extends StatelessWidget {
  final String title;
  final XFile? image;
  final void Function(XFile?) onImagePicked;
  final VoidCallback onPickImage;

  const StaticImageUploadSection({super.key, 
    required this.title,
    required this.image,
    required this.onImagePicked,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: white)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onPickImage,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5)),
            ),
            child: Stack(
              children: [
                if (image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(image!.path),
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),
                  )
                else
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file,
                            size: 40,
                            color: Color.fromARGB(255, 255, 255, 255)),
                        SizedBox(height: 5),
                        Text('Tap to Upload',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255))),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class VehicleTypeSelection extends StatelessWidget {
  final String? selectedType;
  final Function(String) onTypeSelected;

  const VehicleTypeSelection(
      {super.key, required this.selectedType, required this.onTypeSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildVehicleOption(context, 'Auto', 'asset/auto.jpg'),
        _buildVehicleOption(context, 'Car', 'asset/Car.jpg'),
      ],
    );
  }

  Widget _buildVehicleOption(BuildContext context, String type, String image) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTypeSelected(type),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: selectedType == type ? Colors.teal.withOpacity(0.1) : white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: selectedType == type
                    ? Colors.teal
                    : Colors.grey.withOpacity(0.5)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
              borderRadius: BorderRadius.circular(10), // Apply rounded corners to the image
              child: Image.asset(image, height: 60, fit: BoxFit.cover),
            ),
              const SizedBox(height: 10),
              Text(type,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500, color: black)),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectionLabel extends StatelessWidget {
  final String label;

  const SelectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: white,
      ),
    );
  }
}
