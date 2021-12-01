import 'dart:convert';
import 'dart:io';

import 'package:advent_sols/auxtools.dart' as tools;

int ex1_1(List<int> fields){
  return tools.count_increasing(fields);
}
int ex1_2(List<int> fields){
  return tools.count_increasing(  // Get increasing
      tools.moving_sum(fields, 3) // Rolling sum (3)
  );
}

void main(List<String> arguments) async{
  final input = File('inputs/advent1.csv').openRead();
  final fields = await input
      .map(utf8.decode)
      .transform(LineSplitter())
      .map(int.parse)
      .toList();
  print('ex1_1: ${ex1_1(fields)}');
  print('ex1_2: ${ex1_2(fields)}');
}
