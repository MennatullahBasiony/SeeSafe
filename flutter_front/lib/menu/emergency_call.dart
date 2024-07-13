import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyCall extends StatefulWidget {
  const EmergencyCall({Key? key});

  @override
  State<EmergencyCall> createState() => _EmergencyCallState();
}

class _EmergencyCallState extends State<EmergencyCall> {
  final TextEditingController _emergencyNumberController = TextEditingController();
  late SharedPreferences _prefs;
  String _emergencyNumber = '';

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    // Retrieve emergency number from SharedPreferences
    _emergencyNumber = _prefs.getString('emergency_number') ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCEEFD),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFDCEEFD),
        title: SizedBox(
          width: 100,
          height: 100,
          child: Image.asset(
            'assets/smallLogo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _emergencyNumber.isNotEmpty
                ? const Icon(
                    Icons.phone,
                    size: 150,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.call,
                    size: 150,
                    color: Colors.white,
                  ),
            const SizedBox(height: 20),
            SizedBox(
              width: 280,
              height: 112,
              child: ElevatedButton(
                onPressed: _emergencyNumber.isNotEmpty
                    ? () => _callEmergencyNumber(_emergencyNumber)
                    : _setEmergencyNumber,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF2EA8ED)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(
                    _emergencyNumber.isNotEmpty
                        ? 'Click to call $_emergencyNumber'
                        : 'Set Emergency Number',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Color(0xFF2EA8ED),
        height: 60,
        child: SizedBox(
          height: 20,
          child: Center(
            child: Text(
              'Emergency Call',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _setEmergencyNumber() async {
    final number = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Emergency Number'),
        content: TextField(
          controller: _emergencyNumberController,
          keyboardType: TextInputType.phone,
          maxLength: 11, // Limit to 11 characters
          decoration: const InputDecoration(
            labelText: 'Enter Emergency Number',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final enteredNumber = _emergencyNumberController.text.trim();
              // Validate entered number
              if (_validateNumber(enteredNumber)) {
                Navigator.of(context).pop(enteredNumber);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid 11-digit number.'),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (number != null) {
      // Save emergency number to SharedPreferences
      await _prefs.setString('emergency_number', number);
      setState(() {
        _emergencyNumber = number;
      });
    }
  }

  bool _validateNumber(String number) {
    // Validate number format (e.g., 11 digits)
    return number.length == 11 && int.tryParse(number) != null;
  }

 Future<void> _callEmergencyNumber(String number) async {
  print('Calling number: $number');
  final result = await FlutterPhoneDirectCaller.callNumber(number);
  print('Call result: $result');
}

}


