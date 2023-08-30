//import 'package:equatable/equatable.dart';

import 'package:equatable/equatable.dart';

typedef Position = Pair<int, int>;

class Pair<T, U> extends Equatable {
  final T x;
  final U y;
  Pair(this.x, this.y);

  @override
  List<Object?> get props => [x, y];
}
