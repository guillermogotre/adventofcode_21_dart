import 'package:advent_sols/auxtools.dart';
import 'package:test/test.dart';

void main() {
  test('moving_sum', () {
    final l = [1,2,3,4];
    expect(moving_sum(l,2), [3,5,7]);
  });
  test('count_increasing', () {
    final l = [1,2,2,1];
    expect(count_increasing(l), 1);
  });
}
