class Spring {
  PVector p1 ,p2; 
  
  float KS; // Strength constant
  float restLenght; // rest lenght of each spring

  Spring(PVector _p1, PVector _p2, float _KS, float _rl) {
    p1 = _p1;
    p2 = _p2;
    
    KS = _KS;
    restLenght = _rl;
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
  
  void DrawString() {
     
  }
}
