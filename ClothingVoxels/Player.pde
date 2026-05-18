float gravityPlayer = 1  ;

class Player {
  PVector position;
  PVector force = new PVector();
  PVector velocity = new PVector();;
  PVector acceleration = new PVector();;
  
  float mass;
  float hitboxSize;

  Player(PVector _position, float _mass, float _hS) {
    position = _position;
    mass = _mass;
    hitboxSize = _hS;
  }

  void ResetForces() {
    force.x = 0;
    force.y = 0;
    force.z = 0;
  }

  void MovePlayer() {

    float KD = -0.3; //Damping const (negative)

    //Gravity
    force.y += gravityPlayer;

    //Damping
    force.x += KD * velocity.x;
    force.y += KD * velocity.y;
    force.z += KD * velocity.z;

    acceleration.x = force.x/mass;
    acceleration.y = force.y/mass;
    acceleration.z = force.z/mass;

    //Velocity via acceleration
    velocity.x = velocity.x + tInc * acceleration.x;
    velocity.y = velocity.y + tInc * acceleration.y;
    velocity.z = velocity.z + tInc * acceleration.z;

    //Position via velocity
    position.x = position.x + tInc * velocity.x;
    position.y = position.y + tInc * velocity.y;
    position.z = position.z + tInc * velocity.z;
  }

  void DrawPlayer() {
    push();
    translate(position.x - width/2, position.y-height/2, position.z);
    noStroke();
    fill(255, 0, 0);
    sphere(hitboxSize - 3);
    pop();
  }
}
