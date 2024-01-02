import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/request_controller.dart'; // Import your WebRequestController class
import '../../models/user.dart';

class AdminStats extends StatefulWidget {
  const AdminStats({Key? key}) : super(key: key);

  @override
  State<AdminStats> createState() => _AdminStatsState();
}

class _AdminStatsState extends State<AdminStats> {
  late List<User> companyuser;
  late List<User> jobseekers;

  Future<void> getJobSeeker() async {
    final prefs = await SharedPreferences.getInstance();
    String? server = prefs.getString("localhost");
    WebRequestController req = WebRequestController(
      path: "/inployed/user/admin/ctrlUserJobSeeker/Job Seeker",
      server: "http://$server:8080",
    );

    await req.get();

    if (req.status() == 200) {
      List<dynamic> data = req.result();
      setState(() {
        jobseekers = data.map((json) => User.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to fetch job');
    }
  }

  Future<void> getCompanyUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? server = prefs.getString("localhost");
    WebRequestController req = WebRequestController(
      path: "/inployed/user/admin/ctrlUserCompany/Company",
      server: "http://$server:8080",
    );

    await req.get();

    if (req.status() == 200) {
      List<dynamic> data = req.result();
      setState(() {
        companyuser = data.map((json) => User.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to fetch job');
    }
  }

  Future<void> fetchData() async {
    // Fetch jobseekers and companyuser data
    await getJobSeeker();
    await getCompanyUser();
  }

  @override
  void initState() {
    super.initState();
    jobseekers = [];
    companyuser = [];
    fetchData();
  }

  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        color: Colors.blue,
        title: 'Job Seekers',
        titleStyle: GoogleFonts.poppins(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        value: jobseekers.length.toDouble(),
        radius: 150,
      ),
      PieChartSectionData(
        color: Colors.green,
        title: 'Company Users',
        titleStyle: GoogleFonts.poppins(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        value: companyuser.length.toDouble(),
        radius: 150,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(249, 151, 119, 1),
                Color.fromRGBO(98, 58, 162, 1),
              ],
            ),
          ),
        ),
        title: Center(
          child: Text(
            'Pie Chart ',
            style: GoogleFonts.poppins(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFBC2EB), // #fbc2eb
              Color(0xFFA6C1EE), // #a6c1ee
            ],
          ),
        ),
        child: jobseekers.isNotEmpty && companyuser.isNotEmpty
            ? PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      // Handle touch interactions here
                    },
                  ),
                  sections: showingSections(),
                  borderData: FlBorderData(show: false),
                  centerSpaceRadius: 0,
                  sectionsSpace: 0,
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
