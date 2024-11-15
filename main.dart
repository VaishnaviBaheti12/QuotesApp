import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyQuoteApp());
}

class MyQuoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inspiring Quotes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(username: 'User'), // Directly set the username here
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String username;
  HomeScreen({required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences? prefs;
  List<String> favoriteQuotes = [];

  final Map<String, List<String>> categorizedQuotes = {
    'Motivational': [
      "The best way to predict the future is to create it. 💪",
      "The only way to do great work is to love what you do. 🌟",
      "In the middle of difficulty lies opportunity. 💼",
    ],
    'Happy': [
      "Happiness is not by chance, but by choice. 😊",
      "Keep smiling and one day life will get tired of upsetting you. 😄",
      "Live life happy, live life positive. 😁",
    ],
    'Sad': [
      "Tears come from the heart and not from the brain. 😢",
      "The greatest pain that comes from love is loving someone you can never have. 💔",
      "Sometimes, it’s hard to let go of the past. 😔",
    ],
    'Inspirational': [
      "What we achieve inwardly will change outer reality. 🌍",
      "Success is the sum of small efforts, repeated day in and day out. 🌱",
      "Believe you can and you're halfway there. 🎯",
    ],
    'Funny': [
      "I am on a seafood diet. I see food, and I eat it. 😂",
      "Why don’t skeletons fight each other? They don’t have the guts! 💀",
      "I used to play piano by ear, but now I use my hands. 🎹",
    ]
  };

  void _loadFavorites() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteQuotes = prefs?.getStringList('favorites') ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _openCategoryScreen(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CategoryScreen(category: category, quotes: categorizedQuotes[category]!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home - Welcome ${widget.username}"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Welcome, ${widget.username}',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(username: widget.username)));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Select a Category to View Quotes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: categorizedQuotes.keys.length,
                itemBuilder: (context, index) {
                  final category = categorizedQuotes.keys.elementAt(index);
                  return Card(
                    child: ListTile(
                      title: Text(category),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () => _openCategoryScreen(category),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryScreen extends StatefulWidget {
  final String category;
  final List<String> quotes;
  CategoryScreen({required this.category, required this.quotes});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<String> favoriteQuotes = [];

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteQuotes = prefs.getStringList('favorites') ?? [];
    });
  }

  void _toggleFavorite(String quote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteQuotes.contains(quote)) {
        favoriteQuotes.remove(quote);
      } else {
        favoriteQuotes.add(quote);
      }
      prefs.setStringList('favorites', favoriteQuotes);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.category} Quotes")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: widget.quotes.length,
          itemBuilder: (context, index) {
            final quote = widget.quotes[index];
            final isFavorite = favoriteQuotes.contains(quote);

            return ListTile(
              title: Text(quote),
              trailing: IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.grey),
                onPressed: () => _toggleFavorite(quote),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.tune),
            title: Text("Preferences"),
            onTap: () {
              
              
              // Navigate to Preferences Screen
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text("Topics You Follow"),
            onTap: () {
              // Navigate to Topics You Follow Screen
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("Favorites"),
            onTap: () {
              // Navigate to Favorites Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text("History"),
            onTap: () {
              // Navigate to History Screen
            },
          ),
          ListTile(
            leading: Icon(Icons.note_add),
            title: Text("Your Own Quotes"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => YourOwnQuotesScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.collections),
            title: Text("Collections"),
            onTap: () {
              // Navigate to Collections Screen
            },
          ),
        ],
      ),
    );
  }
}


class PreferenceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _PreferenceOption(
            icon: Icons.star,
            title: 'Premium',
            onTap: () => _showDetails(context, 'Premium Option'),
          ),
          _PreferenceOption(
            icon: Icons.edit,
            title: 'Make it Yours',
            onTap: () => _showDetails(context, 'Make it Yours Option'),
          ),
          _PreferenceOption(
            icon: Icons.account_circle,
            title: 'Account',
            onTap: () => _showDetails(context, 'Account Option'),
          ),
          _PreferenceOption(
            icon: Icons.support,
            title: 'Support Us',
            onTap: () => _showDetails(context, 'Support Us Option'),
          ),
          _PreferenceOption(
            icon: Icons.help_outline,
            title: 'Help',
            onTap: () => _showDetails(context, 'Help Option'),
          ),
          _PreferenceOption(
            icon: Icons.follow_the_signs,
            title: 'Follow Us',
            onTap: () => _showDetails(context, 'Follow Us Option'),
          ),
          _PreferenceOption(
            icon: Icons.more_horiz,
            title: 'Others',
            onTap: () => _showDetails(context, 'Others Option'),
          ),
        ],
      ),
    );
  }

  // Method to show the selected option's details
  void _showDetails(BuildContext context, String option) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(option),
          content: Text('This is the details for $option.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class _PreferenceOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;

  _PreferenceOption({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: () => onTap(),
    );
  }
}


