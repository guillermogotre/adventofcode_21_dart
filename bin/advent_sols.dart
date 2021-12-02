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

void ex1() async{
  final input = File('inputs/advent1.csv').openRead();
  final fields = await input
      .map(utf8.decode)
      .transform(LineSplitter())
      .map(int.parse)
      .toList();
  print('ex1_1: ${ex1_1(fields)}');
  print('ex1_2: ${ex1_2(fields)}');
}

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
  // D2Pos({this.horizontal=0, this.depth=0, this.aim=0});
}

// import numpy as np
// import pandas as pd
// instr = pd.read_csv('day2.txt',sep=' ',header=None)
// instr.columns = ['I','n']
// instr_sum = instr.groupby('I').sum().to_dict()['n']
// (instr_sum['down']-instr_sum['up'])*instr_sum['forward']
int ex2_1(List<D2In> s){
  D2Pos pos = s.fold(
      D2Pos(),
      (prev,el){
        if (el.i == D2Instruction.forward)
          prev.horizontal += el.v;
        else
          prev.depth += (el.i == D2Instruction.up)?-el.v:el.v;
        return prev;
      });
  return pos.horizontal * pos.depth;
}

// import numpy as np
// import pandas as pd
// from functools import reduce
//
// instr = pd.read_csv('day2.txt',sep=' ',header=None)
//
// def aim_foo(acum,x):
// I = x[0]
// v = x[1]
// if I in ['down','up']:
// acum['aim'] += v * (-1 if I == 'up' else 1)
// else:
// acum['hor'] += v
// acum['dep'] += v*acum['aim']
// return acum
//
// res = reduce(aim_foo,instr.to_numpy(),{k:0 for k in ['hor','dep','aim']})
// res['hor']*res['dep']
int ex2_2(List<D2In> s){
  D2Pos pos = s.fold(
      D2Pos(),
          (prev,el){
        if (el.i == D2Instruction.forward) {
          prev.horizontal += el.v;
          prev.depth += el.v*prev.aim;
        }
        else
          prev.aim += (el.i == D2Instruction.up)?-el.v:el.v;
        return prev;
      }
  );
  return pos.horizontal * pos.depth;
}

void ex2() async{
  final input = File('inputs/day2.txt').openRead();
  final fields = await input
      .map(utf8.decode)
      .transform(LineSplitter())
      .map(
          (a)=>
              D2In(
                  d2ins_map(a.split(' ')[0]),
                  int.parse(a.split(' ')[1])))
      .toList();

  print('ex2_1: ${ex2_1(fields)}');
  print('ex2_2: ${ex2_2(fields)}');
}

void main(List<String> arguments){
  ex1();
  ex2();
}
