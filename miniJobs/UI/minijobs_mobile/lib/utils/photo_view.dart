import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class PhotoView extends StatefulWidget {
  final Uint8List? photo;
  final bool editable;
  final int userId;

  const PhotoView({
    super.key,
    this.photo,
    this.editable = false,
    required this.userId,
  });

  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _currentPhoto;

  @override
  void initState() {
    super.initState();
    _currentPhoto = widget.photo;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _currentPhoto = imageBytes;
      });
      await _updatePhoto(imageBytes);
    }
  }

  Future<void> _updatePhoto(Uint8List newPhoto) async {
    try {
      final userProvider = context.read<UserProvider>();
      final photo = MultipartFile.fromBytes(newPhoto, filename: 'photo.jpg');
      await userProvider.uploadUserPhoto(widget.userId, photo);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo updated successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update photo: $error')),
      );
    }
  }

  void _showImageSourceDialog() {
    if (!widget.editable) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: _currentPhoto != null
                ? MemoryImage(_currentPhoto!)
                : const AssetImage('assets/images/user-icon.png') as ImageProvider,
            backgroundColor: Colors.grey.shade200,
          ),
          if (widget.editable)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _showImageSourceDialog,
            ),
        ],
      ),
    );
  }
}
