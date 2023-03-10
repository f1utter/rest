import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Api Calls',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Codeforces Problem Set'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Map<String,dynamic>> info;
  @override
  void initState(){
    info=giver();
    super.initState();
  }

  Future<Map<String,dynamic>> giver() async{
    var response = await http.get(Uri.parse("https://www.boredapi.com/api/activity"));
    Map<String,dynamic> result=json.decode(response.body);
    //print(result);
    return result;
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bored API"),
        actions: [
          IconButton(onPressed: ()=>setState(() {
            info=giver();
          }), icon: const Icon(Icons.refresh_rounded))
        ],
      ),
      body: FutureBuilder<Map<String,dynamic>>(
        future: info,
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          Map<String,dynamic> data={};
          if(snapshot.hasData){
            data=snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Activity: ${data["activity"]}"),
                  Text("Type: ${data["type"]}"),
                  Text("Participants: ${data["participants"]}"),
                  Text("Price: \$${data["price"]}"),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