class ProfileScreen extends StatelessWidget {
  final String username;
  ProfileScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Profile of $username", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text("Login"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
              },
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // You can add validation and authentication logic here

    if (username.isNotEmpty && password.isNotEmpty) {
      // Save login information or handle authentication here
      Navigator.pop(context); // Close login screen on success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter valid username and password.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();

  void _signup() {
    final name = _nameController.text;
    final username = _usernameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final age = _ageController.text;

    if (name.isNotEmpty && username.isNotEmpty && email.isNotEmpty && phone.isNotEmpty && age.isNotEmpty) {
      // Save the signup information or handle the account creation logic
      Navigator.pop(context); // Close signup screen on success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all fields.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Phone Number"),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: "Age"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signup,
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}


class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> favoriteQuotes = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Load the favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteQuotes = prefs.getStringList('favorites') ?? [];
    });
  }

  // Remove a quote from favorites
  void _removeFavorite(String quote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteQuotes.remove(quote); // Remove the quote from the list
      prefs.setStringList('favorites', favoriteQuotes); // Update SharedPreferences
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorites")),
      body: favoriteQuotes.isEmpty
          ? Center(child: Text("No favorites added yet."))
          : ListView.builder(
              itemCount: favoriteQuotes.length,
              itemBuilder: (context, index) {
                final quote = favoriteQuotes[index];
                return ListTile(
                  title: Text(quote),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _removeFavorite(quote); // Remove the quote when the delete icon is pressed
                    },
                  ),
                );
              },
            ),
    );
  }
  }
class YourOwnQuotesScreen extends StatefulWidget {
  @override
  _YourOwnQuotesScreenState createState() => _YourOwnQuotesScreenState();
}

class _YourOwnQuotesScreenState extends State<YourOwnQuotesScreen> {
  final _quoteController = TextEditingController();
  List<String> _ownQuotes = [];

  // Load saved quotes
  void _loadOwnQuotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ownQuotes = prefs.getStringList('ownQuotes') ?? [];
    });
  }

  // Save a new quote
  void _saveQuote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ownQuotes.add(_quoteController.text);
      prefs.setStringList('ownQuotes', _ownQuotes);
    });
    _quoteController.clear();
  }

  // Remove a quote
  void _removeQuote(String quote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ownQuotes.remove(quote);
      prefs.setStringList('ownQuotes', _ownQuotes);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadOwnQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Own Quotes")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _quoteController,
              decoration: InputDecoration(labelText: "Enter your own quote"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveQuote,
              child: Text("Save Quote"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _ownQuotes.isEmpty
                  ? Center(child: Text("No quotes added yet"))
                  : ListView.builder(
                      itemCount: _ownQuotes.length,
                      itemBuilder: (context, index) {
                        final quote = _ownQuotes[index];
                        return ListTile(
                          title: Text(quote),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _removeQuote(quote),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}