class Spring extends renderer {
  Particle p1, p2;
  float KS; // Strength constant
  float restLenght; // rest lenght of each spring
  float maxDisplacement; // rest lenght of each spring

  Spring(Particle _p1, Particle _p2, float _KS, float _rl) {
    p1 = _p1;
    p2 = _p2;
    KS = _KS;
    restLenght = _rl;
  }

  // B pulls A
  void ApplySpringBA() {
    PVector vector = new PVector(p1.pos.x - p2.pos.x, p1.pos.y - p2.pos.y, p1.pos.z - p2.pos.z);
    float vectorModule = moduleVector(vector);
    PVector forceVector = new PVector();

    if (vectorModule > 0) {
      normalizeVector(vector);

      float displacement = vectorModule - restLenght;

      float force = KS * displacement;

      forceVector = new PVector(vector.x * force, vector.y * force, vector.z * force);
    }
    if (!p1.isStatic) {
      p1.pForce.x -= forceVector.x;
      p1.pForce.y -= forceVector.y;
      p1.pForce.z -= forceVector.z;
    }
  }

  // A pulls B
  void ApplySpringAB() {
    PVector vector = new PVector(p2.pos.x - p1.pos.x, p2.pos.y - p1.pos.y, p2.pos.z - p1.pos.z);
    float vectorModule = moduleVector(vector);
    PVector forceVector = new PVector();

    if (vectorModule > 0) {
      normalizeVector(vector);
      float displacement = vectorModule - restLenght;

      float force = KS * displacement;
      forceVector = new PVector(vector.x * force, vector.y * force, vector.z * force);
    }

    if (!p2.isStatic) {
      p2.pForce.x -= forceVector.x;
      p2.pForce.y -= forceVector.y;
      p2.pForce.z -= forceVector.z;
    }
  }

  @Override
    void Draw() {
    stroke(col);
    line(p1.pos.x - width / 2, p1.pos.y - height / 2, p1.pos.z, p2.pos.x - width / 2, p2.pos.y - height / 2, p2.pos.z);
  }
}
