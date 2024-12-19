
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:employerapp/Authentication/auth_intropage/intro.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

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
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 5,
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            SharedPreferences logpref = await SharedPreferences.getInstance();
            showDialog(
              context: context,
              builder: (context) {
                return _buildLogoutDialog(context, logpref);
              },
            );
          },
          icon: const Icon(Icons.logout, color: Colors.white),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromARGB(255, 157, 128, 128), Color.fromARGB(255, 106, 121, 205)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
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
                        profileImg ?? 'https://yourfallbackurl.com/default_profile.jpg',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),

            // Name and Email Section
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

            // Profile Details Section
            _buildProfileTile(Icons.phone, "Phone", phone ?? 'Not Provided'),
            _buildProfileTile(Icons.badge, "License Number", licenseNumber ?? 'Not Provided'),
            _buildProfileTile(Icons.directions_car, "Vehicle Type", vehicleType ?? 'Not Provided'),
            _buildProfileTile(Icons.article, "Vehicle RC Number", vehicleRC ?? 'Not Provided'),
            const SizedBox(height: 20),

            // Document Section
            _buildDocumentCard(context, 'License Image', licenseImg ?? ''),
            _buildDocumentCard(context, 'Vehicle Permit', vehiclePermit ?? ''),
          ],
        ),
      ),
    );
  }

  // Logout Dialog
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

  // Profile Tile
  Widget _buildProfileTile(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.withOpacity(0.2),
          child: Icon(icon, color: Colors.deepPurple),
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

  // Document Card
  Widget _buildDocumentCard(BuildContext context, String label, String imageUrl) {
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
