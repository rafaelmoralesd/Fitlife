import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
        displayName = _currentUser?.displayName ?? "Guest User";
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    // Información predeterminada
    String defaultEmail = "guest@domain.com";
    String defaultPhotoUrl = "https://via.placeholder.com/150";

    // Usa la información del usuario si está disponible, de lo contrario usa los valores predeterminados
    String email = _currentUser?.email ?? defaultEmail;
    String photoUrl = _currentUser?.photoUrl ?? defaultPhotoUrl;

    return Scaffold(
      appBar: AppBar(
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
                  opacity: 0.3,
                  image: AssetImage('assets/imagen 4.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/perfil.jpg'),
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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Trans.',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feeds',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
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
    TextEditingController _nameController = TextEditingController(text: displayName);

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
                setState(() {
                  displayName = _nameController.text;
                });
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

// Página ficticia para editar el perfil
class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Center(
        child: Text("Aquí se editará la información del perfil"),
      ),
    );
  }
}