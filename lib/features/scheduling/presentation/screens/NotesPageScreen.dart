import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constants/text_sizes.dart';

class NotesPageScreen extends StatefulWidget {
  const NotesPageScreen({super.key});

  @override
  State<NotesPageScreen> createState() => _NotesPageScreenState();
}

class _NotesPageScreenState extends State<NotesPageScreen> {
  Widget _buildTextInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Write a note...',
                hintStyle: TextStyle(color: Colors.grey,fontSize: 16, fontWeight: FontWeight.w400),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 9.5),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Icons row
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image_outlined, color: Colors.grey),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.alternate_email, color: Colors.grey),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.attach_file, color: Colors.grey),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),

          // Bottom padding for home indicator area
          const SizedBox(height: 8),
          Container(
            height: 5,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(245, 250, 255, 1),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
        ),
        title: Text(
          'Notes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(78, 78, 78, 1),
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(16, 24, 40, 0.05),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(28, 121, 212, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: TextSizes().bodyMedium,
                    fontWeight: FontWeight.w600,
                    // fontFamily: 'Inter'
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Spacer(),
            Image.asset('icons/scheduling/notes.png'),
            Spacer(),
            _buildTextInputArea()
          ],
        )
      ),
    );
  }
}
