// ignore_for_file: constant_identifier_names

enum Piece {
  Cross,
  Zero;

  Piece operator +(int units) {
    final numberofItems = Piece.values.length;

    final index = (this.index + units) % numberofItems;

    return Piece.values[index];
  }

  Piece operator -(int units) {
    final numberofItems = Piece.values.length;

    final index = (this.index + units).abs() % numberofItems;

    return Piece.values[index];
  }
}
