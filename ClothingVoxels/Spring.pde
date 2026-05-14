class Spring {
  PVector p1, p2;

  float KS; // Strength constant
  float restLenght; // rest lenght of each spring
  float maxDisplacement; // rest lenght of each spring

  Spring(PVector _p1, PVector _p2, float _KS, float _rl, float _maxDisplacement) {
    p1 = _p1;
    p2 = _p2;

    KS = _KS;
    restLenght = _rl;
    maxDisplacement = _maxDisplacement;
  }

  // B pulls A
  PVector ApplySpringBA() {
    PVector vector = new PVector(p1.x - p2.x, p1.y - p2.y, p1.z - p2.z);
    float module = moduleVector(vector);
    PVector forceVector = new PVector();

    if (module > 0) {
      normalizeVector(vector);

      float displacement = module - restLength;

      //Limit the total displacement
      if (displacement > maxDisplacement) displacement = maxDisplacement;
      if (displacement < -maxDisplacement) displacement = -maxDisplacement;

      float force = KS * displacement;

      forceVector = new PVector(vector.x * force, vector.y * force, vector.z * force);
    }

    return forceVector;
  }

  // A pulls B
  PVector ApplySpringAB() {
    PVector vector = new PVector(p2.x - p1.x, p2.y - p1.y, p2.z - p1.z);
    float module = moduleVector(vector);
    PVector forceVector = new PVector();

    if (module > 0) {
      normalizeVector(vector);
      float displacement = module - restLength;

      //Limit the total displacement
      if (displacement > maxDisplacement) displacement = maxDisplacement;
      if (displacement < -maxDisplacement) displacement = -maxDisplacement;


      float force = KS * displacement;
      forceVector = new PVector(vector.x * force, vector.y * force, vector.z * force);
    }

    return forceVector;
  }

  void DrawString() {
    stroke(col);
    line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
  }
}
