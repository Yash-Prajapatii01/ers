import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/presentation/screens/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SupabaseClient supabase = Supabase.instance.client;
    debugPrint("Name:- ${supabase.auth.currentUser!.userMetadata}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff62A8ED),Color(0xff1C79D4), ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.only(top: 50.h, bottom: 15.h),
            child: Column(
              children: [
                const Text(
                  'Profile',
              style: TextStyle(
                color: Colors.white,
            fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
                ),
                SizedBox(height: 15.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: Color(0xFFEFF7FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.network(
                          'https://randomuser.me/api/portraits/men/15.jpg',
                          width: 100.r,
                          height: 100.r,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text('David Goggins', style: Theme.of(context).textTheme.headlineSmall),
                      SizedBox(height: 4.h),
                      Text(
                        supabase.auth.currentUser!.email!,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 4.h),
                      const Text(
                        'David123 | 81xxxxxx01',
                        style: TextStyle(color: Colors.black54,fontFamily: 'Poppins',),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOptionTile('Support',context),
                SizedBox(height: 10.h),
                _buildOptionTile('Preferences',context),
                SizedBox(height: 10.h),
                _buildOptionTile('Notifications',context),
                SizedBox(height: 30.h),
                ElevatedButton.icon(
                  onPressed: () async {
                    await supabase.auth.signOut();
                    if (context.mounted) {
                      context.go(LoginScreen.routePath);
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEFF7FF),
                    foregroundColor: const Color(0xff037dff),
                    side: const BorderSide(color: Color(0xff037dff)),
                    minimumSize: Size(double.infinity, 45.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOptionTile(String title,BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5,color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: Theme.of(context).textTheme.bodyMedium,),
          Icon(Icons.arrow_forward_ios_rounded,size: 15,),
        ],
      ),
    );
  }
}
