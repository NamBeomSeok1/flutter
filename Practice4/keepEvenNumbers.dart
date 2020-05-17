Iterable<int> keepEvenNumbers(Iterable<int> Ary) {
  var evenAry = Ary.where((Ary) => Ary.isEven);
  for (final a in evenAry) {
    print("$a is Even");
  }
  return evenAry;
}

main() {
  keepEvenNumbers([1, 4, 5, 7, 8]);
}
