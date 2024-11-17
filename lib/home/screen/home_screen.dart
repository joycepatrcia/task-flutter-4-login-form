import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/auth/auth.dart';
import 'package:flutter_login/wise_word.dart';  // Mengimpor halaman Wise Word
import 'package:flutter_login/post_list/view/post_list_page.dart';  // Mengimpor halaman Post List

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (_) => const HomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengukur lebar layar
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          color: Colors.red,
          onPressed: () {
            context.read<AuthCubit>().logout();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container untuk welcome message dan balance
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Color(0xFF514066), Color(0xFFB39DDB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Builder(
                  builder: (context) {
                    final user = context.select(
                      (AuthCubit auth) => auth.state.user,
                    );
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome, ${user?.name ?? ''}!',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your balance: \Rp ${user?.balance ?? ''}',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 32), 

              // Tombol Wise Word (warna #514066)
              Container(
                width: screenWidth * 0.5, 
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WiseWordPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: const Color(0xFF514066), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.black.withOpacity(0.2),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Wise Word',
                    style: TextStyle(fontSize: 18, color: Colors.white), 
                  ),
                ),
              ),
              const SizedBox(height: 16), 


              Container(
                width: screenWidth * 0.5, 
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PostListPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: const Color(0xFF514066), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.black.withOpacity(0.2),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Post List',
                    style: TextStyle(fontSize: 18, color: Colors.white), 
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
