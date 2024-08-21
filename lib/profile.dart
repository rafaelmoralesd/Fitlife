import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'inputs_page.dart';
import 'principal_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GoogleSignInAccount? _currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  String? displayName;

  @override
  void initState() {
    super.initState();
   _loadDisplayName();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
        
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _loadDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('displayName') ?? "Guest User";
          print('si');
    });
  }

  Future<void> _saveDisplayName(String newName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('displayName', newName);
    print('si');
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.disconnect();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => InputsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String email = _currentUser?.email ?? "guest@domain.com";
    String photoUrl =
        _currentUser?.photoUrl ?? "https://via.placeholder.com/150";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 206, 55, 118),
        title: Text('Profile'),
        
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.2,
            image: AssetImage('assets/imagen1.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundImage:AssetImage('assets/perfil.jpg'),
              ),
              SizedBox(height: 10),
              Text(
                displayName ?? "Guest User",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                email,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20),
              _buildProfileOption(
                icon: Icons.edit,
                title: 'Edit profile information',
                onTap: () {
                   
                  _editDisplayName(context);
                },
              ),
              _buildProfileOption(
                icon: Icons.language,
                title: 'Language',
                trailing: Text('English'),
                onTap: () {
                  _showLanguageDialog(context);
                },
              ),
              _buildProfileOption(
                icon: Icons.brightness_6,
                title: 'Theme',
                trailing: Text('Light mode'),
                onTap: () {
                  _showThemeDialog(context);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSignOut,
                child: Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing ?? Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _editDisplayName(BuildContext context) {
    TextEditingController _nameController =
        TextEditingController(text: displayName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Display Name'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "Display Name"),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                String newDisplayName = _nameController.text.trim();
                if (newDisplayName.isNotEmpty) {
                  setState(() {
                    displayName = newDisplayName;
                    _saveDisplayName(newDisplayName);
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: Text('English'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Español'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Theme'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: Text('Light Mode'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Dark Mode'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
