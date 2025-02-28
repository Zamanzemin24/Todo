import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class pagetodo extends StatelessWidget {
  final Box taskbos =Hive.box('todo');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hive to do"),
      ),
      body: ValueListenableBuilder(
        
        valueListenable: taskbos.listenable(),
         builder: 
         (context , Box box , _){
          List taskss=box.values.toList();
          return ListView.builder(
            itemCount: taskss.length,
            itemBuilder: (context ,index){
              return ListTile(
                title:,
              )
            })
         }
         ),
    );
  }
}