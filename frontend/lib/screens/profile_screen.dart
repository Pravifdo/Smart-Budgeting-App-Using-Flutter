import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/api_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Praveen Ruchira";
  String userJob = "Software Engineer";
  String userEmail = "praveen@example.com";
  String? profileImageUrl;
  
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  List<Map<String, dynamic>> allTransactions = [];
  bool isLoading = true;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      final bytes = await selectedImage.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      await ApiService.updateProfile({
        "profileImage": base64Image
      });

      setState(() {
        _image = selectedImage;
        profileImageUrl = base64Image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final userProfile = await ApiService.getProfile();
      final expenses = await ApiService.getExpenses();
      final incomes = await ApiService.getIncomes();

      double totalInc = 0;
      for (var item in incomes) {
        totalInc += (item['amount'] as num).toDouble();
      }

      double totalExp = 0;
      for (var item in expenses) {
        totalExp += (item['amount'] as num).toDouble();
      }

      List<Map<String, dynamic>> combined = [];
      for (var item in incomes) {
        combined.add({
          "title": item['source'] ?? "Income",
          "amount": (item['amount'] as num).toDouble(),
          "date": DateTime.parse(item['date']),
          "isIncome": true,
        });
      }
      for (var item in expenses) {
        combined.add({
          "title": item['category'] ?? "Expense",
          "amount": (item['amount'] as num).toDouble(),
          "date": DateTime.parse(item['date']),
          "isIncome": false,
        });
      }

      combined.sort((a, b) => b['date'].compareTo(a['date']));

      setState(() {
        userName = userProfile['name'] ?? userName;
        userJob = userProfile['job'] ?? userJob;
        userEmail = userProfile['email'] ?? userEmail;
        profileImageUrl = userProfile['profileImage'];
        totalIncome = totalInc;
        totalExpense = totalExp;
        allTransactions = combined;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.blueAccent,
                              backgroundImage: _image != null
                                  ? (kIsWeb
                                      ? NetworkImage(_image!.path)
                                      : FileImage(File(_image!.path)) as ImageProvider)
                                  : (profileImageUrl != null && profileImageUrl!.isNotEmpty
                                      ? MemoryImage(base64Decode(profileImageUrl!))
                                      : null),
                              child: (_image == null && (profileImageUrl == null || profileImageUrl!.isEmpty))
                                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.blueAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          userName,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          userJob,
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem("Income", totalIncome, Colors.green),
                      _buildStatItem("Expense", totalExpense, Colors.red),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Account Info Section
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Account Information",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildInfoTile(Icons.email, "Email", userEmail),
                  _buildInfoTile(Icons.work, "Occupation", userJob),
                  _buildInfoTile(Icons.location_on, "Location", "Sri Lanka"),

                  const SizedBox(height: 30),

                  // Transaction History Section
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Full Transaction History",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allTransactions.length,
                    itemBuilder: (context, index) {
                      final tx = allTransactions[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: (tx['isIncome'] ? Colors.green : Colors.red).withValues(alpha: 0.1),
                          child: Icon(
                            tx['isIncome'] ? Icons.arrow_downward : Icons.arrow_upward,
                            color: tx['isIncome'] ? Colors.green : Colors.red,
                            size: 20,
                          ),
                        ),
                        title: Text(tx['title']),
                        subtitle: Text(tx['date'].toString().split(' ')[0]),
                        trailing: Text(
                          "${tx['isIncome'] ? '+' : '-'} Rs. ${tx['amount']}",
                          style: TextStyle(
                            color: tx['isIncome'] ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ApiService.logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[50],
                        foregroundColor: Colors.red,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                      child: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatItem(String title, double amount, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(height: 5),
        Text(
          "Rs. ${amount.toStringAsFixed(0)}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
      contentPadding: EdgeInsets.zero,
    );
  }
}
