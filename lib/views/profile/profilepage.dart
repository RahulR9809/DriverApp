import 'package:employerapp/core/colors.dart';
import 'package:employerapp/views/Nav/main_page.dart';
import 'package:employerapp/views/settings/healp_and_support.dart';
import 'package:employerapp/views/settings/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:employerapp/views/auth/intro_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? email;
  String? phone;
  String? licenseNumber;
  String? vehicleType;
  String? vehicleRC;
  String? profileImg;
  String? licenseImg;
  String? vehiclePermit;
  CustomColors customcolors = CustomColors();
  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('user_name') ?? 'Unknown Name';
      email = prefs.getString('user_email') ?? 'unknown@example.com';
      phone = prefs.getString('user_phone') ?? 'Not Provided';
      licenseNumber = prefs.getString('user_licenseNumber') ?? 'Not Provided';
      vehicleType = prefs.getString('user_vehicleType') ?? 'Not Provided';
      vehicleRC = prefs.getString('user_rc_Number') ?? 'Not Provided';

      profileImg = prefs.getString('user_profileUrl')?.isNotEmpty == true
          ? prefs.getString('user_profileUrl')
          : 'https://yourfallbackurl.com/default_profile.jpg';

      licenseImg = prefs.getString('user_licenseUrl')?.isNotEmpty == true
          ? prefs.getString('user_licenseUrl')
          : 'https://yourfallbackurl.com/default_license.jpg';

      vehiclePermit = prefs.getString('user_vehiclePermit')?.isNotEmpty == true
          ? prefs.getString('user_vehiclePermit')
          : 'https://yourfallbackurl.com/default_permit.jpg';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: CustomColors.lightBlue,
        elevation: 5,
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: CustomColors.white),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              color: CustomColors.lightBlue,
              child: const Center(
                  child: Text(
                'Electra',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              )),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: CustomColors.green),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const MainPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip, color: CustomColors.green),
              title: const Text('Privacy Policy'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyPage()));
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.help_outline, color: CustomColors.green),
              title: const Text('Help & Support'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HelpSupportPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: CustomColors.green),
              title: const Text('Share the App'),
              onTap: () {
                // Handle ride history navigation
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                SharedPreferences logpref =
                    await SharedPreferences.getInstance();
                showDialog(
                  context: context,
                  builder: (context) {
                    return _buildLogoutDialog(context, logpref);
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: CustomColors.lightBlue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: MediaQuery.of(context).size.width / 2 - 60,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 56,
                      backgroundImage: NetworkImage(
                        profileImg ??
                            'https://yourfallbackurl.com/default_profile.jpg',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
            Text(
              name ?? 'Unknown Name',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              email ?? 'unknown@example.com',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileTile(Icons.phone, "Phone", phone ?? 'Not Provided'),
            _buildProfileTile(
                Icons.badge, "License Number", licenseNumber ?? 'Not Provided'),
            _buildProfileTile(Icons.directions_car, "Vehicle Type",
                vehicleType ?? 'Not Provided'),
            _buildProfileTile(Icons.article, "Vehicle RC Number",
                vehicleRC ?? 'Not Provided'),
            const SizedBox(height: 20),
            _buildDocumentCard(context, 'License Image', licenseImg ?? ''),
            _buildDocumentCard(context, 'Vehicle Permit', vehiclePermit ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutDialog(BuildContext context, SharedPreferences logpref) {
    return AlertDialog(
      title: const Text(
        "Logout",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text("Are you sure you want to log out?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () async {
            await logpref.clear();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const IntroPage()),
            );
          },
          child: const Text("Logout"),
        ),
      ],
    );
  }

  Widget _buildProfileTile(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: CustomColors.lightBlue,
          child: Icon(
            icon,
            color: CustomColors.white,
          ),
        ),
        title: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _buildDocumentCard(
      BuildContext context, String label, String imageUrl) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(imageUrl, fit: BoxFit.cover),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: Colors.grey[300],
          ),
          title: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
