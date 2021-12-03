import 'package:quiver/iterables.dart';
import 'package:collection/collection.dart';
import 'dart:math';

// Day 1
List<int> moving_sum(List<int> fields, int n){
  final temp_list = <List<int>>[];
  for (int i=0; i<n; i++){
    temp_list.add(fields.sublist(i,fields.length-(n-i-1)));
  }
  return zip(temp_list) // Make tuples
      .map((e)=>e.reduce((value, element) => value + element)) // Sum tuples
      .toList();
}

int count_increasing(List<int> fields){
  return zip([fields.sublist(1),fields.sublist(0,fields.length-1)]) // Take in pairs
      .where((v)=>v[0]>v[1]) // Filter increasing
      .length;               // List length
}

// Day 2
enum D2Instruction{ down,up,forward }
D2Instruction d2ins_map(String k){
  if (k == 'down') return D2Instruction.down;
  else if (k == 'up') return D2Instruction.up;
  else if (k == 'forward') return D2Instruction.forward;
  else throw Exception();
}

class D2In{
  late D2Instruction i;
  late int v;
  D2In(this.i,this.v);
}

class D2Pos{
  int horizontal = 0;
  int depth = 0;
  int aim = 0;
}

//Day 3
Iterable<num> mean_vector(List<List<int>> l){
  int s = l.length;
  return l.reduce(                          // Sum all vectors
          (a,b)=>zip<int>([a,b])        // For each value
          .map((a)=>a[0]+a[1]).toList() // Sum value
  ).map((a)=>(a/s));                        // Mean
}

int bin_to_int(List<int> l){
  return l.reversed                     // MSB to the right
      .mapIndexed((i, v) => pow(2,i)*v) // 2**i
      .reduce((a,b)=>a+b)               // sum
      .round();                         // num to int
}