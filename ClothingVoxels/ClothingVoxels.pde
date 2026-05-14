//Voxels + Cloth

//Particles Varibles
int cols = 2;
int rows = 2;
Particle[][] cloth;
ArrayList<Spring> springs = new ArrayList<Spring>();

//Voxel
voxel v;


float angleX = 0, angleY = 0;

void setup() {
  size(500, 500, P3D);
  //int posX, int posY, int posZ, float dx, float dy, float dz, float px, float py, float pz, color c
  v = new voxel(width/2, height/2, 0, 100, 100, 100, -5, 0, 0, color(200));
  cloth = new Particle[cols][rows];
  //Generate the particles
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if ((i == 0 && j == 0) || (i == 0 && j == (rows - 1))) {
        cloth[i][j] = new Particle(new PVector(i * 100, 100, -400), true);
      } else {
        cloth[i][j] = new Particle(new PVector(i * 100, 300, -400));
      }
    }
  }

  //Apply String to each particle
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (i < cols - 2) {
        //PVector _p1, PVector _p2, float _KS, float _rl, float _maxDisplacement
        springs.add(new Spring(cloth[i][j], cloth[i + 1][j], 0.5, 5, 10));
      }

      if (j < rows - 2) {
        //PVector _p1, PVector _p2, float _KS, float _rl, float _maxDisplacement
        springs.add(new Spring(cloth[i][j], cloth[i][j + 1], 0.5, 5, 10));
      }
    }
  }
}

void draw() {
  background(255);
  v.Draw();


  rotateX(angleX);
  rotateY(angleY);

 

  for (Spring s : springs) {
    s.ApplySpringAB();
    s.ApplySpringBA();
    s.Draw();
  }
  
   for (int i = 0; i <cols; i++) {
    for (int j = 0; j < rows; j++) {
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
