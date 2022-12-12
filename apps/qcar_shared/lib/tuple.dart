class Tuple<E1, E2> {
  Tuple(this.first, this.second);

  final E1? first;
  final E2? second;

  E1 get firstOrThrow => first!;
  E2 get secondOrThrow => second!;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Tuple &&
              first == other.first &&
              second == other.second;
}

class Triple<E1, E2, E3> {
  Triple(this.first, this.middle, this.last);

  final E1? first;
  final E2? middle;
  final E3? last;

  E1 get firstOrThrow => first!;
  E2 get middleOrThrow => middle!;
  E3 get lastOrThrow => last!;

  @override
  int get hashCode => first.hashCode ^ middle.hashCode ^ last.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Triple &&
              first == other.first &&
              middle == other.middle &&
              last == other.last;
}
