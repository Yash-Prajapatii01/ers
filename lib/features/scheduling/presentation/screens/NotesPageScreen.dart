import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../shared/constants/text_sizes.dart';

class NotesPageScreen extends StatefulWidget {
  const NotesPageScreen({super.key});

  @override
  State<NotesPageScreen> createState() => _NotesPageScreenState();
}

class _NotesPageScreenState extends State<NotesPageScreen> {
  Widget _buildTextInputArea() {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          Container(
            padding:  EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child:  TextField(
              decoration: InputDecoration(
                hintText: 'Write a note...',
                hintStyle: TextStyle(color: Colors.grey,fontSize: 16.sp, fontWeight: FontWeight.w400),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 9.5.h),
              ),
            ),
          ),

           SizedBox(height: 8.h),

          // Icons row
          Row(
            children: [
              InkWell(
                child: Padding(
                  padding:  EdgeInsets.all(2.5.w),
                  child: SvgPicture.asset('assets/icons/scheduling/gallery.svg'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.alternate_email, color: Color.fromRGBO(102, 112, 133, 0.5)),
                onPressed: () {},
              ),
              InkWell(
                child: Padding(
                  padding:  EdgeInsets.all(2.5.r),
                  child: SvgPicture.asset('assets/icons/scheduling/pin.svg'),
                ),
              ),
              const Spacer(),
              Transform.rotate(
                angle: 0.758,
                child: IconButton(
                  icon: const Icon(CupertinoIcons.paperplane_fill, color: Colors.grey),
                  onPressed: () {},
                ),
              ),
            ],
          ),

          // Bottom padding for home indicator area
           SizedBox(height: 8.r),
          Container(
            height: 5.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(3.r),
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
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Padding(
          padding:  EdgeInsets.only(left: 20.0.w),
          child: Row(
            children: [
              Padding(
                padding:  EdgeInsets.only(top: 5.w, bottom: 17.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(100.r),
                      child: Container(
                        width: 30.w,
                        height: 30.h,
                        alignment: Alignment.centerLeft,
                        child: Icon(
                            Icons.chevron_left_rounded,
                            size: 30
                        ),
                        // Replace Icon with your SVG later:
                        // child: SvgPicture.asset('assets/icons/chevron_left.svg'),
                      ),
                    ),
                    SizedBox(width: 4.w), // Adjust for visual spacing with text
                    Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(39, 39, 39, 1),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     //todo : to use the SVG icon rather than this
                //     InkWell(
                //       onTap : () => Navigator.pop(context),
                //       child: Container(
                //         alignment: Alignment.center,
                //         width: 18,
                //         height: 10,
                //         child: Icon(Icons.chevron_left_rounded),
                //       ),
                //     ),
                //     SizedBox(width: 10),
                //     Text(
                //       'Booking',
                //       style: TextStyle(
                //         fontSize: 18,
                //         fontWeight: FontWeight.w500,
                //         color: Color.fromRGBO(39, 39, 39, 1),
                //       ),
                //       overflow: TextOverflow.ellipsis,
                //     ),
                //   ],
                // ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Spacer(),
            Image.asset('assets/icons/scheduling/notes.jpg', width: 260.w, height: 260.h,),
            SizedBox(height: 10.h),
            Text('You can store all your notes here.'),
            Spacer(),
            _buildTextInputArea()
          ],
        )
      ),
    );
  }
}
