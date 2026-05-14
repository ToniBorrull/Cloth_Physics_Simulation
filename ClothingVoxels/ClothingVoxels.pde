//Voxels + Cloth

//Particles Varibles
int cols;
int rows;
Particle[][] cloth;
ArrayList<Spring> springs = new ArrayList<Spring>();

//Voxel
voxel v;


float angleX = 0, angleY = 0;

void setup() {
  size(500, 500, P3D);
  //int posX, int posY, int posZ, float dx, float dy, float dz, float px, float py, float pz, color c
  v = new voxel(width/2, 350, -400, 200, 100, 200, 0, -100, 0, color(200));
  
  cols = 10;
  rows = 10;
  
  cloth = new Particle[cols][rows];
  
  //Generate the particles
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (j == 0){// && (i == 0 || i == cols - 1)) {
        cloth[i][j] = new Particle(new PVector(i * 40, j * 40 + 100, -400), true);
      } else {
        cloth[i][j] = new Particle(new PVector(i * 40, j * 40 + 100, -400));
      }
    }
  }
  
  float dureza = 0.8;
  float restLength = 40;

  //Apply String to each particle
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (i < cols - 1) {
        //PVector _p1, PVector _p2, float _KS, float _rl, float _maxDisplacement
        springs.add(new Spring(cloth[i][j], cloth[i + 1][j], dureza, restLength, 20));
      }

      if (j < rows - 1) {
        //PVector _p1, PVector _p2, float _KS, float _rl, float _maxDisplacement
        springs.add(new Spring(cloth[i][j], cloth[i][j + 1], dureza, restLength, 20));
      }
    }
  }
}

void draw() {
  background(255);

  for(int i = 0; i < cols; i++){
    for(int j = 0; j < rows; j++){
      cloth[i][j].ResetForces();
    }
  }

   
   translate(width/2, height/4, 0);
   rotateX(angleX);
   rotateY(angleY);
   translate(-width/2, -height/4, 0);

  for (Spring s : springs) {
    s.ApplySpringAB();
    s.ApplySpringBA();
    s.Draw();
  }
  
    //Draw the Voxel
   v.Draw();
  
   for (int i = 0; i <cols; i++) {
    for (int j = 0; j < rows; j++) {
      /*if(isInside(cloth[i][j], v)){
        cloth[i][j].pForce.x += v.property_voxel.x;
        cloth[i][j].pForce.y += v.property_voxel.y;
        cloth[i][j].pForce.z += v.property_voxel.z;
      }*/
      cloth[i][j].ParticleMove();
      cloth[i][j].Draw();
    }
  }

  MoveCamera();
}

void MoveCamera() {
  println(angleY);
  if (keyCode == UP) angleX += radians(1);
  if (keyCode == DOWN) angleX -= radians(1);
  if (keyCode == RIGHT) angleY += radians(1);
  if (keyCode == LEFT) angleY -= radians(1);
}

void keyReleased()
{
  keyCode = 0;
}
