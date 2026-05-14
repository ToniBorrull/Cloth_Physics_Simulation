float gravity = 2;
float tInc = 0.04;
 
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
  
  void ResetForces(){ 
    pForce.x = 0;
    pForce.y = 0;
    pForce.z = 0;
  }
  //Methods
  void ParticleMove() {
   
    float KD = -0.3; //Damping const (negative)
    
    if(isStatic) return;

    
    //Gravity
    pForce.y += gravity;

    //Damping
    pForce.x += KD * pVelocity.x;
    pForce.y += KD * pVelocity.y;
    pForce.z += KD * pVelocity.z;

    pAcceleration.x = pForce.x/pMass;
    pAcceleration.y = pForce.y/pMass;
    pAcceleration.z = pForce.z/pMass;
    
    //Velocity via acceleration
    pVelocity.x = pVelocity.x + tInc * pAcceleration.x;
    pVelocity.y = pVelocity.y + tInc * pAcceleration.y;
    pVelocity.z = pVelocity.z + tInc * pAcceleration.z;

    //Position via velocity
    pos.x = pos.x + tInc * pVelocity.x;
    pos.y = pos.y + tInc * pVelocity.y;
    pos.z = pos.z + tInc * pVelocity.z;
  }

@Override
  void Draw() {
    push();
    noStroke();
    translate(pos.x, pos.y, pos.z);
    fill(col);
    sphere(size.x);
    pop();
  }
}
