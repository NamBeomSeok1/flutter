Iterable<int> keepEvenNumbers(Iterable<int> numbers) {
  final evenNumbers = numbers.where((numbers) => numbers.isEven);

  return evenNumbers;
}

main() {
  print(keepEvenNumbers([1, 4, 5, 7, 8]));
}
