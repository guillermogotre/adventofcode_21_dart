import 'dart:convert';
import 'dart:io';
import 'package:advent_sols/auxtools.dart';



int ex1_1(List<int> fields){
  return count_increasing(fields);
}
int ex1_2(List<int> fields){
  return count_increasing(  // Get increasing
      moving_sum(fields, 3) // Rolling sum (3)
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
// instr = pd.read_csv('day2.txt',sep=' ',header=None)
// def aim_foo(acum,x):
//   I = x[0]
//   v = x[1]
//   if I in ['down','up']:
//     acum['aim'] += v * (-1 if I == 'up' else 1)
//   else:
//     acum['hor'] += v
//     acum['dep'] += v*acum['aim']
//   return acum
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

// import numpy as np
// import pandas as pd
// from functools import reduce

// arr_to_binary = lambda x: "".join(x.astype(int).astype(str))
// with open('day3.txt','r') as ifile:
//     lst = np.array([list(x.split()[0]) for x in ifile.readlines()]).astype(int)

// cad = arr_to_binary(lst.mean(0)>=0.5) # Binary rep
// FF = (2**len(cad))-1                 # All 1s binary
// cad = int(cad,2)                     # Integer

// cad * (FF & (~cad))
int ex3_1(List<List<int>> l){
  final rev_list = mean_vector(l).map((a)=>a>=0.5 ? 1 : 0).toList();
  int gamma_rate = bin_to_int(rev_list);
  int eps_rate = bin_to_int(rev_list.map((a)=>1-a).toList());
  return (gamma_rate*eps_rate);
}

// import numpy as np
// import pandas as pd
// from functools import reduce
//
// arr_to_binary = lambda x: "".join(x.astype(int).astype(str))
// with open('day3.txt','r') as ifile:
//     lst_ori = np.array([list(x.split()[0]) for x in ifile.readlines()]).astype(int)
//
// res = []
// for neg in [False,True]:
//     lst = lst_ori.copy()
//     i = 0
//     while lst.shape[0] > 1:
//         th = np.logical_xor((lst[:,i].mean() >= 0.5),neg)
//         msk = lst[:,i] == th
//         lst = lst[msk]
//         i+=1
//     res.append(int("".join(lst[0].astype(str)),2))
//
// res[0]*res[1]
int ex3_2(List<List<int>> l_ori){
  List<int> res = [];
  for (int xor in [0,1]){
    int i = 0;
    List<List<int>> l = List.from(l_ori); // Copy list
    while(l.length > 1){
      // Most / Least (xor) frequent value
      int v = mean_vector(l).toList()[i] >= 0.5 ? (1-xor) : (xor-0);
      // Filter by value
      l = l.where((a)=>a[i]==v).toList();
      i++;
    }
    int rating = bin_to_int(l[0]);
    res.add(rating);
  }
  return res[0]*res[1];
}

void ex3() async{
  final input = File('inputs/day3.txt').openRead();
  final fields = await input
      .map(utf8.decode)
      .transform(LineSplitter())
      .map((a)=>a.split("").map(int.parse).toList())
      .toList();
  print('ex3_1: ${ex3_1(fields)}');
  print('ex3_2: ${ex3_2(fields)}');
}

void main(List<String> arguments){
  ex1();
  ex2();
  ex3();
}
