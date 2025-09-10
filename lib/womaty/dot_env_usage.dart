import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotEnvUsage extends StatefulWidget {
  const DotEnvUsage({super.key});

  @override
  State<DotEnvUsage> createState() => _DotEnvUsageState();
}

class _DotEnvUsageState extends State<DotEnvUsage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(dotenv.get("API_URL")),
      ),
    );
  }
}
