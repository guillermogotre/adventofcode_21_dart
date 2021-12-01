import 'package:quiver/iterables.dart';

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
