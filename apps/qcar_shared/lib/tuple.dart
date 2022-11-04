class Tuple<E1, E2> {
  Tuple(this.first, this.second);

  final E1? first;
  final E2? second;

  E1 get firstOrThrow => first!;
  E2 get secondOrThrow => second!;
}

class Triple<E1, E2, E3> {
  Triple(this.first, this.middle, this.last);

  final E1? first;
  final E2? middle;
  final E3? last;

  E1 get firstOrThrow => first!;
  E2 get middleOrThrow => middle!;
  E3 get lastOrThrow => last!;
}
