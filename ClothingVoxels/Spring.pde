//Eel class that uses the Tail Particle
class Eel extends Fish {
  //Number of total particles
  int numNodes = 4; 
  ArrayList<TailParticle> tail = new ArrayList<TailParticle>();
  
  //Spring vars
  float KS = 0.5; // Strength constant
  float rest_length = 25.0; // rest lenght of each spring

  Eel(color _pColor, float _pSize, float _pMass, PVector _initialPos, PVector _initialVelocity) {
    super(_pColor, _pSize, _pMass, _initialPos, _initialVelocity);

    // Tail
    for (int i = 0; i < numNodes; i++) {
      PVector startPos = new PVector(_initialPos.x - (i + 1) * rest_length, _initialPos.y, _initialPos.z);
      tail.add(new TailParticle(startPos, _pMass * 0.5, _pSize * 0.6));
    }
    
    model = eelModel;
  }

  @Override
  void ParticleMove() {
    super.ParticleMove();

    //Tail forces are 0 (no intentions)
    for (int i = 0; i < numNodes; i++) {
      tail.get(i).tForce.x = 0;
      tail.get(i).tForce.y = 0;
      tail.get(i).tForce.z = 0;
   }

    //Hooke's law
    //Force from the head to the first part
    ApplySpring(this.pPosition, tail.get(0));

    // tail particles
    for (int i = 0; i < numNodes - 1; i++) {
      ApplySpring(tail.get(i).tPosition, tail.get(i+1));
      ApplySpringBackwards(tail.get(i), tail.get(i+1));
    }

    // Tail movement
    for (int i = 0; i < numNodes; i++) {
      tail.get(i).UpdatePhysics();
    }
  }

 // B pulls A
  void ApplySpring(PVector posA, TailParticle pB) {
    PVector dir = new PVector(posA.x - pB.tPosition.x, posA.y - pB.tPosition.y, posA.z - pB.tPosition.z);
    float d = moduleVector(dir);

    if (d > 0) {
      normalizeVector(dir);
      float displacement = d - rest_length;
      
      //Limit the total displacement
      float maxDisplacement = 15.0;
      if(displacement > maxDisplacement) displacement = maxDisplacement;
      if(displacement < -maxDisplacement) displacement = -maxDisplacement;
      
      float force = KS * displacement;

      pB.tForce.x += dir.x * force;
      pB.tForce.y += dir.y * force;
      pB.tForce.z += dir.z * force;
    }
  }

  // A pulls B
  void ApplySpringBackwards(TailParticle pA, TailParticle pB) {
    PVector dir = new PVector(pB.tPosition.x - pA.tPosition.x, pB.tPosition.y - pA.tPosition.y, pB.tPosition.z - pA.tPosition.z);
    float d = moduleVector(dir);

    if (d > 0) {
      normalizeVector(dir);
      float displacement = d - rest_length;
      
      //Limit the total displacement
      //Less than the previous because the head only pulls backwards and separates a lot more
      float maxDisplacement = 6;
      if(displacement > maxDisplacement) displacement = maxDisplacement;
      if(displacement < -maxDisplacement) displacement = -maxDisplacement;
      
      
      float force = KS * displacement;

      pA.tForce.x += dir.x * force;
      pA.tForce.y += dir.y * force;
      pA.tForce.z += dir.z * force;
    }
  }

  @Override
  void ParticleDraw() {
    if (destroyed) return;
      //Draw head
    super.ParticleDraw(); 

    // Draw tial
    for (int i = 0; i < numNodes; i++) {
      tail.get(i).DrawParticle();
    }

    // Debug purposes (tail)
    
    strokeWeight(2);
    stroke(255, 100);
    line(pPosition.x, pPosition.y, pPosition.z, tail.get(0).tPosition.x, tail.get(0).tPosition.y, tail.get(0).tPosition.z);
    for (int i = 0; i < numNodes - 1; i++) {
      line(tail.get(i).tPosition.x, tail.get(i).tPosition.y, tail.get(i).tPosition.z, tail.get(i+1).tPosition.x, tail.get(i+1).tPosition.y, tail.get(i+1).tPosition.z);
    }
  }
}
