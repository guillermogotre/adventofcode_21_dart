import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:advent_sols/auxtools.dart';

int ex1_1(List<int> fields) {
  return countIncreasing(fields);
}

int ex1_2(List<int> fields) {
  return countIncreasing(// Get increasing
      movingSum(fields, 3) // Rolling sum (3)
      );
}

void ex1() async {
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
int ex2_1(List<D2In> s) {
  D2Pos pos = s.fold(D2Pos(), (prev, el) {
    if (el.i == D2Instruction.forward) {
      prev.horizontal += el.v;
    } else {
      prev.depth += (el.i == D2Instruction.up) ? -el.v : el.v;
    }
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
int ex2_2(List<D2In> s) {
  D2Pos pos = s.fold(D2Pos(), (prev, el) {
    if (el.i == D2Instruction.forward) {
      prev.horizontal += el.v;
      prev.depth += el.v * prev.aim;
    } else {
      prev.aim += (el.i == D2Instruction.up) ? -el.v : el.v;
    }
    return prev;
  });
  return pos.horizontal * pos.depth;
}

void ex2() async {
  final input = File('inputs/day2.txt').openRead();
  final fields = await input
      .map(utf8.decode)
      .transform(LineSplitter())
      .map((a) => D2In(d2insMap(a.split(' ')[0]), int.parse(a.split(' ')[1])))
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
int ex3_1(List<List<int>> l) {
  final revList = meanVector(l).map((a) => a >= 0.5 ? 1 : 0).toList();
  int gammaRate = binToList(revList);
  int epsRate = binToList(revList.map((a) => 1 - a).toList());
  return (gammaRate * epsRate);
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
int ex3_2(List<List<int>> lOri) {
  List<int> res = [];
  for (int xor in [0, 1]) {
    int i = 0;
    List<List<int>> l = List.from(lOri); // Copy list
    while (l.length > 1) {
      // Most / Least (xor) frequent value
      int v = meanVector(l).toList()[i] >= 0.5 ? (1 - xor) : (xor - 0);
      // Filter by value
      l = l.where((a) => a[i] == v).toList();
      i++;
    }
    int rating = binToList(l[0]);
    res.add(rating);
  }
  return res[0] * res[1];
}

void ex3() async {
  final input = File('inputs/day3.txt').openRead();
  final fields = await input
      .map(utf8.decode)
      .transform(LineSplitter())
      .map((a) => a.split("").map(int.parse).toList())
      .toList();
  print('ex3_1: ${ex3_1(fields)}');
  print('ex3_2: ${ex3_2(fields)}');
}

// is_winner = False
// n_iter = iter(numbers)
//
// while not is_winner:
//     b_iter = iter(boards)
//     n = next(n_iter)
//     while (not is_winner) and (b_new := next(b_iter,None)) is not None:
//         b = b_new
//         is_winner = b.add(n)
// b.unselected_sum()*n
int ex4_1(List<int> numbers, List<Board> boards) {
  for (int n in numbers) {
    for (Board b in boards) {
      if (b.add(n)) {
        return n * b.unselectedSum();
      }
    }
  }
  throw Exception("No winning board");
}

// boards_won = [False]*len(boards)
// n_iter = iter(numbers)
//
// winning_score = -1
// for n in numbers:
//     for i,b in enumerate(boards):
//         if not boards_won[i]:
//             w = b.add(n)
//             if w:
//                 boards_won[i] = w
//                 winning_score = b.unselected_sum()*n
//
// winning_score
int ex4_2(List<int> numbers, List<Board> boards) {
  int lastScore = 0;
  final bWon = boards.map((e) => false).toList();
  for (int n in numbers) {
    for (int i = 0; i < boards.length; i++) {
      if (!bWon[i]) {
        Board b = boards[i];
        bWon[i] = b.add(n);
        lastScore = bWon[i] ? n * b.unselectedSum() : lastScore;
      }
    }
  }
  return lastScore;
}

void ex4() async {
  final data = await parseBoardsStream('inputs/day4.txt');
  final numbers = data.item1;
  final boards = data.item2.map((b) => Board(b)).toList();

  print('ex4_1: ${ex4_1(numbers, boards)}');
  for (var b in boards) {
    b.reset();
  }
  print('ex4_2: ${ex4_2(numbers, boards)}');
}

//
// DAY 5
//

// '''
// Example input:
// 0,9 -> 5,9
// 8,0 -> 0,8
// '''
// with open('day5_mini.txt','r') as ifile:
//     res = [[[int(x) for x in e.split(',')] for e in r.split('->')] for r in ifile.readlines()]
//
// # ex1 / ex2 filter
// DO_FILTER = False # False for ex2
// is_straight_line = lambda x: (x[0][0] == x[1][0]) or (x[0][1] == x[1][1])
// res_filter = np.array(
//     list(filter(is_straight_line,res))
//     if DO_FILTER
//     else res)
//
// def interpolate_l(l):
//     target_size = (np.abs(l[1]-l[0])+1).max()
//     result = [np.linspace(*(l[:,i]),num=target_size,dtype=int) for i in range(2)]
//     return np.array(result).T
//
// field_counter = {}
// for l in res_filter:
//     for p in interpolate_l(l):
//         k = tuple(p)
//         v = field_counter.get(k,0) + 1
//         field_counter[k] = v
//
// ((np.array(list(field_counter.values()))>1).sum())

void ex5() async {
  final input = File('inputs/day5.txt').openRead();
  final fields = await input
      .map(utf8.decode)
      .transform(LineSplitter())
      .map((r) => r
          .split("->")
          .map((e) => e.split(",").map(int.parse).toList())
          .toList())
      .toList();

  print(
      'ex5_1: ${countIntersections(fields.where((x) => (x[0][0] == x[1][0]) | (x[0][1] == x[1][1])).toList())}');
  print('ex5_2: ${countIntersections(fields)}');
}

// '''
// Day 6. Example input:
//
// Example input:
// 3,4,3,1,2
// '''
// with open('day6.txt','r') as ifile:
//     res = [int(x) for x in ifile.read().split(',')]
//
// cache = {}
// def foo(init_n, t):
//     # Dynamic programming
//     if (init_n,t) in cache:
//         return cache[(init_n,t)]
//
//     if t < 0:
//         return 0
//     elif t == 0:
//         return 1
//
//     total = 0
//     if init_n == 0:
//         for p in [(6,t-1),(8,t-1)]:
//             cache[p] = foo(*p)
//             total += cache[p]
//     else:
//         red = min(init_n,t)
//         p = (init_n-red,t-red)
//         cache[p] = foo(*p)
//         total += cache[p]
//     return total
//
// np.sum([foo(e,256) for e in res])

// BETTER alternative solution by Aarón Jerónimo
// T = 256
// with open('day6.txt','r') as ifile:
//     res = [int(x) for x in ifile.read().split(',')]
//
// counter = [0]*9
// for v in res:
//     counter[v] += 1
//
// for _ in range(T):
//     aux = counter[0]
//     for i in range(8):
//         counter[i] = counter[i+1]
//     counter[6] += aux
//     counter[8] = aux
//
// sum(counter)
void ex6() async {
  final input = await File('inputs/day6.txt')
      .openRead()
      .map(utf8.decode)
      .transform(LineSplitter())
      .map((e) => e.split(',').map(int.parse))
      .first;

  DPSolverDay6 solver = DPSolverDay6();

  //Ex6_1
  int days = 80;
  print(
      'ex6_1 : ${input.map((e) => solver.get(e, days)).reduce((v, e) => v + e)}');
  days = 256;
  print(
      'ex6_2 : ${input.map((e) => solver.get(e, days)).reduce((v, e) => v + e)}');
}

int median(List<int> list) {
  list.sort();
  var length = list.length;
  if (length % 2 == 1) {
    return list[(length / 2 + 0.5).toInt()];
  } else {
    return ((list[length ~/ 2] + list[length ~/ 2 + 1]) ~/ 2);
  }
}

int eval71(Iterable<int> l, int i) {
  return l.map((e) => (e - i).abs()).reduce((a, b) => a + b);
}

int eval72(Iterable<int> l, int i) {
  return l
      .map((e) => (e - i).abs())
      .map((e) => ((e + 1) * e / 2).round())
      .reduce((a, b) => a + b);
}

void ex7() async {
  List<int> input = (await File('inputs/day7.txt')
          .openRead()
          .map(utf8.decode)
          .transform(LineSplitter())
          .map((e) => e.split(',').map(int.parse))
          .first)
      .toList()
    ..sort();

  int sol1 = eval71(input, input[(input.length / 2).round()]);

  int imin = input.reduce(min);
  int imax = input.reduce(max);
  int sol2 = [for (int i = imin; i <= imax; i++) eval72(input, i)].reduce(min);

  print('ex7_1 : ${sol1}');
  print('ex7_2 : ${sol2}');
}

void main(List<String> arguments) {
  // ex1();
  // ex2();
  // ex3();
  // ex4();
  // ex5();
  // ex6();
  ex7();
}
