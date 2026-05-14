class Particle extends renderer {
  //Atributes
  float pMass;
  PVector pVelocity = new PVector(0, 0);
  PVector pAcceleration = new PVector(0, 0);
  boolean isStatic = false;
  float lifeTime;
  PVector pForce = new PVector(0, 0);
  //Constructor
  Particle(PVector _initialPos) {
    col = color (255, 100, 100);
    size = new PVector(20, 20, 20);
    pMass = 1;
    pos = _initialPos;
    isStatic = false;
  }
   Particle(PVector _initialPos, boolean _isStatic) {
    col = color (255, 100, 100);
    size = new PVector(20, 20, 20);
    pMass = 1;
    pos = _initialPos;
    isStatic = _isStatic;
  }
  //Methods
  void ParticleMove() {
    float tInc = 0.04;
    float KD = -0.3; //Damping const (negative)
    
    if(isStatic) return;
    
    //Gravity
    pForce.x += 0;
    pForce.y += 9.81;

    //Damping
    pForce.x += KD * pVelocity.x;
    pForce.y += KD * pVelocity.y;

    pAcceleration.x = pForce.x/pMass;
    pAcceleration.y = pForce.y/pMass;
    
    //Velocity via acceleration
    pVelocity.x = pVelocity.x + tInc * pAcceleration.x;
    pVelocity.y = pVelocity.y + tInc * pAcceleration.y;

    //Position via velocity
    pos.x = pos.x + tInc * pVelocity.x;
    pos.y = pos.y + tInc * pVelocity.y;
  }

  void Draw() {
    push();
    translate(pos.x, pos.y, pos.z);
    fill(col);
    sphere(size.x);
    pop();
  }
}
