import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';
import 'dart:io';
import 'dart:convert';
import 'package:scidart/numdart.dart';
import 'package:quiver/iterables.dart' as iter;

// Day 1
List<int> movingSum(List<int> fields, int n) {
  final tempList = <List<int>>[];
  for (int i = 0; i < n; i++) {
    tempList.add(fields.sublist(i, fields.length - (n - i - 1)));
  }
  return iter
      .zip(tempList) // Make tuples
      .map((e) => e.reduce((value, element) => value + element)) // Sum tuples
      .toList();
}

int countIncreasing(List<int> fields) {
  return iter
      .zip([
        fields.sublist(1),
        fields.sublist(0, fields.length - 1)
      ]) // Take in pairs
      .where((v) => v[0] > v[1]) // Filter increasing
      .length; // List length
}

// Day 2
enum D2Instruction { down, up, forward }
D2Instruction d2insMap(String k) {
  if (k == 'down') {
    return D2Instruction.down;
  } else if (k == 'up') {
    return D2Instruction.up;
  } else if (k == 'forward') {
    return D2Instruction.forward;
  } else {
    throw Exception();
  }
}

class D2In {
  late D2Instruction i;
  late int v;
  D2In(this.i, this.v);
}

class D2Pos {
  int horizontal = 0;
  int depth = 0;
  int aim = 0;
}

//Day 3
Iterable<num> meanVector(List<List<int>> l) {
  int s = l.length;
  return l
      .reduce(// Sum all vectors
          (a, b) => iter
              .zip<int>([a, b]) // For each value
              .map((a) => a[0] + a[1])
              .toList() // Sum value
          )
      .map((a) => (a / s)); // Mean
}

int binToList(List<int> l) {
  return l.reversed // MSB to the right
      .mapIndexed((i, v) => pow(2, i) * v) // 2**i
      .reduce((a, b) => a + b) // sum
      .round(); // num to int
}

// Day 4
// with open('day4.txt','r') as ifile:
//     numbers = [int(x) for x in ifile.readline()[:-1].split(',')]
//     boards =  [
//         [[int(x) for x in row.split()] for row in board.split("\n")] # Board matrix
//         for board
//         in ifile.read()[1:] # Drop first newline
//         .split("\n\n")]     # Split by doble newline
//
// boards = [Board(b) for b in boards]
Future<Tuple2<List<int>, List<List<List<int>>>>> parseBoardsStream(
    String path) async {
  final fields = await File(path)
      .openRead()
      .map(utf8.decode)
      .transform(LineSplitter())
      .toList();
  final numbers = (fields.first).split(",").map(int.parse).toList();
  final lines = (fields.sublist(1).where((element) {
    return element != "";
  }).map((e) => e
      .replaceAll(RegExp(r"^ +"), "") // Drop initial space
      .split(RegExp(r" +")) // Split by space
      .map(int.parse)
      .toList())).toList(); // Parse to Int
  final boards =
      lines.foldIndexed(<List<List<int>>>[], (index, previous, element) {
    final l = previous as List<List<List<int>>>;
    if (index % 5 == 0) {
      l.add([]);
    }
    l.last.add(element);
    return l;
  });
  return Tuple2(numbers, boards);
}

// class Board:
//     def __init__(self,m):
//         self.m = np.array(m)
//         self.selected = np.zeros(self.m.shape,dtype=bool)
//
//     def update_selected(self,true_idxs):
//         self.selected[true_idxs] = True
//         return self.selected.all(0).any() or self.selected.all(1).any()
//
//     def unselected_sum(self):
//         return self.m[~self.selected].sum()
//
//     def add(self,n):
//         isin_idxs = (self.m == n).nonzero()
//         isin = isin_idxs[0].size > 0
//         return isin and self.update_selected(isin_idxs)
class Board {
  late List<int> rowsSelected;
  late List<int> colsSelected;
  late List<List<bool>> selected;
  late List<List<int>> m;
  Board(this.m) {
    reset();
  }

  bool select(int i, int j) {
    bool win = false;
    selected[i][j] = true;
    win = (rowsSelected[i] += 1) == m.length;
    win = win | ((colsSelected[j] += 1) == m[0].length);
    return win;
  }

  bool add(int n) {
    bool isin = false;
    bool win = false;
    for (int i = 0; !isin && i < m.length; i++) {
      for (int j = 0; !isin && j < m[i].length; j++) {
        isin = m[i][j] == n;
        win = isin ? select(i, j) : false;
      }
    }
    return win;
  }

  int unselectedSum() {
    int total = 0;
    for (int i = 0; i < m.length; i++) {
      for (int j = 0; j < m[0].length; j++) {
        total += selected[i][j] ? 0 : m[i][j];
      }
    }
    return total;
  }

  void reset() {
    rowsSelected = [for (int i = 0; i < m.length; i++) 0];
    colsSelected = [for (int i = 0; i < m[0].length; i++) 0];
    selected = m.map((r) => r.map((e) => false).toList()).toList();
  }
}

// Day 5
Iterable<List<int>> interpolatedList(List<List<int>> l) {
  int targetSize =
      max((l[1][0] - l[0][0]).abs() + 1, (l[1][1] - l[0][1]).abs() + 1);
  var e = iter.zip([
    // Rows -> Cols
    for (int i in [0, 1])
      linspace(l[0][i].toDouble(), l[1][i].toDouble(), num: targetSize)
          .map((e) => e.round())
  ]);
  return e;
}

int countIntersections(List<List<List<int>>> res) {
  Map<String, int> d = {};
  iter.concat(res.map(interpolatedList)).forEach(
      (p) => d.update('${p[0]}_${p[1]}', (v) => v + 1, ifAbsent: () => 1));
  return d.values.where((element) => element > 1).length;
}

// Day 6
// Dynamic programming solver
class DPSolverDay6 {
  Map<String, int> cache = {};

  String _key(int init_n, int t) {
    return '${init_n}_${t}';
  }

  int get(int init_n, int t) {
    String k = _key(init_n, t);
    if (cache.containsKey(k)) {
      return cache[k]!;
    }
    if (t < 0) {
      return 0;
    }
    if (t == 0) {
      return 1;
    }

    int total = 0;
    if (init_n == 0) {
      for (var v in [
        [6, t - 1],
        [8, t - 1]
      ]) {
        total += cache[_key(v[0], v[1])] = get(v[0], v[1]);
      }
    } else {
      int reduction = min(init_n, t);
      total += cache[_key(init_n - reduction, t - reduction)] =
          get(init_n - reduction, t - reduction);
    }
    return total;
  }
}
