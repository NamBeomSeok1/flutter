Iterable<int> i;
int sumNumbersInArray(Iterable<int> i) {
  var totalSum = 0;
  for (var a in i) {
    totalSum = totalSum + a;
  }
  return totalSum;
}

main() {
  print(sumNumbersInArray([1, 2, 3, 4]));
}
