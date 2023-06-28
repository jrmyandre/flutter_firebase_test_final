import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String data = '';
  String lat = '';
  String lng = '';
  final dbReference = FirebaseDatabase.instance.ref().child('locations');
  final dbReferencePhone = FirebaseDatabase.instance.ref().child('phone');
  final phoneController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();
  final usernamecontroller = TextEditingController();
  List<Map<dynamic, dynamic>> dataList = [];
  List<Map<dynamic, dynamic>> dataListPhone = [];
  bool? _selectedValue;
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  
  @override
  void initState() {
    super.initState();

    dbReference.onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, values) {
        if (values['longitude'] == "") {
          dbReference.child(key).remove();
        }
      });
    });

  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firebase Realtime Database'),
        ),
        body: Center(
          child: Column(
            children: [
              // Text(dataList.toString() ),
              Text(lng ),
              SizedBox(height: 20),
              TextField(
                controller: latController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your latitude',
                ),

              ),
              SizedBox(height: 20),
              TextField(
                controller: lngController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your longitude',
                ),

              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your phone number',
                ),

              
              ),
              TextField(
                controller: usernamecontroller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your user id',
                ),

              
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Radio<bool>(
                    value: true, 
                    groupValue: _selectedValue, 
                    onChanged: (value){
                      setState(() {
                        _selectedValue = value;
                      });
                    }
                    ),

                    Radio<bool>(
                      value: false, 
                      groupValue: _selectedValue, 
                      onChanged: (value){
                        setState(() {
                          _selectedValue = value;
                        });
                      }
                      )
                ]
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    now = DateTime.now();
                    Map<String, dynamic> data = {
                    'latitude': latController.text,
                    'longitude': lngController.text,
                    'manual': _selectedValue,
                    'manual temp': _selectedValue,
                    'phone number': phoneController.text,
                    'user id': usernamecontroller.text,

                    'timestamp': formatter.format(now)
                  };
                  dbReference.push().set(data);   
                  latController.clear();
                  lngController.clear();
                  });

                },
                child: const Text('Submit'),
              ),
              
            ],
          )
        ),
      ),
    );
  }
}
