enum Turn {
  crossTurn,
  zeroTurn;

  Turn switchTurn(){
   return this == Turn.crossTurn ? Turn.zeroTurn : Turn.crossTurn; 
  }
}
