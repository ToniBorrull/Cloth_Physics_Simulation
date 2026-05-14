class Particle {
  //Atributes
  color pColor;
  float pSize;
  float pMass;
  PVector pPosition = new PVector(0, 0);
  PVector pVelocity = new PVector(0, 0);
  PVector pAcceleration = new PVector(0, 0);
  boolean isStatic = false;
  float lifeTime;
  PVector pForce = new PVector(0, 0);
  //Constructor
  Particle(PVector _initialPos) {
    pColor = color (255, 100, 100);
    pSize = 20;
    pMass = 1;
    pPosition = _initialPos;
  }
   Particle(PVector _initialPos, boolean _isStatic) {
    pColor = color (255, 100, 100);
    pSize = 20;
    pMass = 1;
    pPosition = _initialPos;
    isStatic = _isStatic;
  }
  //Methods
  void ParticleMove() {
    float tInc = 0.04;
    float KD = -0.3; //Damping const (negative)
    
    if(isStatic) return;
    
    //Acceleration via forces
    //All forces should be here
    
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
    pPosition.x = pPosition.x + tInc * pVelocity.x;
    pPosition.y = pPosition.y + tInc * pVelocity.y;
  }

  void ParticleDraw() {
    println(pVelocity);
    fill(pColor);
    ellipse(pPosition.x, pPosition.y, pSize, pSize);
  }
}
